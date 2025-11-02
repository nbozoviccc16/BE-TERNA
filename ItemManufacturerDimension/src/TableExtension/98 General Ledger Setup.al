tableextension 90100 "General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(90100; "Manufacturer Dimension Code"; Code[20])
        {
            Caption = 'Manufacturer Dimension Code';
            TableRelation = "Dimension";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}