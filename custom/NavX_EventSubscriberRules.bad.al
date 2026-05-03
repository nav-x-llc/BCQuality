// BAD: quoted event name, OnInsert table trigger, no SingleInstance, no IsHandled guard
codeunit 50001 "MyFeature Bad Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnInsert', '', false, false)]
    local procedure OnInsertSalesHeader(var Rec: Record "Sales Header")
    begin
        Rec.MyField := 'changed';
    end;
}
