pageextension 90100 "General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Manufacturer Dimension Code"; Rec."Manufacturer Dimension Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Manufacturer Dimension Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

}