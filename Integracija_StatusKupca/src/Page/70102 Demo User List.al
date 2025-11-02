page 70102 "Demo User List"
{
    PageType = List;
    ApplicationArea = All;

    SourceTable = "Demo User";
    UsageCategory = Lists;
    CardPageID = 70101;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Username"; Rec."Username")
                {
                    ApplicationArea = All;
                }
                field("Password"; Rec."Password")
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