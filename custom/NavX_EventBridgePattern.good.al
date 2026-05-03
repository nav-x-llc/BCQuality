// Feature subscriber listens to the bridge event, not the base app event
codeunit 50051 "NAVX Comm. Entry Creator"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NAVX Comm. Event Bridge", OnAfterSalesInvoicePosted, '', false, false)]
    local procedure OnAfterSalesInvoicePosted(var SalesHeader: Record "Sales Header")
    var
        CommissionMgt: Codeunit "NAVX Commission Mgt.";
    begin
        CommissionMgt.CreateEntriesForInvoice(SalesHeader);
    end;
}
