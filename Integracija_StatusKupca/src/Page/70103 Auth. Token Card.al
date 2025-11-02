page 70103 "Auth. Token Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Auth. Token";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Token ID"; Rec."Token ID")
                {
                    ApplicationArea = All;
                }
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                }
                field(Token; Rec.Token)
                {
                    ApplicationArea = All;
                }
                field(Expires; Rec.Expires)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}