report 50151 "SIT Allocation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
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
                DataItemLink = "Transfer Order No." = FIELD("No.");
                DataItemLinkReference = Header;
                DataItemTableView = SORTING("Transfer Order Entry No.", "Line No.");
                trigger OnAfterGetRecord()
                var
                    SITAllL: Record "SIT Allocation";
                begin
                    if ItemG.Get(Line."Item No.") then begin
                        CalcNeed(ItemG, Header."Transfer-From Code", ItemG."Variant Filter");
                    end;
                    SITAllL.Init();
                    SITAllL.Validate("Location Code", Header."Transfer-From Code");
                    SITAllL.Validate("Item Code", "Item No.");
                    SITAllL.Validate("Report Run Date", WorkDate());
                    SITAllL.Validate("Loadtransfer Order Date", Header."Posting Date");
                    SITAllL.Validate(Quantity, ProjAvBalance);
                    SITAllL.Validate("Transfer Order No.", Header."No.");
                    SITAllL.Validate("Transfer Order Line No.", "Line No.");
                    SITAllL.Validate("Transfer to Code", Header."Transfer-To Code");
                    SITAllL.Validate(Demand, UpdateDemand(Quantity, "Item No."));
                    SITAllL.Validate("Avrg Sales", "Average Sales");
                    SITAllL.Validate("Proposed Load", Quantity);
                    SITAllL.Validate(GrossRequirement, GrossReq);
                    SITAllL.Validate(ScheduledReceipt, SchedReceipt);
                    SITAllL.Validate(PlannedReceipt, PlanReceipt);
                    SITAllL.Validate(PlannedRelease, PlanRelease);
                    SITAllL.Insert(true);
                end;
            }
            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                UpdateLoadingQty;
                InsertBlankLinesforDRVAN;
            end;
        }
    }
    // requestpage
    // {
    //     SaveValues = true;

    //     layout
    //     {
    //         area(content)
    //         {
    //             group(Options)
    //             {
    //                 Caption = 'Options';
    //                 field(StartingDate; StartingDate)
    //                 {
    //                     ApplicationArea = Basic, Suite;
    //                     Caption = 'Posting Date';
    //                     ToolTip = 'Specifies the date from which the report processes information.';
    //                 }
    //             }
    //         }
    //     }
    // }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        SITAllocationG.DeleteAll();
        StartingDate := WorkDate();
    end;

    trigger OnPostReport()
    var
        SITVANWHG: Page "SIT Allocation";
    begin
        Page.Run(50150, SITAllocationG);
    end;


    var
        SITAllocationG: Record "SIT Allocation";
        ItemG: Record Item;
        AvailToPromise: Codeunit "Available to Promise";
        SchedReceipt: Decimal;
        PlanReceipt: Decimal;
        PlanRelease: Decimal;
        PeriodStartDate: Date;
        ProjAvBalance: Decimal;
        GrossReq: Decimal;
        i: Integer;
        StartingDate: Date;
        Transferfromload: Code[20];


    local procedure CalcNeed(Item: Record Item; LocationFilter: Text[250]; VariantFilter: Text[250])
    begin
        with Item do begin
            SetFilter("Location Filter", LocationFilter);
            SetFilter("Variant Filter", VariantFilter);
            CalcFields(Inventory);
            // if Inventory <> 0 then
            //     Print := true;

            SetRange("Date Filter", Header."Posting Date");

            GrossReq :=
              AvailToPromise.CalcGrossRequirement(Item);
            SchedReceipt :=
              AvailToPromise.CalcScheduledReceipt(Item);

            CalcFields(
              "Planning Receipt (Qty.)",
              "Planning Release (Qty.)",
              "Planned Order Receipt (Qty.)",
              "Planned Order Release (Qty.)");

            SchedReceipt := SchedReceipt - "Planned Order Receipt (Qty.)";

            PlanReceipt :=
              "Planning Receipt (Qty.)" +
              "Planned Order Receipt (Qty.)";

            PlanRelease :=
              "Planning Release (Qty.)" +
              "Planned Order Release (Qty.)";

            // if i = 1 then begin
            ProjAvBalance :=
              Inventory -
              GrossReq + SchedReceipt + PlanReceipt
            // end else
            //     ProjAvBalance[i] :=
            //       ProjAvBalance[i - 1] -
            //       GrossReq[i] + SchedReceipt[i] + PlanReceipt[i];

            // if (GrossReq[i] <> 0) or
            //    (PlanReceipt[i] <> 0) or
            //    (SchedReceipt[i] <> 0) or
            //    (PlanRelease[i] <> 0)
            // then
            //     Print := true;
        end;
    end;

    local procedure UpdateDemand(CurrentProposedQty: decimal; ItemNo: Code[20]): Decimal
    var
        SITAllocationL: Record "SIT Allocation";
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
        SITAllocationL: Record "SIT Allocation";
        TotalProposedLoadL: Decimal;
    begin
        if SITAllocationL.FindSet() then
            repeat
                SITAllocationL."Loading Quantity" := SITAllocationL.Quantity / SITAllocationL.Demand * SITAllocationL."Proposed Load";
                SITAllocationL.Modify();
            until SITAllocationL.Next() = 0;
    end;

    local procedure InsertBlankLinesforDRVAN()
    var
        SITAllocationL: Record "SIT Allocation";
        SITAllocation2L: Record "SIT Allocation";
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
                    LocationL.SetRange(Active, true);
                    if LocationL.FindSet() then begin
                        repeat
                            Clear(SITAllocation2L);
                            SITAllocation2L.SetRange("Item Code", SITAllocationL."Item Code");
                            SITAllocation2L.SetRange("Location Code", SITAllocationL."Location Code");
                            SITAllocation2L.SetRange("Transfer to Code", LocationL.Code);
                            if not SITAllocation2L.FindFirst() then begin
                                SITAllocation2L.Init();
                                SITAllocation2L.Validate("Location Code", Header."Transfer-From Code");
                                SITAllocation2L.Validate("Item Code", SITAllocationL."Item Code");
                                SITAllocation2L.Validate("Report Run Date", WorkDate());
                                SITAllocation2L.Validate(Quantity, ProjAvBalance);
                                SITAllocation2L.Validate("Transfer to Code", Header."Transfer-To Code");
                                SITAllocation2L.Validate(Demand, UpdateDemand(0, SITAllocationL."Item Code"));
                                SITAllocation2L.Insert(true);
                            end;
                        until LocationL.Next() = 0;
                    end;
                end;
            until SITAllocationL.Next() = 0;
        end;
    end;
}