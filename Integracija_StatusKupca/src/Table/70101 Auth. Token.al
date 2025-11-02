table 70101 "Auth. Token"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Token ID"; Guid) { }
        field(2; "Username"; Code[50]) { }
        field(3; "Token"; Text[100]) { }
        field(4; "Expires"; DateTime) { }
    }

    keys
    {
        key(PK; "Token ID") { Clustered = true; }
        key(TokenKey; "Token") { }
    }
}