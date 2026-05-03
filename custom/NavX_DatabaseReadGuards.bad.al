procedure GetItemPriceBad(ItemNo: Code[20]): Decimal
var
    Item: Record Item;
begin
    // BAD: unguarded Get throws if record missing; loads all fields unnecessarily
    Item.Get(ItemNo);
    exit(Item."Unit Price");
end;
