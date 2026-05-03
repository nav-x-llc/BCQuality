procedure ClearProcessingBuffer(var TempEntry: Record "NAVX Temp Entry" temporary)
begin
    TempEntry.DeleteAll(false); // temp record — no triggers, fast
end;

procedure PurgeOldLogs()
var
    LogEntry: Record "NAVX Log Entry";
begin
    LogEntry.SetRange("Created Date", 0D, CalcDate('<-1Y>', Today()));
    LogEntry.DeleteAll(false); // log cleanup — no cascade needed, skip triggers
end;
