tableextension 50150 "TransferOrderProposalLine_ Ext" extends "Transfer Order Porposal Line"
{
    fields
    {
        field(50000; "Average Sales"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50001; "Original Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Quantity Modified On"; Datetime)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Quantity Modified By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}