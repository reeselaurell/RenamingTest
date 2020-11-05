table 14135103 "lvnLoanFieldsConfiguration"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Fields Configuration';
    LookupPageId = lvnLoanFieldsConfiguration;

    fields
    {
        field(1; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            MinValue = 1;
        }
        field(10; "Field Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Name';

            trigger OnValidate()
            var
                DataTypeManagement: Codeunit "Data Type Management";
                TableReference: RecordRef;
                FieldReference: FieldRef;
            begin
                TableReference.Open(Database::lvnLoan);
                if DataTypeManagement.FindFieldByName(TableReference, FieldReference, "Field Name") then begin
                    TableReference.Close();
                    Error(ReservedFieldErrorLbl);
                end;
                TableReference.Close();
            end;
        }
        field(11; "Value Type"; Enum lvnLoanFieldValueType)
        {
            Caption = 'Value Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Field No.") { Clustered = true; }
        key(lvnFieldName; "Field Name") { Unique = true; }
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