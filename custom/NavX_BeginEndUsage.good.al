procedure ProcessIfFound(CustomerNo: Code[20])
var
    Customer: Record Customer;
    CustomerNotFoundErr: Label 'Customer %1 not found.', Comment = '%1 = Customer No.';
begin
    Customer.SetLoadFields(Name, "Customer Posting Group");
    if Customer.Get(CustomerNo) then begin
        ProcessCustomer(Customer);
        LogAccess(Customer."No.");
    end else begin
        Error(CustomerNotFoundErr, CustomerNo);
    end;
end;
