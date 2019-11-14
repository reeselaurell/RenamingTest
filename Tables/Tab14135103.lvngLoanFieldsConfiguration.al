table 14135103 lvngLoanFieldsConfiguration
{
    DataClassification = CustomerContent;
    Caption = 'Loan Fields Configuration';
    LookupPageId = lvngLoanFieldsConfiguration;

    fields
    {
        field(1; "Field No."; Integer) { DataClassification = CustomerContent; NotBlank = true; MinValue = 1; }
        field(10; "Field Name"; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataTypeManagement: codeunit "Data Type Management";
                TableReference: RecordRef;
                FieldReference: FieldRef;
            begin
                TableReference.Open(Database::lvngLoan);
                if DataTypeManagement.FindFieldByName(TableReference, FieldReference, "Field Name") then begin
                    TableReference.Close();
                    Error(ReservedFieldErrorLbl);
                end;
                TableReference.Close();
            end;
        }
        field(11; "Value Type"; Enum lvngLoanFieldValueType) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Field No.") { Clustered = true; }
        key(lvngFieldName; "Field Name") { Unique = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Field No.", "Field Name", "Value Type") { }
    }

    trigger OnInsert()
    begin
        TestField("Field Name");
    end;

    trigger OnModify()
    begin
        TestField("Field Name");
    end;

    var
        ReservedFieldErrorLbl: Label 'Reserved field name can not be used';
}