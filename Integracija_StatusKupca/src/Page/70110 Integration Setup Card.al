page 70110 "Integration Setup Card"
{
    PageType = Card;
    Caption = 'Integration Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Integration Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("Authentication Setup")
            {
                field("Authenticate URL"; Rec."Authenticate URL")
                {
                    ApplicationArea = All;
                }
                field("Company Info URL"; Rec."Company Info URL")
                {
                    ApplicationArea = All;
                }
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                }
            }
            group("Demo User Setup")
            {
                field("Demo User Username"; Rec."Demo User Username")
                {
                    ApplicationArea = All;
                }
                field("Demo User Password"; Rec."Demo User Password")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}