table 14135404 lvngPerformanceSchema
{
    LookupPageId = lvngBranchPerformanceSchema;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; NotBlank = true; }
        field(10; Description; Text[50]) { DataClassification = CustomerContent; }
        field(20; "Based On"; Enum lvngPerformanceSchemaBase)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PerformanceSchemaMapping: Record lvngBranchPerfSchemaMapping;
            begin
                PerformanceSchemaMapping.Reset();
                PerformanceSchemaMapping.SetRange("Schema Code", rec.Code);
                if not PerformanceSchemaMapping.IsEmpty() then
                    if Confirm(SchemaMappingResetQst) then begin
                        PerformanceSchemaMapping.ModifyAll("Based On", "Based On");
                        PerformanceSchemaMapping.ModifyAll("Layout Code", '');
                    end else
                        Error(CanceledByUserErr);
            end;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        SchemaMappingResetQst: Label 'Modifying this value will reset related Branch User Performance mapping. Do you want to continue?';
        CanceledByUserErr: Label 'Canceled by user';

    trigger OnDelete()
    var
        PerformanceSchemaLine: Record lvngPerformanceSchemaLine;
    begin
        PerformanceSchemaLine.Reset();
        PerformanceSchemaLine.SetRange("Performance Schema Code", Code);
        PerformanceSchemaLine.DeleteAll();
    end;

}