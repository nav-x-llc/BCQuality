// BAD: subscribes directly to SalesPost — coupling to base app event signature
codeunit 50052 "NAVX Comm. Entry Bad Creator"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::SalesPost, OnAfterPostSalesDoc, '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CommissionMgt: Codeunit "NAVX Commission Mgt.";
    begin
        CommissionMgt.CreateEntriesForInvoice(SalesHeader);
    end;
}
