pageextension 50150 TransferOrderProposal_ext extends "Transfer Orders Proposal"
{
    actions
    {
        addafter("Change Status")
        {
            action("Stock Adjustment")
            {
                ApplicationArea = All;
                Caption = 'Stock Adjustment';
                Image = EditAdjustments;

                trigger OnAction()
                var
                    TranProposalL: Record "Transfer Order Proposal Header";
                    StockAdjutmentReport: Report "Stock Adjustment Report";
                begin
                    TranProposalL.CopyFilters(Rec);
                    Clear(StockAdjutmentReport);
                    StockAdjutmentReport.UseRequestPage(true);
                    StockAdjutmentReport.SetTableView(TranProposalL);
                    StockAdjutmentReport.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}