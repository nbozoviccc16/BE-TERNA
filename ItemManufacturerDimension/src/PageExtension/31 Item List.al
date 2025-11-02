pageextension 90102 "Item List Ext" extends "Item List"
{
    layout
    {
        addafter("Description")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Global Dimension 1 Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }

            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
                ToolTip = 'Specifies the code for Global Dimension 2 Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Manufacturer Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
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