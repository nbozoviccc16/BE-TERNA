page 70107 "Company Info Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Company Info";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Social Security Number"; Rec."Social Security Number")
                {
                    ApplicationArea = All;
                }
                field("Tax Identification Number"; Rec."Tax Identification Number")
                {
                    ApplicationArea = All;
                }
                field("Abbreviated Company Name"; Rec."Abbreviated Company Name")
                {
                    ApplicationArea = All;
                }
                field("Business Rating"; Rec."Business Rating")
                {
                    ApplicationArea = All;
                }
                field("Number of Employees"; Rec."Number of Employees")
                {
                    ApplicationArea = All;
                }
                field("Company Status"; Rec."Company Status")
                {
                    ApplicationArea = All;
                }
                field("Block Date"; Rec."Block Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}