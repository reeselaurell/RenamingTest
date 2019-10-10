table 14135221 lvngPerformanceRowSchemaLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngPerformanceRowSchema.Code; }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Line No." <= 0 then
                    Error(ShouldBePositiveErr, FieldCaption("Line No."));
            end;
        }
        field(3; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; "Row Type"; Enum lvngPerformanceRowType) { DataClassification = CustomerContent; }
        field(12; "Calculation Unit Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngCalculationUnit.Code; }
        field(13; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngNumberFormat.Code; }
        field(14; "Style Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngStyle.Code; }
        field(15; "Neg. Style Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngStyle.Code; }
        field(16; "Hide Zero Line"; Boolean) { DataClassification = CustomerContent; }
        field(17; "Row Style"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngStyle.Code; }
    }

    keys
    {
        key(PK; "Schema Code", "Line No.", "Column No.") { Clustered = true; }
    }

    var
        RenameIsNotAllowedErr: Label 'It is not allowed to rename Performance Row Schema Lines. Delete and create new instead.';
        ShouldBePositiveErr: Label '%1 should be positive number';

    trigger OnDelete()
    var
        RowLine: Record lvngPerformanceRowSchemaLine;
    begin
        RowLine.Reset();
        RowLine.SetRange("Schema Code", "Schema Code");
        RowLine.SetRange("Line No.", "Line No.");
        RowLine.SetFilter("Column No.", '<>%1', "Column No.");
        if not RowLine.IsEmpty() then
            RowLine.DeleteAll(false);
    end;

    trigger OnRename()
    begin
        Error(RenameIsNotAllowedErr);
    end;
}