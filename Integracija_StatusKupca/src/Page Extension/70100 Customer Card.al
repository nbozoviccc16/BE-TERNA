pageextension 70100 "Customer Card Ext." extends "Customer Card"
{
    layout
    {
        addlast(General)
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

        modify(Blocked)
        {
            trigger OnBeforeValidate()
            var
                IntegrationSetup: Record "Integration Setup";
                DemoUser: Record "Demo User";
                DemoUserUsername: Code[50];
            begin
                IntegrationSetup.Get();
                if IntegrationSetup."Demo User Username" <> '' then begin
                    DemoUserUsername := IntegrationSetup."Demo User Username";
                    DemoUser.SetFilter("Username", DemoUserUsername);
                    if DemoUser.FindFirst() then
                        if DemoUser."Allowed to unblock Customer" = false then
                            Error('Following user %1 is not allowed to unblock Customer.', DemoUserUsername);
                end;
            end;
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