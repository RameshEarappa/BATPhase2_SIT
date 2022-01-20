pageextension 50151 "TransferOrderProposalLine Ext" extends "Transfer Order Proposal Lines"
{
    layout
    {
        addafter("Transfer Order No.")
        {
            field("Average Sales"; Rec."Average Sales")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Original Quantity"; Rec."Original Quantity")
            {
                ApplicationArea = All;
            }
        }
    }
}