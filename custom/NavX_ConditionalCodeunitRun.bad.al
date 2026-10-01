/// <summary>
/// Demonstrates the anti-pattern: no error boundary around a posting run.
/// </summary>
codeunit 99905 "NAVX Cond CU Run Bad"
{
    Access = Internal;

    local procedure PostWithoutCleanup(var SalesHeader: Record "Sales Header")
    var
        SalesPost: Codeunit "Sales-Post";
        Subscriber: Codeunit "NAVX Cond CU Run Good"; // reuse for compilation
    begin
        Subscriber.SetContext(SalesHeader);
        BindSubscription(Subscriber);

        SalesPost.Run(SalesHeader); // BAD - unconditional Run; error unwinds past cleanup

        // BAD - these lines are never reached when posting fails:
        UnbindSubscription(Subscriber); // BAD - subscription leaks on error
        Subscriber.ClearContext();      // BAD - context leaks on error
    end;
}
