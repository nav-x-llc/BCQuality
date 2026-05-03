codeunit 50000 "MyFeature Subscriber"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::SalesPost, OnBeforePostSalesDoc, '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if IsHandled then
            exit;
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
            exit;
        // Feature logic here
    end;
}
