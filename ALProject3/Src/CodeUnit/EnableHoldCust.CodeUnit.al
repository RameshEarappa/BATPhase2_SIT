codeunit 60100 "Enable Hold Cust"
{
    Permissions = tabledata "Cust. Ledger Entry" = rm;
    procedure EnableHoldCust(Var CustLedEntry: Record "Cust. Ledger Entry")
    begin
        if CustLedEntry."Document Type" = CustLedEntry."Document Type"::Invoice then begin
            CustLedEntry."Hold Cust" := true;
            CustLedEntry.Modify(true);
        end;
    end;

    procedure DisableHoldCust(Var CustLedEntry: Record "Cust. Ledger Entry")
    begin
        if CustLedEntry."Document Type" = CustLedEntry."Document Type"::Invoice then begin
            CustLedEntry."Hold Cust" := false;
            CustLedEntry.Modify(true);
        end;
    end;
}