pageextension 50152 "Location Card Ext" extends "Location Card"
{
    layout
    {
        addafter("DR Location")
        {
            field(Active; Rec.Active)
            {
                ApplicationArea = All;
            }
        }
    }
}