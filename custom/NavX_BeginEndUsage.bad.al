procedure ProcessIfFoundBad(CustomerNo: Code[20])
var
    Customer: Record Customer;
begin
    // BAD: missing begin/end — LogAccess always runs regardless of Get result
    if Customer.Get(CustomerNo) then
        ProcessCustomer(Customer);
        LogAccess(Customer."No.");  // BUG: runs even when Customer not found
end;
