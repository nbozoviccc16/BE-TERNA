page 70104 "Auth. Token List"
{
    PageType = List;
    ApplicationArea = All;

    SourceTable = "Auth. Token";
    UsageCategory = Lists;
    CardPageID = 70103;

    layout
    {
        area(Content)
        {
            repeater(General)
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