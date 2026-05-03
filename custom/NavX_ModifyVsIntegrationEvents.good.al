codeunit 50097 "NAVX Modify Integration Good"
{
    procedure UpdateAmount(var Order: Record "NAVX Order"; NewAmount: Decimal)
    begin
        Order.Amount := NewAmount;
        Order.Modify(true);  // data change — OnAfterModify subscribers must fire
    end;

    procedure SetStatusCompleted(var Order: Record "NAVX Order")
    begin
        Order."Processing Status" := Order."Processing Status"::Completed;
        Order.Modify(false);  // internal flag only — no cascade; audit uses integration event below
        OnAfterOrderStatusChanged(Order);
    end;

    // Named integration event — audit/sync subscribers bind here, not OnAfterModify
    [IntegrationEvent(false, false)]
    local procedure OnAfterOrderStatusChanged(var Order: Record "NAVX Order")
    begin
    end;
}
