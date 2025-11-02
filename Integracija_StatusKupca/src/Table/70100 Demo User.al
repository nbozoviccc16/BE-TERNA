table 70100 "Demo User"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Integer) { }
        field(2; "Username"; Code[50]) { }
        field(3; "Password"; Text[100]) { }
        field(4; "Allowed to unblock Customer"; Boolean) { }
    }

    keys
    {
        key(PK; "User ID") { Clustered = true; }
        key(Username; "Username") { }
    }
}