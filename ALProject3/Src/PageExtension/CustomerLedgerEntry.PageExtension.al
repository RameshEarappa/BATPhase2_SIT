pageextension 60100 "Cust Ledger Ext" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("On Hold")
        {
            field("Hold Cust"; Rec."Hold Cust")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            group(HoldCust)
            {
                Caption = 'HoldCust';
                action(Enable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Used to Enable Hold Cust';
                    trigger OnAction()
                    var
                        EnableHoldCustCUL: Codeunit "Enable Hold Cust";
                    begin
                        EnableHoldCustCUL.EnableHoldCust(Rec);
                    end;
                }
                action(Disable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Used to Disable Hold Cust';
                    trigger OnAction()
                    var
                        EnableHoldCustCUL: Codeunit "Enable Hold Cust";
                    begin
                        EnableHoldCustCUL.DisableHoldCust(Rec);
                    end;
                }
            }
        }
    }
}