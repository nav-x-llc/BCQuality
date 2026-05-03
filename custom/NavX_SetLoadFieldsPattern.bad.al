procedure CountActiveItemsBad(): Integer
var
    Item: Record Item;
begin
    // BAD: loads all Item fields when only Blocked is needed
    Item.SetRange(Blocked, false);
    exit(Item.Count());
end;
