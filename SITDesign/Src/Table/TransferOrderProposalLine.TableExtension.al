tableextension 50150 "TransferOrderProposalLine_ Ext" extends "Transfer Order Porposal Line"
{
    fields
    {
        field(50000; "Average Sales"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
    }
}