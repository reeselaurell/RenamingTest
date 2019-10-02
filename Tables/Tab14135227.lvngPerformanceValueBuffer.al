table 14135227 lvngPerformanceValueBuffer
{
    fields
    {
        field(1; "Row No."; Integer) { }
        field(2; "Band No."; Integer) { }
        field(3; "Column No."; Integer) { }
        field(10; Value; Decimal) { }
    }

    keys
    {
        key(PK; "Row No.", "Band No.", "Column No.") { Clustered = true; }
    }
}