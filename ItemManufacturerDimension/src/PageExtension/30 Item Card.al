pageextension 90101 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Description")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Global Dimension 1 Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }

            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Global Dimension 2 Code, whose dimension values you can then enter directly on journals and sales or purchase lines.';
            }
        }

        modify("Manufacturer Code")
        {
            ApplicationArea = All;
            Visible = true;

            trigger OnBeforeValidate()
            var
                ManufacturerDimensionMngmt: Codeunit "Manufacturer Dimension Mngmt.";
                Manufacturer: Record "Manufacturer";
                IsExist: Boolean;
            begin
                if Rec."Manufacturer Code" <> '' then begin
                    Manufacturer.SetRange("Code", Rec."Manufacturer Code");
                    if Manufacturer.FindFirst() then begin
                        ManufacturerDimensionMngmt.CheckExistAndInitManufacturerAsDimensionValue(Manufacturer);
                        ManufacturerDimensionMngmt.SetDefaultDimensionValue(Rec);
                    end;
                end;
            end;

            trigger OnAfterValidate()
            var
                ManufacturerDimensionMngmt: Codeunit "Manufacturer Dimension Mngmt.";
            begin
                Rec.Validate("Global Dimension 2 Code", Rec."Manufacturer Code");
            end;
        }
        moveafter("Purchasing Blocked"; "Manufacturer Code")
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

}