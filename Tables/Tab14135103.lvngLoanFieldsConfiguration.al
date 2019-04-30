table 14135103 "lvngLoanFieldsConfiguration"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Fields Configuration';
    LookupPageId = lvngLoanFieldsConfiguration;

    fields
    {
        field(1; lvngFieldNo; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            MinValue = 1;
        }

        field(10; lvngFieldName; Text[50])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataTypeManagement: codeunit "Data Type Management";
                lvngLoanFieldsConfigurationTableRef: RecordRef;
                lvngLoanFieldsConfigurationFieldRef: FieldRef;
            begin
                lvngLoanFieldsConfigurationTableRef.Open(Database::lvngLoan);
                if DataTypeManagement.FindFieldByName(lvngLoanFieldsConfigurationTableRef, lvngLoanFieldsConfigurationFieldRef, lvngFieldName) then begin
                    lvngLoanFieldsConfigurationTableRef.Close();
                    Error(lvngReservedFieldErrorLbl);
                end;
            end;
        }

        field(11; lvngValueType; Enum lvngLoanFieldValueType)
        {
            Caption = 'Value Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; lvngFieldNo)
        {
            Clustered = true;
        }
        key(lvngFieldName; lvngFieldName)
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    begin
        TestField(lvngFieldName);
    end;

    trigger OnModify()
    begin
        TestField(lvngFieldName);
    end;

    var
        lvngReservedFieldErrorLbl: Label 'Reserved field name can not be used';
}