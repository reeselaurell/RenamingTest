codeunit 14135120 lvngCreateNewCompany
{
    trigger OnRun()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
    begin
        LoanVisionSetup.Get();
        LoanVisionSetup.TestField("Maintenance Mode", true);
        CopyToComp();
    end;

    procedure CopyToComp()
    var
        CopyCompanyMsg: Label 'Copy this company to #3#######################\';
        WorkingOnTableMsg: Label 'Working on table     #1################# #130#of#140#\';
        NoRecords: Label 'No. of records       #2###';
        CompanyCopyItselfErr: Label 'Company can not be copied into it self';
        CompanyExistErr: Label 'Company does not exist: ';
        NoTablesSelectedErr: Label 'No Tables have been selected in "Create New Company Setup"';
        TablesCopiedMsg: Label '%1 tables were copied';
        RecordsExistMsg: Label 'Records already exist in table: "%1" for Company: "%2". Do you want to proceed anyway?';
        Companies: Record Company;
        CompanyDataTransfer: Record lvngCompanyDataTransfer;
        ChooseCompany: Page lvngChooseCompany;
        Progress: Dialog;
        fromRecRef: RecordRef;
        toRecRef: RecordRef;
        fromFieldRef: FieldRef;
        toFieldRef: FieldRef;
        iFieldCount: Integer;
        iFieldNo: Integer;
        TablesCount: Integer;
        Counter: Integer;
        CompanyNameValue: Text[50];
        ShowWarnings: Boolean;
    begin
        CompanyDataTransfer.SetRange(Active, true);
        if CompanyDataTransfer.Count = 0 then
            Error(NoTablesSelectedErr);
        Companies.Reset();
        ChooseCompany.SetTableView(Companies);
        ChooseCompany.LookupMode := true;
        if ChooseCompany.RunModal() = Action::LookupOK then begin
            ChooseCompany.GetRecord(Companies);
            CompanyNameValue := Companies.Name;
        end;
        ChooseCompany.GetParameters(ShowWarnings);
        Progress.Open(CopyCompanyMsg + WorkingOnTableMsg + NoRecords);
        Progress.Update(3, CompanyNameValue);
        if CompanyNameValue = CompanyName then
            Error(CompanyCopyItselfErr);
        if not Companies.Get(CompanyNameValue) then begin
            Companies.Init();
            Companies.Name := CompanyNameValue;
            Companies.Insert(true);
        end;
        if Companies.Get(CompanyNameValue) then begin
            CompanyDataTransfer.SetRange(Active, true);
            Progress.Update(140, Format(CompanyDataTransfer.Count));
            if CompanyDataTransfer.FindSet() then
                repeat
                    TablesCount := TablesCount + 1;
                    Clear(fromRecRef);
                    Clear(toRecRef);
                    fromRecRef.Open(CompanyDataTransfer."Table ID");
                    toRecRef.Open(CompanyDataTransfer."Table ID", FALSE, CompanyNameValue);
                    if ShowWarnings then
                        if not toRecRef.IsEmpty then begin
                            CompanyDataTransfer.CalcFields("Table Name");
                            if not Confirm(RecordsExistMsg, false, CompanyDataTransfer."Table Name", CompanyNameValue) then
                                exit;
                        end;
                    Progress.Update(1, fromRecRef.Name);
                    Progress.Update(130, Format(TablesCount));
                    iFieldCount := fromRecRef.FieldCount;
                    if fromRecRef.FindSet() then
                        repeat
                            for iFieldNo := 1 to iFieldCount do begin
                                fromFieldRef := fromRecRef.FieldIndex(iFieldNo);
                                toFieldRef := toRecRef.FieldIndex(iFieldNo);
                                if Format(fromFieldRef.Type) <> 'BLOB' then
                                    toFieldRef.Value := fromFieldRef.Value
                                else begin
                                    fromFieldRef.CalcField();
                                    toFieldRef.Value := fromFieldRef.Value;
                                end;
                            end;
                            if not toRecRef.Insert() then
                                toRecRef.Modify();
                            Counter := Counter + 1;
                            if Counter mod 10 = 0 then
                                Progress.Update(2, Counter);
                        until (fromRecRef.Next() = 0);
                until (CompanyDataTransfer.Next() = 0);
            Commit();
            Message(TablesCopiedMsg, TablesCount);
            exit;
        end else
            Error(CompanyExistErr + CompanyNameValue);
        Progress.Close();
    end;
}