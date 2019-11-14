table 14135240 lvngLoanLevelReportSchemaLine
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Report Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoanLevelReportSchema.Code; }
        field(2; "Column No."; Integer) { DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { DataClassification = CustomerContent; }
        field(11; Type; Enum lvngLoanLevelReportLineType) { DataClassification = CustomerContent; }
        field(12; "G/L Filter"; Blob) { DataClassification = CustomerContent; }
        field(13; "Value Field No."; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TableField: Record Field;
                LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                FieldSelection: Codeunit "Field Selection";
            begin
                case Type of
                    Type::lvngTableField:
                        begin
                            TableField.Reset();
                            TableField.SetRange(TableNo, Database::lvngLoan);
                            if FieldSelection.Open(TableField) then
                                Validate("Value Field No.", TableField."No.");
                        end;
                    Type::lvngVariableField:
                        begin
                            LoanFieldsConfiguration.Reset();
                            if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then
                                Validate("Value Field No.", LoanFieldsConfiguration."Field No.");
                        end;
                end;
            end;
        }
        field(14; "Formula Code"; Code[20]) { DataClassification = CustomerContent; }
        field(15; "Number Format Code"; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngNumberFormat.Code; }
    }

    keys
    {
        key(PK; "Report Code", "Column No.") { Clustered = true; }
    }
}