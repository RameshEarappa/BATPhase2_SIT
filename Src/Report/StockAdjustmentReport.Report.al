report 50151 "Stock Adjustment Report"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Header; "Transfer Order Proposal Header")
        {
            RequestFilterFields = "Posting Date", "Transfer-From Code";
            DataItemTableView = SORTING("No.") order(ascending) where(Status = const("Ready To Sync"));
            RequestFilterHeading = 'Transfer Order Proposal Header';
            dataitem(Line; "Transfer Order Porposal Line")
            {
                DataItemLinkReference = Header;
                DataItemLink = "Transfer Order No." = FIELD("No."), "Transfer Order Entry No." = field("Entry No.");
                DataItemTableView = SORTING("Transfer Order Entry No.", "Line No.");
                trigger OnAfterGetRecord()
                var
                    SITAllL: Record "Stock Adjustment";
                begin
                    // if ItemG.Get(Line."Item No.") then begin
                    //     CalcNeed(ItemG, Header."Transfer-From Code", ItemG."Variant Filter");
                    // end;
                    SITAllL.Init();
                    SITAllL.Validate("Location Code", Header."Transfer-From Code");
                    SITAllL.Validate("Item Code", Line."Item No.");
                    SITAllL.Validate("Report Run Date", WorkDate());
                    SITAllL.Validate("Load Transfer Order Date", Header."Posting Date");
                    SITAllL.Validate(Quantity, GetInventoryForBin(Line."Item No.", Header."Transfer-From Code", Header."Posting Date"));//ProjAvBalance);
                    SITAllL.Validate("Transfer Header Entry No.", Header."Entry No.");
                    SITAllL.Validate("Transfer Order No.", Header."No.");
                    SITAllL.Validate("Transfer Order Line No.", "Line No.");
                    SITAllL.Validate("Transfer to Code", Header."Transfer-To Code");
                    SITAllL.Validate(Demand, UpdateDemand(Quantity, "Item No."));
                    SITAllL.Validate("Avrg Sales", "Average Sales");
                    SITAllL.Validate("Proposed Load", Line.Quantity);
                    SITAllL.Validate(GrossRequirement, GrossReq);
                    SITAllL.Validate(ScheduledReceipt, SchedReceipt);
                    SITAllL.Validate(PlannedReceipt, PlanReceipt);
                    SITAllL.Validate(PlannedRelease, PlanRelease);
                    SITAllL.Insert(true);
                end;
            }
            trigger OnPostDataItem()
            begin
                UpdateLoadingQty();
                InsertBlankLinesforDRVAN();
            end;
        }
    }

    trigger OnPreReport()
    begin
        SITAllocationG.DeleteAll();
        Commit();
    end;

    trigger OnPostReport()
    var
        StockAdjustmentPage: Page "Stock Adjustment";
    begin
        Clear(StockAdjustmentPage);
        StockAdjustmentPage.Run();
        //StockAdjustmentPage.RunModal();
    end;


    var
        SITAllocationG: Record "Stock Adjustment";
        //  ItemG: Record Item;
        AvailToPromise: Codeunit "Available to Promise";
        SchedReceipt: Decimal;
        PlanReceipt: Decimal;
        PlanRelease: Decimal;
        PeriodStartDate: Date;
        ProjAvBalance: Decimal;
        GrossReq: Decimal;
        Transferfromload: Code[20];


    /*local procedure CalcNeed(Item: Record Item; LocationFilter: Text[250]; VariantFilter: Text[250])
    begin

        Item.SetFilter("Location Filter", LocationFilter);
        Item.SetFilter("Variant Filter", VariantFilter);
        Item.CalcFields(Inventory);
        // if Inventory <> 0 then
        //     Print := true;

        Item.SetRange("Date Filter", Header."Posting Date");

        GrossReq :=
          AvailToPromise.CalcGrossRequirement(Item);
        SchedReceipt :=
          AvailToPromise.CalcScheduledReceipt(Item);

        Item.CalcFields(
          "Planning Receipt (Qty.)",
          "Planning Release (Qty.)",
          "Planned Order Receipt (Qty.)",
          "Planned Order Release (Qty.)");

        SchedReceipt := SchedReceipt - Item."Planned Order Receipt (Qty.)";

        PlanReceipt :=
          Item."Planning Receipt (Qty.)" +
          Item."Planned Order Receipt (Qty.)";

        PlanRelease :=
          Item."Planning Release (Qty.)" +
          Item."Planned Order Release (Qty.)";

        ProjAvBalance :=
          Item.Inventory -
          GrossReq + SchedReceipt + PlanReceipt
    end;*/

    local procedure UpdateDemand(CurrentProposedQty: decimal; ItemNo: Code[20]): Decimal
    var
        SITAllocationL: Record "Stock Adjustment";
        TotalProposedLoadL: Decimal;
    begin
        SITAllocationL.SetRange("Item Code", ItemNo);
        SITAllocationL.CalcSums("Proposed Load");
        TotalProposedLoadL := SITAllocationL."Proposed Load" + CurrentProposedQty;
        SITAllocationL.ModifyAll(Demand, TotalProposedLoadL);
        exit(TotalProposedLoadL);
    end;

    local procedure UpdateLoadingQty()
    var
        SITAllocationL: Record "Stock Adjustment";
        TotalProposedLoadL: Decimal;
    begin
        if SITAllocationL.FindSet() then
            repeat
                if SITAllocationL.Demand > SITAllocationL.Quantity then begin
                    SITAllocationL."Loading Quantity" := Round(((SITAllocationL.Quantity / SITAllocationL.Demand) * SITAllocationL."Proposed Load"), 1, '<');
                    SITAllocationL."High Demand" := true;
                end else
                    SITAllocationL."Loading Quantity" := SITAllocationL."Proposed Load";
                if SITAllocationL."Loading Quantity" < SITAllocationL."Avrg Sales" then
                    SITAllocationL."LQ < AS" := true;
                SITAllocationL.Modify();
            until SITAllocationL.Next() = 0;
    end;

    local procedure InsertBlankLinesforDRVAN()
    var
        SITAllocationL: Record "Stock Adjustment";
        SITAllocation2L: Record "Stock Adjustment";
        LocationL: Record Location;
        ChekList: List of [Text];
    begin
        Clear(SITAllocationL);
        Clear(ChekList);
        SITAllocationL.SetFilter("Entry No.", '<>%1', 0);
        SITAllocationL.SetFilter("Transfer Order No.", '<>%1', '');
        if SITAllocationL.FindSet() then begin
            repeat
                if not ChekList.Contains(SITAllocationL."Location Code" + SITAllocationL."Item Code") then begin
                    ChekList.Add(SITAllocationL."Location Code" + SITAllocationL."Item Code");
                    Clear(LocationL);
                    LocationL.SetRange("Default Replenishment Whse.", SITAllocationL."Location Code");
                    LocationL.SetRange("DR Location", true);
                    LocationL.SetRange("Inactive", false);
                    if LocationL.FindSet() then begin
                        repeat
                            Clear(SITAllocation2L);
                            SITAllocation2L.SetRange("Item Code", SITAllocationL."Item Code");
                            SITAllocation2L.SetRange("Location Code", SITAllocationL."Location Code");
                            SITAllocation2L.SetRange("Transfer to Code", LocationL.Code);
                            if not SITAllocation2L.FindFirst() then begin
                                SITAllocation2L.Init();
                                SITAllocation2L.Validate("Location Code", SITAllocationL."Location Code");
                                SITAllocation2L.Validate("Item Code", SITAllocationL."Item Code");
                                SITAllocation2L.Validate("Report Run Date", WorkDate());
                                SITAllocation2L.Validate(Quantity, GetInventoryForBin(SITAllocationL."Item Code", SITAllocationL."Location Code", SITAllocationL."Load Transfer Order Date"));//ProjAvBalance);
                                SITAllocation2L.Validate("Transfer to Code", LocationL.code);
                                SITAllocation2L.Validate(Demand, UpdateDemand(0, SITAllocationL."Item Code"));
                                SITAllocation2L.Insert(true);
                            end;
                        until LocationL.Next() = 0;
                    end;
                end;
            until SITAllocationL.Next() = 0;
        end;
    end;

    local procedure GetInventoryForBin(ItemCode: code[20]; LocationCodep: code[20]; Datep: Date): Decimal
    var
        RecWarehouseEntry: Record "Warehouse Entry";
        RecBin: Record Bin;
        CheckListL: List of [Text];
        FilterText: TextBuilder;
        BinFilter: Text;
    begin
        Clear(CheckListL);
        Clear(RecBin);
        RecBin.SetRange("Location Code", LocationCodep);
        RecBin.SetRange("Good For Sales", true);
        if RecBin.FindSet() then begin
            repeat
                if not CheckListL.Contains(RecBin.Code) then begin
                    CheckListL.Add(RecBin.Code);
                    FilterText.Append(RecBin.Code + '|');
                end
            until RecBin.Next() = 0;
        end;
        if StrLen(FilterText.ToText()) < 1 then
            exit(0);
        BinFilter := CopyStr(FilterText.ToText(), 1, StrLen(FilterText.ToText()) - 1);
        Clear(RecWarehouseEntry);
        RecWarehouseEntry.SetCurrentKey("Item No.", "Location Code", "Bin Code", "Registering Date");
        RecWarehouseEntry.SetRange("Item No.", ItemCode);
        RecWarehouseEntry.SetRange("Location Code", LocationCodep);
        RecWarehouseEntry.SetFilter("Bin Code", BinFilter);
        RecWarehouseEntry.SetFilter("Registering Date", '..%1', Datep);
        if RecWarehouseEntry.FindSet() then begin
            RecWarehouseEntry.CalcSums(Quantity);
            exit(RecWarehouseEntry.Quantity);
        end else
            exit(0);
    end;
}