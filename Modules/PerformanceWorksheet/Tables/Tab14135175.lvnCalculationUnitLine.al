table 14135175 "lvnCalculationUnitLine"
{
    Caption = 'Calculation Unit Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            DataClassification = CustomerContent;
        }
        field(2; "Line no."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Source Unit Code"; Code[20])
        {
            Caption = 'Source Unit Code';
            DataClassification = CustomerContent;
            TableRelation = lvnCalculationUnit.Code;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(lvnCalculationUnit.Description where(Code = field("Source Unit Code")));
        }
    }

    keys
    {
        key(PK; "Unit Code", "Line no.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        CalculationUnitLine: Record lvnCalculationUnitLine;
    begin
        CalculationUnitLine.Reset();
        CalculationUnitLine.SetRange("Unit Code", "Unit Code");
        if CalculationUnitLine.FindLast() then
            "Line no." := CalculationUnitLine."Line no." + 10
        else
            "Line no." := 10;
    end;
}