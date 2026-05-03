---
bc-version:
- 22.0
- 23.0
- 24.0
- 25.0
domain: design-pattern
keywords:
- command queue
- asynchronous
- job queue
- background processing
technologies:
- AL
countries:
- W1
application-area: All
---

## Description

The Command Queue pattern decouples the triggering of an operation from its
execution by writing a command record to a queue table, then processing it
asynchronously via a Job Queue Entry. This is the correct approach for any
operation that is too slow or too risky to run synchronously inside a transaction.

## Best Practice

Create a command table (`<Feature> Command`) with a Status field (`Queued`,
`Processing`, `Completed`, `Error`). A management codeunit writes the command
record and triggers a Job Queue Entry. The JQE codeunit reads `Queued` commands,
sets `Processing`, executes, then sets `Completed` or `Error`.

```al
procedure EnqueueSync(SourceNo: Code[20])
var
    Command: Record "NAVX Sync Command";
begin
    Command.Init();
    Command."Source No." := SourceNo;
    Command.Status := Command.Status::Queued;
    Command."Created At" := CurrentDateTime();
    Command.Insert(true);
    // Job Queue Entry picks this up on its next run
end;
```

## Anti Pattern

Running slow or externally-dependent logic (HTTP calls, large loops) directly
inside a table trigger or event subscriber, blocking the user's transaction.

```al
// WRONG — HTTP call inside OnAfterInsertEvent blocks the transaction
[EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
local procedure OnAfterInsert(var Rec: Record "Sales Header")
begin
    SendToExternalSystem(Rec); // blocks user, can time out, rolls back on error
end;
```
