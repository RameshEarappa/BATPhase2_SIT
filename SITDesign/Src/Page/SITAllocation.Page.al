page 50150 "SIT Allocation"
{
    PageType = Worksheet;
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;
    SourceTable = "SIT Allocation";
    DelayedInsert = true;
    SourceTableView = sorting("Item Code") order(ascending);

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                field("Location Code Filter"; LocationCodeFilter)
                {
                    ApplicationArea = All;
                    TableRelation = Location WHERE("DR Location" = const(true));
                    trigger OnValidate();
                    var
                        OriginalFilterGroup: Integer;
                    begin
                        IF LocationCodeFilter <> '' THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 25;
                            Rec.SETFILTER("Location Code", LocationCodeFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 25;
                            Rec.SETRANGE("Location Code");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    end;
                }
                field("Item Code Filter"; ItemCodeFilter)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                    BEGIN
                        IF ItemCodeFilter <> '' THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 26;
                            Rec.SETFILTER("Item Code", '%1', ItemCodeFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 26;
                            Rec.SETRANGE("Item Code");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    END;
                }
                field("Posting Date Filter"; PostingDateFilter)
                {
                    ApplicationArea = All;
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                    BEGIN
                        IF PostingDateFilter <> 0D THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 24;
                            Rec.SETFILTER("Loadtransfer Order Date", '%1', PostingDateFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 24;
                            Rec.SETRANGE("Loadtransfer Order Date");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    END;
                }
                field("Transfer Order No. Filter"; TransferOrderNoFilter)
                {
                    ApplicationArea = All;
                }
            }
            repeater(Control1)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Report Run Date"; Rec."Report Run Date")
                {
                    ToolTip = 'Specifies the value of the Report Run Date field';
                    ApplicationArea = All;
                }
                field("Loadtransfer Order Date"; Rec."Loadtransfer Order Date")
                {
                    ToolTip = 'Specifies the value of the Loadtransfer Order Date field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Qty field';
                    ApplicationArea = All;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer Order Line No."; Rec."Transfer Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer to Code"; Rec."Transfer to Code")
                {
                    ApplicationArea = All;
                }
                field(Demand; Rec.Demand)
                {
                    ApplicationArea = All;
                }
                field("Avrg Sales"; Rec."Avrg Sales")
                {
                    ApplicationArea = All;
                }
                field("Proposed Load"; Rec."Proposed Load")
                {
                    ApplicationArea = All;
                }
                field("Loading Quantity"; Rec."Loading Quantity")
                {
                    ApplicationArea = All;
                }
                field(GrossRequirement; Rec.GrossRequirement)
                {
                    ApplicationArea = All;
                }
                field(ScheduledReceipt; Rec.ScheduledReceipt)
                {
                    ApplicationArea = All;
                }
                field(PlannedReceipt; Rec.PlannedReceipt)
                {
                    ApplicationArea = All;
                }
                field(PlannedRelease; Rec.PlannedRelease)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CheckQuantity)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    WarehouseEntryL: Record "Warehouse Entry";
                    Qty: Decimal;
                begin
                    WarehouseEntryL.SetRange("Item No.", Rec."Item Code");
                    WarehouseEntryL.SetRange("Location Code", Rec."Location Code");
                    WarehouseEntryL.SetRange("Registering Date", Rec."Loadtransfer Order Date");
                    //WarehouseEntryL.SetRange("Bin Code", 'GOOD2SELL');
                    if WarehouseEntryL.FindSet() then begin
                        repeat
                            Qty += Abs(WarehouseEntryL.Quantity);
                        until WarehouseEntryL.Next() = 0;
                        Message(Format(Qty));
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        RecLocation: Record Location;
        OriginalFilterGroup: Integer;
    begin
        Clear(RecLocation);
        RecLocation.SetRange("DR Location", true);
        if RecLocation.FindFirst() then begin
            LocationCodeFilter := RecLocation.Code;
            OriginalFilterGroup := Rec.FilterGroup;
            Rec.FilterGroup := 25;
            Rec.SETFILTER("Location Code", LocationCodeFilter);
            Rec.FilterGroup := OriginalFilterGroup;
        end;
    end;

    var
        LocationCodeFilter: Code[20];
        ItemCodeFilter: Code[20];
        PostingDateFilter: Date;
        TransferOrderNoFilter: Code[20];
}