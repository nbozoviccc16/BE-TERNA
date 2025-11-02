/// <summary>
/// PageExtension Customer List Ext. (ID 60101) extends Record Customer List.
/// </summary>
pageextension 70101 "Customer List Ext." extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Business Grade"; Rec."Business Grade")
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
        }
    }

    actions
    {
        addfirst("&Customer")
        {
            action("Update Customer - Status")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    IntegrationManager: Codeunit "Integration Manager";
                begin
                    Message('UpdateCustomerStatus');
                    IntegrationManager.UpdateCustomerStatus(Rec);
                    Message('Updated');
                end;
            }
        }
    }
}