page 50150 "Stock Adjustment"
{
    PageType = Worksheet;
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;
    SourceTable = "Stock Adjustment";
    DelayedInsert = true;
    RefreshOnActivate = true;
    SourceTableView = sorting("Item Code", Indentation, "Transfer to Code") order(ascending);
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;

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
                            Rec.SETFILTER("Load Transfer Order Date", '%1', PostingDateFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 24;
                            Rec.SETRANGE("Load Transfer Order Date");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    END;
                }
                field("Transfer to Code Filter"; TransfertoCodeFilter)
                {
                    ApplicationArea = All;
                    TableRelation = Location WHERE("DR Location" = const(true));
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                    BEGIN
                        IF TransfertoCodeFilter <> '' THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 27;
                            Rec.SETFILTER("Transfer to Code", '%1', TransfertoCodeFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 27;
                            Rec.SETRANGE("Transfer to Code");
                            Rec.FilterGroup := OriginalFilterGroup;
                        END;
                        CurrPage.Update();
                    END;
                }
                field("LQ < AS Filter"; LQLessThenLSFilter)
                {
                    ApplicationArea = All;
                    TRIGGER OnValidate()
                    VAR
                        OriginalFilterGroup: Integer;
                    BEGIN
                        IF LQLessThenLSFilter THEN BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 28;
                            Rec.SETFILTER("LQ < AS", '%1', LQLessThenLSFilter);
                            Rec.FilterGroup := OriginalFilterGroup;
                        END
                        ELSE BEGIN
                            OriginalFilterGroup := Rec.FilterGroup;
                            Rec.FilterGroup := 28;
                            Rec.SETRANGE("LQ < AS");
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
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Item Code";
                ShowAsTree = true;
                ShowCaption = false;
                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field';
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                    Enabled = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Report Run Date"; Rec."Report Run Date")
                {
                    ToolTip = 'Specifies the value of the Report Run Date field';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Load Transfer Order Date"; Rec."Load Transfer Order Date")
                {
                    ToolTip = 'Specifies the value of the Loadtransfer Order Date field';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Qty field';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Transfer Order Line No."; Rec."Transfer Order Line No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Transfer to Code"; Rec."Transfer to Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Demand; Rec.Demand)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Avrg Sales"; Rec."Avrg Sales")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTextForAverageSales;
                    Enabled = false;
                }
                field("Proposed Load"; Rec."Proposed Load")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTextForAverageSales;
                    Enabled = false;
                }
                field("Loading Quantity"; Rec."Loading Quantity")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTextForAverageSales;
                }
                field(GrossRequirement; Rec.GrossRequirement)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field(ScheduledReceipt; Rec.ScheduledReceipt)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field(PlannedReceipt; Rec.PlannedReceipt)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field(PlannedRelease; Rec.PlannedRelease)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                }
                field("LQ < AS"; Rec."LQ < AS")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("High Demand"; Rec."High Demand")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action("Adjust Proposal Quantity")
            {
                ApplicationArea = All;
                Image = ServicePriceAdjustment;

                trigger OnAction()
                var
                    RecStockAdjustment: Record "Stock Adjustment";
                    RecTransferOrderLine: Record "Transfer Order Porposal Line";
                begin
                    Clear(RecStockAdjustment);
                    CurrPage.SetSelectionFilter(RecStockAdjustment);
                    if RecStockAdjustment.FindSet() then begin
                        if not Confirm('Do you want to update Transfer Order Proposal quantity with Loading quantity?', false) then exit;
                        repeat
                            Clear(RecTransferOrderLine);
                            RecTransferOrderLine.SetRange("Transfer Order Entry No.", RecStockAdjustment."Transfer Header Entry No.");
                            RecTransferOrderLine.SetRange("Transfer Order No.", RecStockAdjustment."Transfer Order No.");
                            RecTransferOrderLine.SetRange("Line No.", RecStockAdjustment."Transfer Order Line No.");
                            if RecTransferOrderLine.FindFirst() then begin
                                RecTransferOrderLine."Original Quantity" := RecTransferOrderLine.Quantity;
                                RecTransferOrderLine."Quantity Modified By" := UserId;
                                RecTransferOrderLine."Quantity Modified On" := CurrentDateTime;
                                RecTransferOrderLine.Quantity := RecStockAdjustment."Loading Quantity";
                                RecTransferOrderLine.Modify();
                            end;
                        until RecStockAdjustment.Next() = 0;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(LocationCodeFilter);
        Clear(TransfertoCodeFilter);
        Rec.FilterGroup := 25;
        Rec.FilterGroup := 27;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.GetStyleText;
        StyleTextForAverageSales := Rec.GetStyleTextForSales();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        StyleTxt := Rec.GetStyleText;
        StyleTextForAverageSales := Rec.GetStyleTextForSales();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleTxt := Rec.GetStyleText;
        StyleTextForAverageSales := Rec.GetStyleTextForSales();
    end;


    var
        LocationCodeFilter: Code[20];
        ItemCodeFilter: Code[20];
        PostingDateFilter: Date;
        TransferOrderNoFilter: Code[20];
        TransfertoCodeFilter: Code[20];
        LQLessThenLSFilter: Boolean;
        StyleTxt: Text;
        StyleTextForAverageSales: Text;
}