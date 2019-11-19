table 14135104 lvngLoanValue
{
    DataClassification = CustomerContent;
    Caption = 'Loan Value';
    fields
    {
        field(1; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; TableRelation = lvngLoan; NotBlank = true; }
        field(2; "Field No."; Integer) { Caption = 'Field No.'; DataClassification = CustomerContent; TableRelation = lvngLoanFieldsConfiguration; NotBlank = true; }
        field(10; "Field Value"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Value';

            trigger OnValidate()
            var
                LoanManagement: Codeunit lvngLoanManagement;
            begin
                LoanManagement.EvaluateLoanFieldsValue(Rec, false);
            end;
        }
        field(11; "Date Value"; Date) { Caption = 'Date Value'; DataClassification = CustomerContent; }
        field(12; "Integer Value"; Integer) { Caption = 'Integer Value'; DataClassification = CustomerContent; }
        field(13; "Decimal Value"; Decimal) { Caption = 'Decimal Value'; DataClassification = CustomerContent; DecimalPlaces = 2 : 5; }
        field(14; "Boolean Value"; Boolean) { Caption = 'Boolean Value'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.", "Field No.") { Clustered = true; }
    }
}