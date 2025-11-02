codeunit 90100 "Manufacturer Dimension Mngmt."
{
    SingleInstance = true;

    procedure CheckExistAndInitManufacturerAsDimensionValue(Manufacturer: Record "Manufacturer")
    var
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Dimension: Record "Dimension";
        IsExist: Boolean;
    begin
        if not GLSetup.Get() then
            exit;

        if GLSetup."Manufacturer Dimension Code" = '' then
            Error('Missing Manufacturer Dimension Code from GL Setup.');

        //check if dimension value with that code exist
        if not Manufacturer.IsEmpty() then begin
            if Manufacturer.Code <> '' then begin
                if Dimension.Get(GLSetup."Manufacturer Dimension Code") then begin
                    DimensionValue.SetRange("Dimension Code", Dimension.Code);
                    DimensionValue.SetFilter("Code", Manufacturer.Code);
                    if DimensionValue.FindFirst() then
                        IsExist := true
                    else
                        IsExist := false;
                end;
            end;
        end;

        if IsExist = false then begin
            //init new dimension
            DimensionValue.Init();
            DimensionValue.Validate("Dimension Code", Dimension.Code);
            DimensionValue.Validate("Code", Manufacturer.Code);
            DimensionValue.Validate("Name", Manufacturer.Name);
            DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
            DimensionValue.Validate("Global Dimension No.", 2);
            DimensionValue.Insert();
            //init new default dimension
        end;

        if IsExist = true then begin
            //update created dimension
            DimensionValue.Validate("Dimension Code", Dimension.Code);
            DimensionValue.Validate("Code", Manufacturer.Code);
            DimensionValue.Validate("Name", Manufacturer.Name);
            DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
            DimensionValue.Validate("Global Dimension No.", 2);
            DimensionValue.Modify();
        end;
    end;

    procedure InsertManufacturerAsDimensionValue(Manufacturer: Record "Manufacturer")
    var
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Dimension: Record "Dimension";
        IsExist: Boolean;
        ManufacturerName: Text[50];
    begin
        if not GLSetup.Get() then
            exit;

        if GLSetup."Manufacturer Dimension Code" = '' then
            Error('Missing Manufacturer Dimension Code from GL Setup.');

        ManufacturerName := Manufacturer.Name;
        //check if dimension value with that code exist
        if (Manufacturer.Code <> '') AND (ManufacturerName <> '') then begin
            if Dimension.Get(GLSetup."Manufacturer Dimension Code") then begin
                DimensionValue.SetRange("Dimension Code", Dimension.Code);
                DimensionValue.SetRange("Code", Manufacturer.Code);
                if DimensionValue.FindFirst() then begin
                    IsExist := true;
                end else begin
                    IsExist := false;
                end;
            end;
        end;

        if IsExist = true then begin
            //init new dimension
            DimensionValue.Validate("Name", ManufacturerName);
            DimensionValue.Modify(true);
        end;
    end;

    procedure SetDefaultDimensionValue(Item: Record Item)
    var
        GLSetup: Record "General Ledger Setup";
        Dimension: Record "Dimension";
        DefaultDimensionValue: Record "Default Dimension";
        DefaultDimensionValuePostingType: Enum "Default Dimension Value Posting Type";
        IsExist: Boolean;
    begin
        if not GLSetup.Get() then
            exit;

        if GLSetup."Manufacturer Dimension Code" = '' then
            Error('Missing Manufacturer Dimension Code from GL Setup.');

        //check if dimension value with that code exist
        if not Item.IsEmpty() then begin
            if (Item."No." <> '') AND (Item."Manufacturer Code" <> '') then begin
                if Dimension.Get(GLSetup."Manufacturer Dimension Code") then begin
                    //exist, update default dimension
                    DefaultDimensionValue.SetRange("Table ID", 27);
                    DefaultDimensionValue.SetRange("No.", Item."No.");
                    if DefaultDimensionValue.FindFirst() then
                        IsExist := true
                    else
                        IsExist := false;
                end;
            end;
        end;

        if IsExist = true then begin
            DefaultDimensionValue.Validate("Dimension Code", GLSetup."Manufacturer Dimension Code");
            DefaultDimensionValue.Validate("Dimension Value Code", Item."Manufacturer Code");
            DefaultDimensionValue.Validate("Value Posting", DefaultDimensionValuePostingType::"Code Mandatory");
            DefaultDimensionValue.Modify();
            Commit();
        end;

        if IsExist = false then begin
            //not exist, insert
            DefaultDimensionValue.Init();
            DefaultDimensionValue.Validate("Table ID", 27);
            DefaultDimensionValue.Validate("No.", Item."No.");
            DefaultDimensionValue.Validate("Dimension Code", GLSetup."Manufacturer Dimension Code");
            DefaultDimensionValue.Validate("Dimension Value Code", Item."Manufacturer Code");
            DefaultDimensionValue.Validate("Value Posting", DefaultDimensionValuePostingType::"Code Mandatory");
            DefaultDimensionValue.Insert();
            Commit();
        end;
    end;
}