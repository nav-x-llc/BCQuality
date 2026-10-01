// BAD: object ID changed from 99002 to 99100.
// Never renumber an existing object — it breaks permission sets and event subscriptions.
codeunit 99100 "NAVX PPDG Rep Install Test Bad" // BAD - original ID was 99002
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure PlaceholderTest()
    begin
        // BAD - the renumbered ID breaks any PermissionSet or EventSubscriber
        // that referenced object 99002.
    end;
}
