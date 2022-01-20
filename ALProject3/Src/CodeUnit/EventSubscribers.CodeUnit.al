codeunit 60101 "BatPhase2_CustHold"
{
    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnBeforeActionEvent', 'Set Applies-to ID', false, false)]
    local procedure OnBeforeActionEventSetAppliestoID(var Rec: Record "Cust. Ledger Entry")
    begin
        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            if Rec."Hold Cust" then
                Error('You Cannot Process Set Applies-to ID for the Customer %1, because it is on hold', Rec."Customer No.");
        end;
    end;
}