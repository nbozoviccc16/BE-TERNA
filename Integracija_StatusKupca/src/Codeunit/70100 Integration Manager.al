codeunit 70100 "Integration Manager"
{
    SingleInstance = true;

    //HttpRequestAuthenticateWithBasicAuth
    procedure HttpRequestAuthenticateWithBasicAuth(): Text[2048]
    var
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Base64Convert: Codeunit "Base64 Convert";
        Response: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        GrantedToken: JsonValue;
        ContentHeaders: HttpHeaders;
        HttpContent: HttpContent;

        //IntegrationSetup
        IntegrationSetup: Record "Integration Setup";
        Username: Code[50];
        Password: Text[100];
        DemoUserUsername: Code[50];
        DemoUserPassword: Text[100];
        AuthenticateURL: Text[2048];
        GrantedTokenFormated: Text[2048];

    begin
        //get Authorization credentials
        IntegrationSetup.Get();
        if IntegrationSetup."Username" <> '' then
            Username := IntegrationSetup."Username";
        if IntegrationSetup."Password" <> '' then
            Password := IntegrationSetup."Password";
        if IntegrationSetup."Demo User Username" <> '' then
            DemoUserUsername := IntegrationSetup."Demo User Username";
        if IntegrationSetup."Demo User Password" <> '' then
            DemoUserPassword := IntegrationSetup."Demo User Password";
        if IntegrationSetup."Authenticate URL" <> '' then
            AuthenticateURL := IntegrationSetup."Authenticate URL";

        //preform http request
        RequestMessage.SetRequestUri(AuthenticateURL);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Basic ' + Base64Convert.ToBase64(Username + ':' + Password));

        HttpContent.WriteFrom('{"inputJson": "{\"username\":\"' + DemoUserUsername + '\",\"password\":\"' + DemoUserPassword + '\"}"}');
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);

        if HttpClient.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            if ResponseMessage.IsSuccessStatusCode then begin
                JsonResponse.ReadFrom(Response);
                if JsonResponse.Get('value', JsonToken) then begin
                    GrantedToken := JsonToken.AsValue();
                    GrantedTokenFormated := DelChr(Format(GrantedToken), '=', '"');
                    exit(GrantedTokenFormated);
                end;
            end else begin
                Message('Request failed!: %1', Response);
            end;
        end;
    end;

    //HttpRequestGetCompanyInformation
    procedure HttpRequestGetCompanyInformation(GrantedToken: Text[100]; SocialSecurityNumber: Code[8]; TaxIdentificationNumber: Code[9])
    var
        HttpClient: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        Base64Convert: Codeunit "Base64 Convert";
        Response: Text;
        //JsonResponse: JsonObject;
        JsonToken: JsonToken;
        //GrantedToken: JsonValue;
        ContentHeaders: HttpHeaders;
        HttpContent: HttpContent;

        //IntegrationSetup
        IntegrationSetup: Record "Integration Setup";
        Username: Code[50];
        Password: Text[100];
        DemoUserUsername: Code[50];
        DemoUserPassword: Text[100];
        CompanyInfoURL: Text[2048];

        ResponseJson: JsonObject;
        InnerJson: JsonObject;
        CompanyJson: JsonObject;
        ValueText: Text;
        Token: JsonToken;
        ValueToken: JsonToken;
        CompanyToken: JsonToken;
        BusinessRating: Code[5];
        NumberofEmployees: Integer;
        _CompanyStatus: Text[100];
        CompanyStatus: Enum "Company Status";
        Blocked: Enum "Customer Blocked";

        //customer to Update
        Customer: Record Customer;
    begin

        //get Authorization credentials
        IntegrationSetup.Get();
        if IntegrationSetup."Username" <> '' then
            Username := IntegrationSetup."Username";
        if IntegrationSetup."Password" <> '' then
            Password := IntegrationSetup."Password";
        if IntegrationSetup."Company Info URL" <> '' then
            CompanyInfoURL := IntegrationSetup."Company Info URL";

        //preform http request
        RequestMessage.SetRequestUri(CompanyInfoURL);
        RequestMessage.Method('POST');
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Basic ' + Base64Convert.ToBase64(Username + ':' + Password));

        HttpContent.WriteFrom('{"inputJson": "{\"grantedToken\":\"' + GrantedToken + '\",\"socialSecurityNumber\":' + SocialSecurityNumber + ',\"taxIdentificationNumber\":' + TaxIdentificationNumber + '}"}'); //json content
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpContent.GetHeaders(ContentHeaders);
        RequestMessage.Content(HttpContent);

        if HttpClient.Send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            ResponseJson.ReadFrom(Response);
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseJson.ReadFrom(Response);
                if ResponseJson.Get('value', ValueToken) then begin
                    ValueText := ValueToken.AsValue().AsText();
                    InnerJson.ReadFrom(ValueText);
                    if InnerJson.Get('company', CompanyToken) then begin
                        CompanyJson := CompanyToken.AsObject();
                        Clear(Token);
                        if CompanyJson.Get('businessRating', Token) then
                            BusinessRating := Token.AsValue().AsText();
                        Clear(Token);
                        if CompanyJson.Get('numberofEmployees', Token) then
                            NumberofEmployees := Token.AsValue().AsInteger();
                        Clear(Token);
                        if CompanyJson.Get('companyStatus', Token) then begin
                            _CompanyStatus := Token.AsValue().AsText();
                            case _CompanyStatus of
                                'Active':
                                    CompanyStatus := CompanyStatus::Active;
                                'No APR Status':
                                    CompanyStatus := CompanyStatus::"No APR Status";
                                'Out jurisdiction of the Register of Business Entities':
                                    CompanyStatus := CompanyStatus::"Out jurisdiction of the Register of Business Entities";
                            end;
                        end;
                    end;
                end;
                //update customer 
                Customer.SetFilter("VAT Registration No.", TaxIdentificationNumber);
                Customer.SetFilter("Registration Number", SocialSecurityNumber);
                if Customer.FindFirst() then begin
                    Customer.Validate("Number of Employees", NumberofEmployees);
                    Customer.Validate("Company Status", CompanyStatus);
                    case Customer."Company Status" of
                        CompanyStatus::Active:
                            Customer.Blocked := Blocked::" ";
                        CompanyStatus::"No APR status":
                            Customer.Blocked := Blocked::"All";
                        CompanyStatus::"Out jurisdiction of the Register of Business Entities":
                            Customer.Blocked := Blocked::"All";
                    end;
                    Customer.Validate("Business Grade", BusinessRating);
                    Customer.Modify(true);
                end;
            end;
        end;
    end;

    //UpdateCustomerStatus
    procedure UpdateCustomerStatus(Customer: Record Customer)
    var
        IntegrationManager: Codeunit "Integration Manager";
        GrantedToken: Text[2048];
    begin
        if (Customer."Registration Number" <> '') AND (Customer."VAT Registration No." <> '') then begin
            GrantedToken := IntegrationManager.HttpRequestAuthenticateWithBasicAuth();
            if GrantedToken <> '' then
                IntegrationManager.HttpRequestGetCompanyInformation(GrantedToken, Customer."Registration Number", Customer."VAT Registration No.");
        end else begin
            Error('Missing Registration Number or VAT Registration No.');
        end;
    end;
}