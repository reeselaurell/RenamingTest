table 14135147 lvngPerformanceValueBuffer
{
    fields
    {
        field(1; "Row No."; Integer) { }
        field(2; "Column No."; Integer) { }
        field(10; Value; Decimal) { }
    }

    keys
    {
        key(PK; "Row No.", "Column No.") { Clustered = true; }
    }
}