page 70101 "Demo User Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Demo User";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
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
                field("Allowed to unblock Customer"; Rec."Allowed to unblock Customer")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}