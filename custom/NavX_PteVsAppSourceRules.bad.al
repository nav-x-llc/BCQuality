// BAD for AppSource: modifying base table directly (fails validation)
// BAD for AppSource: no prefix on object name
// BAD for AppSource: hardcoded caption string
table 18 Customer
{
    fields
    {
        field(50000; "Discount Group"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }
}
