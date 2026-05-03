// BAD: synchronous external call inside event subscriber blocks user transaction
codeunit 50042 "NAVX Sync Bad Subscriber"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsert(var Rec: Record "Sales Header")
    begin
        SendToExternalSystem(Rec); // BAD: slow, blocks transaction, error causes rollback
    end;

    local procedure SendToExternalSystem(var SalesHeader: Record "Sales Header")
    begin
        // HTTP call here
    end;
}
