report 70100 "Update  Customer Status"
{
    Caption = 'Update  - Customer Status';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group", "Gen. Bus. Posting Group";

            trigger OnAfterGetRecord()
            var
                IntegrationManager: Codeunit "Integration Manager";
            begin
                if Customer.FindSet() then begin
                    repeat
                        IntegrationManager.UpdateCustomerStatus(Customer);
                    until Customer.Next() = 0;
                end;
            end;
        }
    }

    trigger OnPostReport()
    begin
        Message('Customers statuses successfully updated.');
    end;
}
