procedure ProcessAllItemsBad(var ItemList: List of [Code[20]])
var
    i: Integer;
begin
    for i := 1 to ItemList.Count do begin
        ProcessItem(ItemList.Get(i));
        Commit(); // BAD: partial commits inside a loop; error on item 7 leaves items 1-6 permanent
    end;
end;
