procedure ProcessIfFoundBad(CustomerNo: Code[20])
var
    Customer: Record Customer;
begin
    // BAD: statement on same line as then — hard to read
    if not Customer.Get(CustomerNo) then exit;

    // BAD: unnecessary begin/end around a single statement
    if Customer.Blocked <> Customer.Blocked::" " then begin
        Error('Blocked');
    end;
end;
