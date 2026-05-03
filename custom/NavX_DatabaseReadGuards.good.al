procedure GetItemPrice(ItemNo: Code[20]): Decimal
var
    Item: Record Item;
begin
    Item.SetLoadFields("Unit Price");
    if not Item.Get(ItemNo) then
        exit(0);
    exit(Item."Unit Price");
end;
