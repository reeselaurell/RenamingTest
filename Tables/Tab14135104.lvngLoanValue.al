table 14135104 lvngLoanValue
{
    DataClassification = CustomerContent;
    Caption = 'Loan Value';
    fields
    {
        field(1; "Loan No."; Code[20]) { DataClassification = CustomerContent; TableRelation = lvngLoan; NotBlank = true; }
        field(2; "Field No."; Integer) { DataClassification = CustomerContent; TableRelation = lvngLoanFieldsConfiguration; NotBlank = true; }
        field(10; "Field Value"; Text[250])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LoanManagement: Codeunit lvngLoanManagement;
            begin
                LoanManagement.EvaluateLoanFieldsValue(Rec, false);
            end;
        }
        field(11; "Date Value"; Date) { DataClassification = CustomerContent; }
        field(12; "Integer Value"; Integer) { DataClassification = CustomerContent; }
        field(13; "Decimal Value"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 2 : 5; }
        field(14; "Boolean Value"; Boolean) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Loan No.", "Field No.") { Clustered = true; }
    }
}