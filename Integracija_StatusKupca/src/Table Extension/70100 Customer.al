tableextension 70100 "Customer Ext" extends Customer
{
    fields
    {
        field(60100; "Business Grade"; Code[5]) { }
        field(60101; "Number of Employees"; Integer) { }
        field(60102; "Company Status"; Enum "Company Status") { }
    }
}