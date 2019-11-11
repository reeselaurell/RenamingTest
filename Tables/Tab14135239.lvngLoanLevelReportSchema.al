table 14135239 lvngLoanLevelReportSchema
{
    DataClassification = CustomerContent;
    LookupPageId = lvngLoanLevelReportSchema;

    fields
    {
        field(1; Code; Code[20]) { DataClassification = CustomerContent; }
        field(10; Description; Text[250]) { DataClassification = CustomerContent; }
        field(11; "Skip Zero Balance Lines"; Boolean) { DataClassification = CustomerContent; }
    }

    trigger OnDelete()
    var
        LoanLevelReportSchemaLine: Record lvngLoanLevelReportSchemaLine;
    begin
        LoanLevelReportSchemaLine.Reset();
        LoanLevelReportSchemaLine.SetRange("Report Code", Code);
        LoanLevelReportSchemaLine.DeleteAll();
    end;
}