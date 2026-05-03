// Extension registers an additional field without touching the base API page
codeunit 50061 "NAVX Comm. Customer API Ext."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NAVX Customer API Fields", OnAfterGetCustomerApiFields, '', false, false)]
    local procedure AddCommissionFields(var FieldList: List of [Integer])
    begin
        FieldList.Add(50020); // "NAVX Commission Rate"
    end;
}
