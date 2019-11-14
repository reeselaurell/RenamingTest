table 14135401 lvngBranchValueCalculation
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dimension Value"; Code[20]) { DataClassification = CustomerContent; }
        field(10; Name; Text[100]) { DataClassification = CustomerContent; }
        field(11; Amount; Decimal) { DataClassification = CustomerContent; }
        field(12; Count; Integer) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Dimension Value") { Clustered = true; }
        key(Amount; Amount) { }
    }
}