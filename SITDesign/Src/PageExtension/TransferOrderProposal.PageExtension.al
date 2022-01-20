pageextension 50150 TransferOrderProposal_ext extends "Transfer Orders Proposal"
{
    actions
    {
        addafter("Change Status")
        {
            action("SIT Allocation Report")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    TranProposalL: Record "Transfer Order Proposal Header";
                begin
                    TranProposalL.CopyFilters(Rec);
                    if TranProposalL.FindSet() then
                        Report.Run(50151, true, false, TranProposalL);
                end;
            }
        }
    }

    var
        myInt: Integer;
}