tableextension 90101 "Manufacturer Ext" extends "Manufacturer"
{
    fields
    {

    }

    keys
    {

    }

    fieldgroups
    {

    }

    trigger OnInsert()
    var
        ManufacturerDimensionMngmt: Codeunit "Manufacturer Dimension Mngmt.";
    begin
        ManufacturerDimensionMngmt.CheckExistAndInitManufacturerAsDimensionValue(Rec);
    end;

    trigger OnAfterModify()
    var
        ManufacturerDimensionMngmt: Codeunit "Manufacturer Dimension Mngmt.";
    begin
        if Rec.Name <> '' then begin
            ManufacturerDimensionMngmt.InsertManufacturerAsDimensionValue(Rec);
        end;
    end;



    var
        myInt: Integer;
}