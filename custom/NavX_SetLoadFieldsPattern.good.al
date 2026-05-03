procedure CountActiveItems(): Integer
var
    Item: Record Item;
begin
    Item.SetLoadFields(Blocked);
    Item.SetRange(Blocked, false);
    exit(Item.Count());
end;
