procedure ProcessIfFound(CustomerNo: Code[20])
var
    Customer: Record Customer;
    CustomerNotFoundErr: Label 'Customer %1 not found.', Comment = '%1 = Customer No.';
begin
    Customer.SetLoadFields(Name, "Customer Posting Group");

    // Single statement — next line, indented, no begin/end
    if not Customer.Get(CustomerNo) then
        Error(CustomerNotFoundErr, CustomerNo);

    // Multi-statement — begin/end required
    if Customer.Blocked <> Customer.Blocked::" " then begin
        LogBlockedAccess(Customer."No.");
        Error(CustomerBlockedErr);
    end;
end;
