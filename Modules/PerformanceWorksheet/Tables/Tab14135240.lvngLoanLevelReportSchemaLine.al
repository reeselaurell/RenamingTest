table 14135240 lvngLoanLevelReportSchemaLine
{
    Caption = 'Loan Level Report Schema Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Report Code"; Code[20]) { Caption = 'Report Code'; DataClassification = CustomerContent; TableRelation = lvngLoanLevelReportSchema.Code; }
        field(2; "Column No."; Integer) { Caption = 'Column No.'; DataClassification = CustomerContent; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; Type; Enum lvngLoanLevelReportLineType) { Caption = 'Type'; DataClassification = CustomerContent; }
        field(12; "G/L Filter"; Blob) { Caption = 'G/L Filter'; DataClassification = CustomerContent; }
        field(13; "Value Field No."; Integer)
        {
            Caption = 'Value Field No.';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TableField: Record Field;
                LoanFieldsConfiguration: Record lvngLoanFieldsConfiguration;
                FieldSelection: Codeunit "Field Selection";
            begin
                case Type of
                    Type::"Table Field":
                        begin
                            TableField.Reset();
                            TableField.SetRange(TableNo, Database::lvngLoan);
                            if FieldSelection.Open(TableField) then
                                Validate("Value Field No.", TableField."No.");
                        end;
                    Type::"Variable Field":
                        begin
                            LoanFieldsConfiguration.Reset();
                            if Page.RunModal(0, LoanFieldsConfiguration) = Action::LookupOK then
                                Validate("Value Field No.", LoanFieldsConfiguration."Field No.");
                        end;
                end;
            end;
        }
        field(14; "Formula Code"; Code[20]) { Caption = 'Formula Code'; DataClassification = CustomerContent; }
        field(15; "Number Format Code"; Code[20]) { Caption = 'Number Format Code'; DataClassification = CustomerContent; TableRelation = lvngNumberFormat.Code; }
    }

    keys
    {
        key(PK; "Report Code", "Column No.") { Clustered = true; }
    }
}