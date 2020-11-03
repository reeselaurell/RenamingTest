table 14135167 "lvnPerformanceRowSchemaLine"
{
    Caption = 'Performance Row Schema Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Schema Code"; Code[20]) { Caption = 'Schema Code'; DataClassification = CustomerContent; TableRelation = lvnPerformanceRowSchema.Code; }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Line No." <= 0 then
                    Error(ShouldBePositiveErr, FieldCaption("Line No."));
            end;
        }
        field(3; "Column No."; Integer) { Caption = 'Column No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Row Type"; Enum lvnPerformanceRowType) { Caption = 'Row Type'; DataClassification = CustomerContent; }
        field(12; "Calculation Unit Code"; Code[20]) { Caption = 'Calculation Unit Code'; DataClassification = CustomerContent; TableRelation = lvnCalculationUnit.Code; }
        field(13; "Number Format Code"; Code[20]) { Caption = 'Number Format Code'; DataClassification = CustomerContent; TableRelation = lvnNumberFormat.Code; }
        field(14; "Style Code"; Code[20]) { Caption = 'Style Code'; DataClassification = CustomerContent; TableRelation = lvnStyle.Code; }
        field(15; "Neg. Style Code"; Code[20]) { Caption = 'Negative Style Code'; DataClassification = CustomerContent; TableRelation = lvnStyle.Code; }
        field(16; "Hide Zero Line"; Boolean) { Caption = 'Hide Zero Line'; DataClassification = CustomerContent; }
        field(17; "Row Style"; Code[20]) { Caption = 'Row Style'; DataClassification = CustomerContent; TableRelation = lvnStyle.Code; }
        field(50; "Data Row Index"; Integer) { Caption = 'Data Row Index'; DataClassification = CustomerContent; Description = 'For use in excel export'; }
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
        RowLine: Record lvnPerformanceRowSchemaLine;
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