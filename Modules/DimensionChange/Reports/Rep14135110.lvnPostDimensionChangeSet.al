report 14135110 "lvnPostDimensionChangeSet"
{
    Caption = 'Post Dimension Change Set';
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = rm;

    dataset
    {
        dataitem(DimensionChangeJnlEntry; lvnDimensionChangeJnlEntry)
        {
            DataItemTableView = sorting("Change Set ID", "Entry No.") where(Change = const(true));

            trigger OnPreDataItem()
            begin
                Progress.Open(ProcessingMsg, Current, Total);
            end;

            trigger OnAfterGetRecord()
            var
                DimensionChangeLedgerEntry: Record lvnDimensionChangeLedgerEntry;
                GLEntry: Record "G/L Entry";
                DimMgmt: Codeunit DimensionManagement;
                DimSetId: Integer;
                DimCode: Code[20];
            begin
                Current := Current + 1;
                Progress.Update(1, Current);
                GLEntry.Get("Entry No.");
                DimSetId := GLEntry."Dimension Set ID";
                Clear(DimensionChangeLedgerEntry);
                Clear(DimMgmt);
                DimensionChangeLedgerEntry."Change Set ID" := "Change Set ID";
                DimensionChangeLedgerEntry."Entry No." := "Entry No.";
                DimensionChangeLedgerEntry."Old Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                if DimensionTransferFlag[1] then begin
                    DimCode := "New Dimension 1 Code";
                    DimMgmt.ValidateShortcutDimValues(1, DimCode, DimSetId);
                    GLEntry."Global Dimension 1 Code" := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 1 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                DimensionChangeLedgerEntry."Old Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                if DimensionTransferFlag[2] then begin
                    DimCode := "New Dimension 2 Code";
                    DimMgmt.ValidateShortcutDimValues(2, DimCode, DimSetId);
                    GLEntry."Global Dimension 2 Code" := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 2 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                DimensionChangeLedgerEntry."Old Dimension 3 Code" := GLEntry.lvnShortcutDimension3Code;
                if DimensionTransferFlag[3] then begin
                    DimCode := "New Dimension 3 Code";
                    DimMgmt.ValidateShortcutDimValues(3, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension3Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 3 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 3 Code" := GLEntry.lvnShortcutDimension3Code;
                DimensionChangeLedgerEntry."Old Dimension 4 Code" := GLEntry.lvnShortcutDimension4Code;
                if DimensionTransferFlag[4] then begin
                    DimCode := "New Dimension 4 Code";
                    DimMgmt.ValidateShortcutDimValues(4, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension4Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 4 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 4 Code" := GLEntry.lvnShortcutDimension4Code;
                DimensionChangeLedgerEntry."Old Dimension 5 Code" := GLEntry.lvnShortcutDimension5Code;
                if DimensionTransferFlag[5] then begin
                    DimCode := "New Dimension 5 Code";
                    DimMgmt.ValidateShortcutDimValues(5, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension5Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 5 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 5 Code" := GLEntry.lvnShortcutDimension5Code;
                DimensionChangeLedgerEntry."Old Dimension 6 Code" := GLEntry.lvnShortcutDimension6Code;
                if DimensionTransferFlag[6] then begin
                    DimCode := "New Dimension 6 Code";
                    DimMgmt.ValidateShortcutDimValues(6, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension6Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 6 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 6 Code" := GLEntry.lvnShortcutDimension6Code;
                DimensionChangeLedgerEntry."Old Dimension 7 Code" := GLEntry.lvnShortcutDimension7Code;
                if DimensionTransferFlag[7] then begin
                    DimCode := "New Dimension 7 Code";
                    DimMgmt.ValidateShortcutDimValues(7, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension7Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 7 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 7 Code" := GLEntry.lvnShortcutDimension7Code;
                DimensionChangeLedgerEntry."Old Dimension 8 Code" := GLEntry.lvnShortcutDimension8Code;
                if DimensionTransferFlag[8] then begin
                    DimCode := "New Dimension 8 Code";
                    DimMgmt.ValidateShortcutDimValues(8, DimCode, DimSetId);
                    GLEntry.lvnShortcutDimension8Code := DimCode;
                    DimensionChangeLedgerEntry."New Dimension 8 Code" := DimCode;
                end else
                    DimensionChangeLedgerEntry."New Dimension 8 Code" := GLEntry.lvnShortcutDimension8Code;
                DimensionChangeLedgerEntry."Old Business Unit Code" := GLEntry."Business Unit Code";
                if DimensionTransferFlag[9] then begin
                    GLEntry."Business Unit Code" := "New Business Unit Code";
                    DimensionChangeLedgerEntry."New Business Unit Code" := "New Business Unit Code";
                end else
                    DimensionChangeLedgerEntry."New Business Unit Code" := GLEntry."Business Unit Code";
                DimensionChangeLedgerEntry."Old Dimension Set ID" := GLEntry."Dimension Set ID";
                DimensionChangeLedgerEntry."New Dimension Set ID" := DimSetId;
                GLEntry."Dimension Set ID" := DimSetId;
                if LoanChangeFlag then begin
                    DimensionChangeLedgerEntry."Old Loan No." := GLEntry.lvnLoanNo;
                    DimensionChangeLedgerEntry."New Loan No." := "New Loan No.";
                    GLEntry.lvnLoanNo := "New Loan No.";
                end;
                DimensionChangeLedgerEntry.Insert();
                GLEntry.Modify(false);
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll();
                Progress.Close();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Group)
                {
                    Caption = 'Specify Dimensions to Transfer';

                    field(Status; 'Entries to Change' + Format(DimensionChangeJnlEntry.Count)) { Caption = 'Status'; ApplicationArea = All; Editable = false; }
                    field(DimensionTransferFlag1; DimensionTransferFlag[1]) { Caption = 'Dimension 1'; ApplicationArea = All; }
                    field(DimensionTransferFlag2; DimensionTransferFlag[2]) { Caption = 'Dimension 2'; ApplicationArea = All; }
                    field(DimensionTransferFlag3; DimensionTransferFlag[3]) { Caption = 'Dimension 3'; ApplicationArea = All; }
                    field(DimensionTransferFlag4; DimensionTransferFlag[4]) { Caption = 'Dimension 4'; ApplicationArea = All; }
                    field(DimensionTransferFlag5; DimensionTransferFlag[5]) { Caption = 'Dimension 5'; ApplicationArea = All; }
                    field(DimensionTransferFlag6; DimensionTransferFlag[6]) { Caption = 'Dimension 6'; ApplicationArea = All; }
                    field(DimensionTransferFlag7; DimensionTransferFlag[7]) { Caption = 'Dimension 7'; ApplicationArea = All; }
                    field(DimensionTransferFlag8; DimensionTransferFlag[8]) { Caption = 'Dimension 8'; ApplicationArea = All; }
                    field(DimensionTransferFlag9; DimensionTransferFlag[9]) { Caption = 'Business Unit'; ApplicationArea = All; }
                    field(LoanChangeFlag; LoanChangeFlag) { Caption = 'Loan No.'; ApplicationArea = All; }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            Index: Integer;
        begin
            if CloseAction = Action::OK then begin
                for Index := 1 to 9 do
                    if DimensionTransferFlag[Index] then
                        exit(true);
                if LoanChangeFlag then
                    exit(true);
                Message(SelectDimensionMsg);
                exit(false);
            end;
        end;
    }

    trigger OnPreReport()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
    begin
        LoanVisionSetup.Get();
        if LoanVisionSetup."Last Analysis Entry No." > 0 then
            Message(AnalysisEntriesRegenMsg);
        Current := 0;
        Total := DimensionChangeJnlEntry.Count();
    end;

    var
        DimensionTransferFlag: array[9] of Boolean;
        LoanChangeFlag: Boolean;
        Current: Integer;
        Total: Integer;
        Progress: Dialog;
        AnalysisEntriesRegenMsg: Label 'Note: All analysis entries will be deleted and should be regenerated.';
        SelectDimensionMsg: Label 'Please, select at least one dimension to transfer';
        ProcessingMsg: Label 'Processing entry #1####### of #2#######';
}