table 70103 "Company Info"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ID"; Integer) { }
        field(2; "Social Security Number"; Code[8]) { } //maticni broj firme
        field(3; "Tax Identification Number"; Code[9]) { } //poreski identifikacioni broj
        field(4; "Abbreviated Company Name"; Text[100]) { }
        field(5; "Business Rating"; Code[5]) { }
        field(6; "Number of Employees"; Integer) { }
        field(7; "Company Status"; Enum "Company Status") { }
        field(8; "Block Date"; DateTime) { }
    }

    keys
    {
        key(PK; "ID") { Clustered = true; }
    }

    trigger OnInsert()
    var
        CompanyInfo: Record "Company Info";
    begin
        CompanyInfo.Reset();
        if CompanyInfo.FindLast() then begin
            ID := CompanyInfo.ID + 1;
        end else begin
            ID := 1;
        end;
    end;
}