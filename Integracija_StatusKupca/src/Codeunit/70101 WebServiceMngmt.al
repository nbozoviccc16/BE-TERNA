codeunit 70101 "WebServiceMngmt"
{
    Permissions = tabledata "Demo User" = RIMD,
                  tabledata "Auth. Token" = RMID;

    //AuthenticationAndToken
    procedure AuthenticationAndToken(inputJson: Text): Text[2048]
    var
        JsonToken: JsonToken;
        Input: JsonObject;
        Username: Code[50];
        Password: Text[100];

        DemoUser: Record "Demo User";
        AuthTokenRec: Record "Auth. Token";
        NewGuid: Guid;
        Expires: DateTime;
        CurrentDateTime: DateTime;

        Token: Text[2048];

    begin
        if Input.ReadFrom(inputJson) = false then
            Error('Empty input.');

        if (Input.Get('username', JsonToken)) AND (JsonToken.AsValue().AsCode() <> '') then begin
            Username := JsonToken.AsValue().AsCode();
            //check username
            DemoUser.SetFilter("Username", Username);
            if not DemoUser.FindFirst() then
                Error('Invalid demo username credentials.');
        end else
            Error('Empty username.');

        Clear(JsonToken);

        if (Input.Get('password', JsonToken)) And (JsonToken.AsValue().AsText() <> '') then begin
            Password := JsonToken.AsValue().AsText();
            //check password
            if DemoUser.Password <> Password then
                Error('Invalid demo password credentials.');
        end else
            Error('Empty password.');

        //generate token
        NewGuid := CreateGuid();

        //generate hashed token
        Token := SHA256Hash(Username + Password);

        //token expiration
        CurrentDateTime := CurrentDateTime();
        Expires := CurrentDateTime + 120000;

        //validate token request
        AuthTokenRec.Init();
        AuthTokenRec."Token ID" := NewGuid;
        AuthTokenRec."Username" := Username;
        AuthTokenRec."Token" := Token;
        AuthTokenRec."Expires" := Expires;

        if AuthTokenRec.Insert() = true then
            exit(Token);
    end;

    //SHA256Hash
    procedure SHA256Hash(Input: Text): Text
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        exit(CryptographyManagement.GenerateHash(Input, HashAlgorithmType::SHA256));
    end;


    //GetCompanyInformationWithValidToken
    procedure GetCompanyInformationWithValidToken(inputJson: Text): Text[2048]
    var
        CompanyInfo: Record "Company Info";
        JsonToken: JsonToken;
        Input: JsonObject;
        GrantedToken: Text[2048];
        Id: Integer;
        SocialSecurityNumber: Code[8];
        TaxIdentificationNumber: Code[9];
        AbbreviatedCompanyName: Text[100];
        BusinessRating: Code[5];
        NumberofEmployees: Integer;
        CompanyStatus: Enum "Company Status";
        BlockDate: DateTime;
        AuthToken: Record "Auth. Token";
        IsValidToken: Boolean;

        TypeHelper: Codeunit "Type Helper";

        Response: JsonObject;
        Company: JsonObject;
        JsonText: Text;
        ResponseContent: HttpContent;

        ResponseMessage: HttpResponseMessage;
    begin
        if Input.ReadFrom(inputJson) = false then
            Error('Empty input.');

        //token validation
        if (Input.Get('grantedToken', JsonToken)) AND (JsonToken.AsValue().AsText() <> '') then begin
            GrantedToken := JsonToken.AsValue().AsText();
            AuthToken.SetCurrentKey(Expires);
            AuthToken.Ascending(false);
            AuthToken.SetFilter(Token, GrantedToken);
            if AuthToken.FindFirst() then begin
                //Error('%1, %2', AuthToken.Expires, CurrentDateTime());

                if AuthToken.Expires.Time() > CurrentDateTime().Time() then
                    IsValidToken := true
                else
                    IsValidToken := false;
            end;
        end else begin
            Error('Empty granted Token.');
        end;

        if IsValidToken = true then begin
            //company info validation
            if (Input.Get('socialSecurityNumber', JsonToken)) AND (JsonToken.AsValue().AsCode() <> '') then
                SocialSecurityNumber := JsonToken.AsValue().AsCode()
            else
                Error('Empty socialSecurityNumber.');

            if (Input.Get('taxIdentificationNumber', JsonToken)) AND (JsonToken.AsValue().AsCode() <> '') then
                TaxIdentificationNumber := JsonToken.AsValue().AsCode()
            else
                Error('Empty taxIdentificationNumber.');

            CompanyInfo.SetFilter(CompanyInfo."Social Security Number", SocialSecurityNumber);
            CompanyInfo.SetFilter(CompanyInfo."Tax Identification Number", TaxIdentificationNumber);
            if CompanyInfo.FindFirst() then begin
                //company info
                Id := CompanyInfo."Id";
                AbbreviatedCompanyName := CompanyInfo."Abbreviated Company Name";
                BusinessRating := CompanyInfo."Business Rating";
                NumberofEmployees := CompanyInfo."Number of Employees";
                CompanyStatus := CompanyInfo."Company Status";
                BlockDate := CompanyInfo."Block Date";

                //json
                Clear(Company);
                Company.Add('id', Id);
                Company.Add('socialSecurityNumber', SocialSecurityNumber);
                Company.Add('taxIdentificationNumber', TaxIdentificationNumber);
                Company.Add('abbreviatedCompanyName', AbbreviatedCompanyName);
                Company.Add('businessRating', BusinessRating);
                Company.Add('numberofEmployees', NumberofEmployees);
                Company.Add('companyStatus', Format(CompanyStatus));
                Company.Add('blockDate', BlockDate);

                Clear(Response);
                Response.Add('company', Company);
                Response.Add('success', true);
                Response.Add('warning', false);
                Response.Add('message', 'Company sucessfully found.');

                Response.WriteTo(JsonText);
                exit(JsonText);

            end else begin
                Clear(Response);
                Response.Add('company', Company);
                Response.Add('success', false);
                Response.Add('warning', true);
                Response.Add('message', 'Company was not found.');

                Response.WriteTo(JsonText);
                exit(JsonText);
            end;
        end;
    end;
}
