codeunit 14135120 "lvnCreateNewCompany"
{
    trigger OnRun()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
    begin
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Maintenance Mode", true);
        CopyToComp();
    end;

    procedure CopyToComp()
    var
        Company: Record Company;
        CompanyDataTransfer: Record lvnCompanyDataTransfer;
        ChooseCompany: Page lvnChooseCompany;
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        TableFieldCount: Integer;
        TableFieldNo: Integer;
        TablesCount: Integer;
        Counter: Integer;
        NewCompanyName: Text[50];
        ShowWarnings: Boolean;
        Progress: Dialog;
        CopyCompanyMsg: Label 'Copy this company to #3#######################\', Comment = '#3 Copy company to';
        WorkingOnTableMsg: Label 'Working on table     #1################# #130#of#140#\', Comment = '#1 = Progress; #130 Count; #140 Total';
        NoRecordsMsg: Label 'No. of records       #2###', Comment = '#1 = Record Count';
        CompanyCopyItselfErr: Label 'Company can not be copied into it self';
        NoTablesSelectedErr: Label 'No Tables have been selected in "Create New Company Setup"';
        TablesCopiedMsg: Label '%1 tables were copied', Comment = '%1 = Tables Count';
        RecordsExistMsg: Label 'Records already exist in table: "%1" for Company: "%2". Do you want to proceed anyway?', Comment = '%1 = Tables Name; %2 = New Company Name';
    begin
        CompanyDataTransfer.SetRange(Active, true);
        if CompanyDataTransfer.IsEmpty() then
            Error(NoTablesSelectedErr);
        Company.Reset();
        ChooseCompany.SetTableView(Company);
        ChooseCompany.LookupMode := true;
        if ChooseCompany.RunModal() = Action::LookupOK then begin
            ChooseCompany.GetRecord(Company);
            NewCompanyName := Company.Name;
        end else
            exit;
        if NewCompanyName = CompanyName() then
            Error(CompanyCopyItselfErr);
        ChooseCompany.GetParameters(ShowWarnings);
        Progress.Open(CopyCompanyMsg + WorkingOnTableMsg + NoRecordsMsg);
        Progress.Update(3, NewCompanyName);
        if not Company.Get(NewCompanyName) then begin
            Company.Init();
            Company.Name := NewCompanyName;
            Company.Insert(true);
        end;
        Progress.Update(140, Format(CompanyDataTransfer.Count));
        if CompanyDataTransfer.FindSet() then
            repeat
                TablesCount := TablesCount + 1;
                Clear(FromRecRef);
                Clear(ToRecRef);
                FromRecRef.Open(CompanyDataTransfer."Table ID");
                ToRecRef.Open(CompanyDataTransfer."Table ID", false, NewCompanyName);
                if ShowWarnings then
                    if not ToRecRef.IsEmpty() then begin
                        CompanyDataTransfer.CalcFields("Table Name");
                        if not Confirm(RecordsExistMsg, false, CompanyDataTransfer."Table Name", NewCompanyName) then
                            exit;
                    end;
                Progress.Update(1, FromRecRef.Name);
                Progress.Update(130, Format(TablesCount));
                TableFieldCount := FromRecRef.FieldCount();
                if FromRecRef.FindSet() then
                    repeat
                        for TableFieldNo := 1 to TableFieldCount do begin
                            FromFieldRef := FromRecRef.FieldIndex(TableFieldNo);
                            ToFieldRef := ToRecRef.FieldIndex(TableFieldNo);
                            if Format(FromFieldRef.Type) <> 'BLOB' then
                                ToFieldRef.Value := FromFieldRef.Value
                            else begin
                                FromFieldRef.CalcField();
                                ToFieldRef.Value := FromFieldRef.Value;
                            end;
                        end;
                        if not ToRecRef.Insert() then
                            ToRecRef.Modify();
                        Counter := Counter + 1;
                        if Counter mod 10 = 0 then
                            Progress.Update(2, Counter);
                    until (FromRecRef.Next() = 0);
            until (CompanyDataTransfer.Next() = 0);
        Commit();
        Message(TablesCopiedMsg, TablesCount);
        Progress.Close();
    end;
}