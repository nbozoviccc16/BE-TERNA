table 70104 "Integration Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Authenticate URL"; Text[2048])
        {
            Caption = 'Authenticate URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(3; "Company Info URL"; Text[2048])
        {
            Caption = 'Company Info URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(4; "Username"; Code[50])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
        field(5; "Password"; Text[100])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(6; "Demo User Username"; Code[50])
        {
            Caption = 'Demo User Username';
            DataClassification = CustomerContent;
        }
        field(7; "Demo User Password"; Text[100])
        {
            Caption = 'Demo User Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}