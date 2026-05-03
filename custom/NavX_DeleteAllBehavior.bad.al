procedure PurgeOldLogsBad()
var
    LogEntry: Record "NAVX Log Entry";
begin
    LogEntry.SetRange("Created Date", 0D, CalcDate('<-1Y>', Today()));
    // BAD: DeleteAll(true) fires OnDelete for every log row — extremely slow
    LogEntry.DeleteAll(true);
end;

procedure ClearBufferBad(var TempEntry: Record "NAVX Temp Entry" temporary)
begin
    // BAD: DeleteAll(true) on temp record is unnecessary overhead
    TempEntry.DeleteAll(true);
end;
