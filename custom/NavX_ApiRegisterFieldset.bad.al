// BAD: extension modifies the base API page directly to add its field
pageextension 50061 "NAVX Comm. Customer API Ext." extends "NAVX Customer API"
{
    layout
    {
        addlast(Content)
        {
            // BAD: tight coupling — breaks if base page is renamed or restructured
            field(navxCommissionRate; Rec."NAVX Commission Rate") { }
        }
    }
}
