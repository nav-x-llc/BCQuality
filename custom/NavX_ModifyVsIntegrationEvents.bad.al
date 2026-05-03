codeunit 50098 "NAVX Modify Integration Bad"
{
    procedure UpdateAmountBad(var Order: Record "NAVX Order"; NewAmount: Decimal)
    begin
        Order.Amount := NewAmount;
        // BAD: Modify(false) on a real data field — audit subscriber silently skipped
        Order.Modify(false);
    end;

    procedure SetStatusBad(var Order: Record "NAVX Order")
    begin
        Order."Processing Status" := Order."Processing Status"::Completed;
        // BAD: Modify(true) on an internal flag — triggers expensive audit/sync
        // subscribers that have nothing to react to for a status change
        Order.Modify(true);
    end;
}

// BAD: cross-extension sync via OnAfterModify — silently broken when any caller uses Modify(false)
[EventSubscriber(ObjectType::Table, Database::"NAVX Order", 'OnAfterModifyEvent', '', false, false)]
local procedure SyncOnModify(var Rec: Record "NAVX Order")
begin
    ExternalSyncCU.Push(Rec);  // will NOT fire when Modify(false) is called
end;
