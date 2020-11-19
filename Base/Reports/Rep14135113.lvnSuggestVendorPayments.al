report 14135113 "lvnSuggestVendorPayments"
{
    Caption = 'Suggest Vendor Payments';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting(Blocked) where(Blocked = filter(= " "));
            RequestFilterFields = "No.", lvnPaymentMethodFilter, lvnReasonCodeFilter, lvnUserIDFilter, lvnPostingGroupFilter;

            trigger OnAfterGetRecord()
            begin
                Clear(VendorBalance);
                CalcFields("Balance (LCY)");
                VendorBalance := "Balance (LCY)";

                if StopPayments then
                    CurrReport.Break;
                Window.Update(1, "No.");
                if VendorBalance > 0 then begin
                    GetVendLedgEntries(true, false);
                    GetVendLedgEntries(false, false);
                    CheckAmounts(false);
                    ClearNegative;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if UsePriority and not StopPayments then begin
                    Reset;
                    CopyFilters(Vend2);
                    SetCurrentKey(Priority);
                    SetRange(Priority, 0);
                    if FindSet then
                        repeat
                            Clear(VendorBalance);
                            CalcFields("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            if VendorBalance > 0 then begin
                                Window.Update(1, "No.");
                                GetVendLedgEntries(true, false);
                                GetVendLedgEntries(false, false);
                                CheckAmounts(false);
                                ClearNegative;
                            end;
                        until (Next = 0) or StopPayments;
                end;

                if UsePaymentDisc and not StopPayments then begin
                    Reset;
                    CopyFilters(Vend2);
                    Window2.Open(ProcessingPaymentDiscountsMsg);
                    if FindSet then
                        repeat
                            Clear(VendorBalance);
                            CalcFields("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            Window2.Update(1, "No.");
                            TempPayableVendLedgEntry.SetRange("Vendor No.", "No.");
                            if VendorBalance > 0 then begin
                                GetVendLedgEntries(true, true);
                                GetVendLedgEntries(false, true);
                                CheckAmounts(true);
                                ClearNegative;
                            end;
                        until (Next = 0) or StopPayments;
                    Window2.Close;
                end else
                    if FindSet then
                        repeat
                            ClearNegative;
                        until Next = 0;

                DimSetEntry.LockTable;
                GenJnlLine.LockTable;
                GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                if GenJnlLine.FindLast then begin
                    LastLineNo := GenJnlLine."Line No.";
                    GenJnlLine.Init;
                end;

                Window2.Open(InsertPayJournalLinesMsg);

                TempPayableVendLedgEntry.Reset;
                TempPayableVendLedgEntry.SetRange(Priority, 1, 2147483647);
                MakeGenJnlLines;
                TempPayableVendLedgEntry.Reset;
                TempPayableVendLedgEntry.SetRange(Priority, 0);
                MakeGenJnlLines;
                TempPayableVendLedgEntry.Reset;
                TempPayableVendLedgEntry.DeleteAll;

                Window2.Close;
                Window.Close;
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            var
                ConfirmManagement: Codeunit "Confirm Management";
            begin
                if LastDueDateToPayReq = 0D then
                    Error(SpecifyLastDateErr);
                if (PostingDate = 0D) and (not UseDueDateAsPostingDate) then
                    Error(SpecifyPostingDateErr);

                BankPmtType := GenJnlLine2."Bank Payment Type";
                BalAccType := GenJnlLine2."Bal. Account Type";
                BalAccNo := GenJnlLine2."Bal. Account No.";
                GenJnlLineInserted := false;
                SeveralCurrencies := false;
                MessageText := '';

                if ((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") or
                    SummarizePerVend) and
                   (NextDocNo = '')
                then
                    Error(SpecifyFirstDocNoErr);

                if ((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") and
                    not SummarizePerVend and
                    not DocNoPerLine)
                then
                    Error(SelectNewDocNoErr, GenJnlLine2.FieldCaption("Bank Payment Type"), Format(GenJnlLine2."Bank Payment Type"::"Manual Check"));

                if UsePaymentDisc and (LastDueDateToPayReq < WorkDate) then
                    if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(RunBatchJobMsg, WorkDate), true) then
                        Error(BatchJobInterruptErr);

                Vend2.CopyFilters(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                if UsePriority then begin
                    SetCurrentKey(Priority);
                    SetRange(Priority, 1, 2147483647);
                    UsePriority := true;
                end;
                Window.Open(ProccessingVendorsMsg);

                SelectedDim.SetRange("User ID", UserId);
                SelectedDim.SetRange("Object Type", 3);
                SelectedDim.SetRange("Object ID", Report::"Suggest Vendor Payments");
                SummarizePerDim := (not SelectedDim.IsEmpty) and SummarizePerVend;

                NextEntryNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Find Payments")
                    {
                        Caption = 'Find Payments';
                        field(LastPaymentDate; LastDueDateToPayReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Last Payment Date';
                            ToolTip = 'Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.';
                        }
                        field(FindPaymentDiscounts; UsePaymentDisc)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Find Payment Discounts';
                            Importance = Additional;
                            MultiLine = true;
                            ToolTip = 'Specifies if you want the batch job to include vendor ledger entries for which you can receive a payment discount.';

                            trigger OnValidate()
                            begin
                                if UsePaymentDisc and UseDueDateAsPostingDate then
                                    Error(PmtDiscUnavailableErr);
                            end;
                        }
                        field(UseVendorPriority; UsePriority)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Use Vendor Priority';
                            Importance = Additional;
                            ToolTip = 'Specifies if the Priority field on the vendor cards will determine in which order vendor entries are suggested for payment by the batch job. The batch job always prioritizes vendors for payment suggestions if you specify an available amount in the Available Amount (LCY) field.';

                            trigger OnValidate()
                            begin
                                if not UsePriority and (AmountAvailable <> 0) then
                                    Error(AmountAvailableNotZeroErr);
                            end;
                        }
                        field("Available Amount (LCY)"; AmountAvailable)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Available Amount (LCY)';
                            Importance = Additional;
                            ToolTip = 'Specifies a maximum amount (in LCY) that is available for payments. The batch job will then create a payment suggestion on the basis of this amount and the Use Vendor Priority check box. It will only include vendor entries that can be paid fully.';

                            trigger OnValidate()
                            begin
                                if AmountAvailable <> 0 then
                                    UsePriority := true;
                            end;
                        }
                        field(SkipExportedPaymentsField; SkipExportedPayments)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Skip Exported Payments';
                            Importance = Additional;
                            ToolTip = 'Specifies if you do not want the batch job to insert payment journal lines for documents for which payments have already been exported to a bank file.';
                        }
                        field(CheckOtherJournalBatchesField; CheckOtherJournalBatches)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Check Other Journal Batches';
                            ToolTip = 'Specifies whether to exclude payments that are already included in another journal batch from new suggested payments. This helps avoid duplicate payments.';
                        }
                    }
                    group("Summarize Results")
                    {
                        Caption = 'Summarize Results';
                        field(SummarizePerVendor; SummarizePerVend)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Summarize per Vendor';
                            ToolTip = 'Specifies if you want the batch job to make one line per vendor for each currency in which the vendor has ledger entries. If, for example, a vendor uses two currencies, the batch job will create two lines in the payment journal for this vendor. The batch job then uses the Applies-to ID field when the journal lines are posted to apply the lines to vendor ledger entries. If you do not select this check box, then the batch job will make one line per invoice.';

                            trigger OnValidate()
                            begin
                                if SummarizePerVend and UseDueDateAsPostingDate then
                                    Error(PmtDiscUnavailableErr);
                            end;
                        }
                        field(SummarizePerDimTxt; SummarizePerDimText)
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'By Dimension';
                            Editable = false;
                            Enabled = SummarizePerDimTextEnable;
                            Importance = Additional;
                            ToolTip = 'Specifies the dimensions that you want the batch job to consider.';

                            trigger OnAssistEdit()
                            var
                                DimSelectionBuf: Record "Dimension Selection Buffer";
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Suggest Vendor Payments", SummarizePerDimText);
                            end;
                        }
                    }
                    group("Fill in Journal Lines")
                    {
                        Caption = 'Fill in Journal Lines';
                        field(PostingDateField; PostingDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Date';
                            Editable = UseDueDateAsPostingDate = FALSE;
                            Importance = Promoted;
                            ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';

                            trigger OnValidate()
                            begin
                                ValidatePostingDate;
                            end;
                        }
                        field(UseDueDateAsPostingDateField; UseDueDateAsPostingDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Calculate Posting Date from Applies-to-Doc. Due Date';
                            Importance = Additional;
                            ToolTip = 'Specifies if the due date on the purchase invoice will be used as a basis to calculate the payment posting date.';

                            trigger OnValidate()
                            begin
                                if UseDueDateAsPostingDate and (SummarizePerVend or UsePaymentDisc) then
                                    Error(PmtDiscUnavailableErr);
                                if not UseDueDateAsPostingDate then
                                    Clear(DueDateOffset);
                            end;
                        }
                        field(Offset; DueDateOffset)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Applies-to-Doc. Due Date Offset';
                            Editable = UseDueDateAsPostingDate;
                            Enabled = UseDueDateAsPostingDate;
                            Importance = Additional;
                            ToolTip = 'Specifies a period of time that will separate the payment posting date from the due date on the invoice. Example 1: To pay the invoice on the Friday in the week of the due date, enter CW-2D (current week minus two days). Example 2: To pay the invoice two days before the due date, enter -2D (minus two days).';
                        }
                        field(StartingDocumentNo; NextDocNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Document No.';
                            ToolTip = 'Specifies the next available number in the number series for the journal batch that is linked to the payment journal. When you run the batch job, this is the document number that appears on the first payment journal line. You can also fill in this field manually.';

                            trigger OnValidate()
                            begin
                                if NextDocNo <> '' then
                                    if IncStr(NextDocNo) = '' then
                                        Error(StartingDocumentNoErr);
                            end;
                        }
                        field(NewDocNoPerLine; DocNoPerLine)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Doc. No. per Line';
                            Importance = Additional;
                            ToolTip = 'Specifies if you want the batch job to fill in the payment journal lines with consecutive document numbers, starting with the document number specified in the Starting Document No. field.';

                            trigger OnValidate()
                            begin
                                if not UsePriority and (AmountAvailable <> 0) then
                                    Error(AmountAvailableLCYNotZeroErr);
                            end;
                        }
                        field(BalAccountType; GenJnlLine2."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account type that payments on the payment journal are posted to.';

                            trigger OnValidate()
                            begin
                                GenJnlLine2."Bal. Account No." := '';
                            end;
                        }
                        field(BalAccountNo; GenJnlLine2."Bal. Account No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account No.';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account number that payments on the payment journal are posted to.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                case GenJnlLine2."Bal. Account Type" of
                                    GenJnlLine2."Bal. Account Type"::"G/L Account":
                                        if PAGE.RunModal(0, GLAcc) = ACTION::LookupOK then
                                            GenJnlLine2."Bal. Account No." := GLAcc."No.";
                                    GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                        Error(NotGLAccOrBankAccErr, GenJnlLine2.FieldCaption("Bal. Account Type"));
                                    GenJnlLine2."Bal. Account Type"::"Bank Account":
                                        if PAGE.RunModal(0, BankAcc) = ACTION::LookupOK then
                                            GenJnlLine2."Bal. Account No." := BankAcc."No.";
                                end;
                            end;

                            trigger OnValidate()
                            begin
                                if GenJnlLine2."Bal. Account No." <> '' then
                                    case GenJnlLine2."Bal. Account Type" of
                                        GenJnlLine2."Bal. Account Type"::"G/L Account":
                                            GLAcc.Get(GenJnlLine2."Bal. Account No.");
                                        GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                            Error(NotGLAccOrBankAccErr, GenJnlLine2.FieldCaption("Bal. Account Type"));
                                        GenJnlLine2."Bal. Account Type"::"Bank Account":
                                            BankAcc.Get(GenJnlLine2."Bal. Account No.");
                                    end;
                            end;
                        }
                        field(BankPaymentType; GenJnlLine2."Bank Payment Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bank Payment Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the check type to be used, if you use Bank Account as the balancing account type.';

                            trigger OnValidate()
                            begin
                                if (GenJnlLine2."Bal. Account Type" <> GenJnlLine2."Bal. Account Type"::"Bank Account") and
                                   (GenJnlLine2."Bank Payment Type".AsInteger() > 0)
                                then
                                    Error(
                                      MustBeFilledErr,
                                      GenJnlLine2.FieldCaption("Bank Payment Type"),
                                      GenJnlLine2.FieldCaption("Bal. Account Type"));
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SummarizePerDimTextEnable := true;
            SkipExportedPayments := true;
        end;

        trigger OnOpenPage()
        begin
            if LastDueDateToPayReq = 0D then
                LastDueDateToPayReq := WorkDate;
            if PostingDate = 0D then
                PostingDate := WorkDate;
            ValidatePostingDate;
            SetDefaults;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        EnvironmentInfo: Codeunit "Environment Information";
    begin
        if EnvironmentInfo.IsSaaS then
            CheckOtherJournalBatches := true;
    end;

    trigger OnPostReport()
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        Commit;
        if not TempVendorLedgEntry.IsEmpty then
            if ConfirmManagement.GetResponse(NoPaymentSuggestMsg, true) then
                Page.RunModal(0, TempVendorLedgEntry);

        if CheckOtherJournalBatches then
            if not TempErrorMessage.IsEmpty then
                if ConfirmManagement.GetResponse(ReviewNotSuggestedLinesQst, true) then
                    TempErrorMessage.ShowErrorMessages(false);
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        TempVendorLedgEntry.DeleteAll;
        ShowPostingDateWarning := false;
        PaymentMethodFilter := Vendor.GetFilter(lvnPaymentMethodFilter);
        PostingGroupFilter := Vendor.GetFilter(lvnPostingGroupFilter);
        ReasonCodeFilter := Vendor.GetFilter(lvnReasonCodeFilter);
        UserIDFilter := Vendor.GetFilter(lvnUserIDFilter);
    end;

    var
        Vend2: Record Vendor;
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DimSetEntry: Record "Dimension Set Entry";
        GenJnlLine2: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        TempPayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        CompanyInformation: Record "Company Information";
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        TempOldPaymentBuffer: Record "Payment Buffer" temporary;
        SelectedDim: Record "Selected Dimension";
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;
        TempErrorMessage: Record "Error Message" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DueDateOffset: DateFormula;
        Window: Dialog;
        Window2: Dialog;
        UsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        UsePriority: Boolean;
        SummarizePerVend: Boolean;
        SummarizePerDim: Boolean;
        SummarizePerDimText: Text[250];
        LastLineNo: Integer;
        NextEntryNo: Integer;
        UseDueDateAsPostingDate: Boolean;
        StopPayments: Boolean;
        DocNoPerLine: Boolean;
        BankPmtType: Enum "Bank Payment Type";
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        MessageText: Text;
        PaymentMethodFilter: Text;
        UserIDFilter: Text;
        ReasonCodeFilter: Text;
        PostingGroupFilter: Text;
        GenJnlLineInserted: Boolean;
        SeveralCurrencies: Boolean;
        [InDataSet]
        SummarizePerDimTextEnable: Boolean;
        ShowPostingDateWarning: Boolean;
        VendorBalance: Decimal;
        SkipExportedPayments: Boolean;
        CheckOtherJournalBatches: Boolean;
        SpecifyLastDateErr: Label 'In the Last Payment Date field, specify the last possible date that payments must be made.';
        SpecifyPostingDateErr: Label 'In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
        SpecifyFirstDocNoErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
        RunBatchJobMsg: Label 'The payment date is earlier than %1.\\Do you still want to run the batch job?', Comment = '%1 is a date';
        BatchJobInterruptErr: Label 'The batch job was interrupted.';
        ProccessingVendorsMsg: Label 'Processing vendors     #1##########', Comment = '#1 Vendor No.';
        ProcessingPaymentDiscountsMsg: Label 'Processing vendors for payment discounts #1##########', Comment = '#1 Vendor No.';
        InsertPayJournalLinesMsg: Label 'Inserting payment journal lines #1##########', Comment = '#1 Journal Line';
        NotGLAccOrBankAccErr: Label '%1 must be G/L Account or Bank Account.', Comment = '%1 = Bal. Account Type Caption';
        MustBeFilledErr: Label '%1 must be filled only when %2 is Bank Account.', Comment = '%1 = Bank Payment Type Caption; %2 = Bal. Account Type Caption';
        AmountAvailableNotZeroErr: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.';
        AmountAvailableLCYNotZeroErr: Label 'Use Vendor Priority must be activated when the value in the Amount Available Amount (LCY) field is not 0.';
        SelectNewDocNoErr: Label 'If %1 = %2 and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.', Comment = '%1 = Bank Payment Type Caption; %2 = Manual Check';
        OtherOpenVendLedgEntriesMsg: Label 'You have only created suggested vendor payment lines for the %1 %2.\ However, there are other open vendor ledger entries in currencies other than %2.\\', Comment = '%1 = Currency Code Caption; %2 = Currency Code Value';
        NoOtherOpenVendLedgEntriesMsg: Label 'You have only created suggested vendor payment lines for the %1 %2.\ There are no other open vendor ledger entries in other currencies.\\', Comment = '%1 = Currency Code Caption; %2 = Currency Code Value';
        AllCurrenciesMsg: Label 'You have created suggested vendor payment lines for all currencies.\\';
        NoPaymentSuggestMsg: Label 'There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
        ExistingPayToVendorNoMsg: Label 'The %1 with the number %2 has a %3 with the number %4.', Comment = '%1 = Vendor Table Caption;%2 = Vendor No.;%3 = Pay-to Vendor No. Caption ;%4 = Pay-to Vendor No. Value ;';
        ReplacePostingDateMsg: Label 'For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
        PmtDiscUnavailableErr: Label 'You cannot use Find Payment Discounts or Summarize per Vendor together with Calculate Posting Date from Applies-to-Doc. Due Date, because the resulting posting date might not match the payment discount date.';
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        StartingDocumentNoErr: Label 'The value in the Starting Document No. field must have a number so that we can assign the next number in the series.';
        ReviewNotSuggestedLinesQst: Label 'There are payments in other journal batches that are not suggested here. This helps avoid duplicate payments. To add them to this batch, remove the payment from the other batch, and then suggest payments again.\\Do you want to review the payments from the other journal batches now?';
        NotSuggestedPaymentInfoTxt: Label 'There are payments in %1 %2, %3 %4, %5 %6', Comment = '%1 = Journal Template Name Caption;%2 = Journal Template Name Value;%3 = Journal Batch Name Caption;%4 = Journal Batch Name Value ;%5 = Applies-to Doc. No. Caption;%6 = Applies-to Doc. No. Value;';

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine := NewGenJnlLine;
    end;

    procedure InitializeRequest(
        LastPmtDate: Date;
        FindPmtDisc: Boolean;
        NewAvailableAmount: Decimal;
        NewSkipExportedPayments: Boolean;
        NewPostingDate: Date;
        NewStartDocNo: Code[20];
        NewSummarizePerVend: Boolean;
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        BankPmtType: Enum "Bank Payment Type")
    begin
        LastDueDateToPayReq := LastPmtDate;
        UsePaymentDisc := FindPmtDisc;
        AmountAvailable := NewAvailableAmount;
        SkipExportedPayments := NewSkipExportedPayments;
        PostingDate := NewPostingDate;
        NextDocNo := NewStartDocNo;
        SummarizePerVend := NewSummarizePerVend;
        GenJnlLine2."Bal. Account Type" := BalAccType;
        GenJnlLine2."Bal. Account No." := BalAccNo;
        GenJnlLine2."Bank Payment Type" := BankPmtType;
    end;

    local procedure ValidatePostingDate()
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        if GenJnlBatch."No. Series" = '' then
            NextDocNo := ''
        else begin
            NextDocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostingDate, false);
            Clear(NoSeriesMgt);
        end;
    end;

    local procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    var
        IsHandled: Boolean;
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange(Positive, Positive);
        VendLedgEntry.SetRange("Applies-to ID", '');
        VendLedgEntry.SetFilter("Document Type", '<>%1', VendLedgEntry."Document Type"::Payment);
        if Future then begin
            VendLedgEntry.SetRange("Due Date", LastDueDateToPayReq + 1, DMY2Date(31, 12, 9999));
            VendLedgEntry.SetRange("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SetFilter("Remaining Pmt. Disc. Possible", '<>0');
        end else
            VendLedgEntry.SetRange("Due Date", 0D, LastDueDateToPayReq);
        if SkipExportedPayments then
            VendLedgEntry.SetRange("Exported to Payment File", false);
        VendLedgEntry.SetRange("On Hold", '');
        VendLedgEntry.SetFilter("Currency Code", Vendor.GetFilter("Currency Filter"));
        VendLedgEntry.SetFilter("Global Dimension 1 Code", Vendor.GetFilter("Global Dimension 1 Filter"));
        VendLedgEntry.SetFilter("Global Dimension 2 Code", Vendor.GetFilter("Global Dimension 2 Filter"));
        if UserIDFilter <> '' then
            VendLedgEntry.SetFilter("User ID", UserIDFilter);
        if PostingGroupFilter <> '' then
            VendLedgEntry.SetFilter("Vendor Posting Group", PostingGroupFilter);
        if ReasonCodeFilter <> '' then
            VendLedgEntry.SetFilter("Reason Code", ReasonCodeFilter);
        if PaymentMethodFilter <> '' then
            VendLedgEntry.SetFilter("Payment Method Code", PaymentMethodFilter);
        if VendLedgEntry.FindSet then
            repeat
                IsHandled := false;
                if not IsHandled then begin
                    SaveAmount;
                    if VendLedgEntry."Accepted Pmt. Disc. Tolerance" or (VendLedgEntry."Accepted Payment Tolerance" <> 0) then begin
                        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
                        VendLedgEntry."Accepted Payment Tolerance" := 0;
                        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
                    end;
                end;
            until VendLedgEntry.Next = 0;
    end;

    local procedure SaveAmount()
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        GenJnlLine.Init;
        SetPostingDate(GenJnlLine, VendLedgEntry."Due Date", PostingDate);
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        Vend2.Get(VendLedgEntry."Vendor No.");
        Vend2.CheckBlockedVendOnJnls(Vend2, GenJnlLine."Document Type", false);
        GenJnlLine.Description := Vend2.Name;
        GenJnlLine."Posting Group" := Vend2."Vendor Posting Group";
        GenJnlLine."Salespers./Purch. Code" := Vend2."Purchaser Code";
        GenJnlLine."Payment Terms Code" := Vend2."Payment Terms Code";
        GenJnlLine.Validate("Bill-to/Pay-to No.", GenJnlLine."Account No.");
        GenJnlLine.Validate("Sell-to/Buy-from No.", GenJnlLine."Account No.");
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlLine.Validate("Currency Code", VendLedgEntry."Currency Code");
        GenJnlLine.Validate("Payment Terms Code");
        GenJnlLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
        GenJnlLine.Comment := VendLedgEntry.Description;
        GenJnlLine."Payment Method Code" := VendLedgEntry."Payment Method Code";
        VendLedgEntry.CalcFields("Remaining Amount");
        if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) then
            GenJnlLine.Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
        else
            GenJnlLine.Amount := -VendLedgEntry."Remaining Amount";
        GenJnlLine.Validate(Amount);

        if UsePriority then
            TempPayableVendLedgEntry.Priority := Vendor.Priority
        else
            TempPayableVendLedgEntry.Priority := 0;
        TempPayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        TempPayableVendLedgEntry."Entry No." := NextEntryNo;
        TempPayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        TempPayableVendLedgEntry.Amount := GenJnlLine.Amount;
        TempPayableVendLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        TempPayableVendLedgEntry.Positive := (TempPayableVendLedgEntry.Amount > 0);
        TempPayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        TempPayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        TempPayableVendLedgEntry.Insert;
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        TempPayableVendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        TempPayableVendLedgEntry.SetRange(Future, Future);

        if TempPayableVendLedgEntry.FindSet then begin
            repeat
                if TempPayableVendLedgEntry."Currency Code" <> PrevCurrency then begin
                    if CurrencyBalance > 0 then
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := TempPayableVendLedgEntry."Currency Code";
                end;
                if (OriginalAmtAvailable = 0) or
                   (AmountAvailable >= CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)")
                then
                    CurrencyBalance := CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)"
                else
                    TempPayableVendLedgEntry.Delete;
            until TempPayableVendLedgEntry.Next = 0;
            if OriginalAmtAvailable > 0 then
                AmountAvailable := AmountAvailable - CurrencyBalance;
            if (OriginalAmtAvailable > 0) and (AmountAvailable <= 0) then
                StopPayments := true;
        end;
        TempPayableVendLedgEntry.Reset;
    end;

    local procedure MakeGenJnlLines()
    var
        GenJnlLine1: Record "Gen. Journal Line";
        DimBuf: Record "Dimension Buffer";
        RemainingAmtAvailable: Decimal;
        HandledEntry: Boolean;
    begin
        TempPaymentBuffer.Reset;
        TempPaymentBuffer.DeleteAll;

        if BalAccType = BalAccType::"Bank Account" then begin
            CheckCurrencies(BalAccType, BalAccNo, TempPayableVendLedgEntry);
            SetBankAccCurrencyFilter(BalAccType, BalAccNo, TempPayableVendLedgEntry);
        end;

        if OriginalAmtAvailable <> 0 then begin
            RemainingAmtAvailable := OriginalAmtAvailable;
            RemovePaymentsAboveLimit(TempPayableVendLedgEntry, RemainingAmtAvailable);
        end;
        if TempPayableVendLedgEntry.Find('-') then
            repeat
                TempPayableVendLedgEntry.SetRange("Vendor No.", TempPayableVendLedgEntry."Vendor No.");
                TempPayableVendLedgEntry.Find('-');
                repeat
                    VendLedgEntry.Get(TempPayableVendLedgEntry."Vendor Ledg. Entry No.");
                    SetPostingDate(GenJnlLine1, VendLedgEntry."Due Date", PostingDate);
                    HandledEntry := VendLedgEntry."Posting Date" <= GenJnlLine1."Posting Date";
                    if HandledEntry then begin
                        TempPaymentBuffer."Vendor No." := VendLedgEntry."Vendor No.";
                        TempPaymentBuffer."Currency Code" := VendLedgEntry."Currency Code";
                        TempPaymentBuffer."Payment Method Code" := VendLedgEntry."Payment Method Code";

                        CopyFieldsFromVendorLedgerEntry(TempPaymentBuffer, VendLedgEntry);

                        SetTempPaymentBufferDims(DimBuf);

                        VendLedgEntry.CalcFields("Remaining Amount");

                        if IsNotAppliedEntry(GenJnlLine, VendLedgEntry) then
                            if SummarizePerVend then begin
                                TempPaymentBuffer."Vendor Ledg. Entry No." := 0;
                                if TempPaymentBuffer.Find then begin
                                    TempPaymentBuffer.Amount := TempPaymentBuffer.Amount + TempPayableVendLedgEntry.Amount;
                                    TempPaymentBuffer.Modify;
                                end else begin
                                    TempPaymentBuffer."Document No." := NextDocNo;
                                    NextDocNo := IncStr(NextDocNo);
                                    TempPaymentBuffer.Amount := TempPayableVendLedgEntry.Amount;
                                    Window2.Update(1, VendLedgEntry."Vendor No.");
                                    TempPaymentBuffer.Insert;
                                end;
                                VendLedgEntry."Applies-to ID" := TempPaymentBuffer."Document No.";
                            end else begin
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendLedgEntry."Document Type";
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. No." := VendLedgEntry."Document No.";
                                TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                TempPaymentBuffer."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
                                TempPaymentBuffer.Amount := TempPayableVendLedgEntry.Amount;
                                Window2.Update(1, VendLedgEntry."Vendor No.");
                                TempPaymentBuffer.Insert;
                            end;

                        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
                    end else begin
                        TempVendorLedgEntry := VendLedgEntry;
                        TempVendorLedgEntry.Insert;
                    end;

                    TempPayableVendLedgEntry.Delete;
                    if OriginalAmtAvailable <> 0 then begin
                        RemainingAmtAvailable := RemainingAmtAvailable - TempPayableVendLedgEntry."Amount (LCY)";
                        RemovePaymentsAboveLimit(TempPayableVendLedgEntry, RemainingAmtAvailable);
                    end;

                until not TempPayableVendLedgEntry.FindSet;
                TempPayableVendLedgEntry.DeleteAll;
                TempPayableVendLedgEntry.SetRange("Vendor No.");
            until not TempPayableVendLedgEntry.Find('-');

        Clear(TempOldPaymentBuffer);
        TempPaymentBuffer.SetCurrentKey("Document No.");
        TempPaymentBuffer.SetFilter(
          "Vendor Ledg. Entry Doc. Type", '<>%1&<>%2', TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);

        if TempPaymentBuffer.Find('-') then
            repeat
                InsertGenJournalLine;
            until TempPaymentBuffer.Next = 0;
    end;

    local procedure InsertGenJournalLine()
    var
        Vendor: Record Vendor;
    begin
        GenJnlLine.Init;
        Window2.Update(1, TempPaymentBuffer."Vendor No.");
        LastLineNo := LastLineNo + 10000;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        if SummarizePerVend then
            GenJnlLine."Document No." := TempPaymentBuffer."Document No."
        else
            if DocNoPerLine then begin
                if TempPaymentBuffer.Amount < 0 then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;

                GenJnlLine."Document No." := NextDocNo;
                NextDocNo := IncStr(NextDocNo);
            end else
                if (TempPaymentBuffer."Vendor No." = TempOldPaymentBuffer."Vendor No.") and
                   (TempPaymentBuffer."Currency Code" = TempOldPaymentBuffer."Currency Code")
                then
                    GenJnlLine."Document No." := TempOldPaymentBuffer."Document No."
                else begin
                    GenJnlLine."Document No." := NextDocNo;
                    NextDocNo := IncStr(NextDocNo);
                    TempOldPaymentBuffer := TempPaymentBuffer;
                    TempOldPaymentBuffer."Document No." := GenJnlLine."Document No.";
                end;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.SetHideValidation(true);
        ShowPostingDateWarning := ShowPostingDateWarning or
          SetPostingDate(GenJnlLine, GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."), PostingDate);
        GenJnlLine.Validate("Account No.", TempPaymentBuffer."Vendor No.");
        Vendor.Get(TempPaymentBuffer."Vendor No.");
        if (Vendor."Pay-to Vendor No." <> '') and (Vendor."Pay-to Vendor No." <> GenJnlLine."Account No.") then
            Message(ExistingPayToVendorNoMsg, Vendor.TableCaption, Vendor."No.", Vendor.FieldCaption("Pay-to Vendor No."),
              Vendor."Pay-to Vendor No.");
        GenJnlLine."Bal. Account Type" := BalAccType;
        GenJnlLine.Validate("Bal. Account No.", BalAccNo);
        GenJnlLine.Validate("Currency Code", TempPaymentBuffer."Currency Code");
        GenJnlLine."Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
        GenJnlLine."Bank Payment Type" := BankPmtType;
        if SummarizePerVend then
            GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
        GenJnlLine.Description := Vendor.Name;
        GenJnlLine."Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
        if not SummarizePerVend then
            if VendLedgEntry.Get(GenJnlLine."Source Line No.") then
                GenJnlLine.Description := VendLedgEntry.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJnlLine.Validate(Amount, TempPaymentBuffer.Amount);
        GenJnlLine."Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
        GenJnlLine."Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
        GenJnlLine."Payment Method Code" := TempPaymentBuffer."Payment Method Code";

        CopyFieldsToGenJournalLine(TempPaymentBuffer, GenJnlLine);

        UpdateDimensions(GenJnlLine);
        GenJnlLine.Insert;
        GenJnlLineInserted := true;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line")
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
    begin
        NewDimensionID := GenJnlLine."Dimension Set ID";
        if SummarizePerVend then begin
            DimBuf.Reset;
            DimBuf.DeleteAll;
            DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.", DimBuf);
            if DimBuf.FindSet then
                repeat
                    DimVal.Get(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                    TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
                    TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
                    TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                    TempDimSetEntry.Insert;
                until DimBuf.Next = 0;
            NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            GenJnlLine."Dimension Set ID" := NewDimensionID;
        end;
        GenJnlLine.CreateDim(
          DimMgt.TypeToTableID1(GenJnlLine."Account Type".AsInteger()), GenJnlLine."Account No.",
          DimMgt.TypeToTableID1(GenJnlLine."Bal. Account Type".AsInteger()), GenJnlLine."Bal. Account No.",
          Database::Job, GenJnlLine."Job No.",
          Database::"Salesperson/Purchaser", GenJnlLine."Salespers./Purch. Code",
          Database::Campaign, GenJnlLine."Campaign No.");
        if NewDimensionID <> GenJnlLine."Dimension Set ID" then begin
            DimSetIDArr[1] := GenJnlLine."Dimension Set ID";
            DimSetIDArr[2] := NewDimensionID;
            GenJnlLine."Dimension Set ID" :=
              DimMgt.GetCombinedDimensionSetID(DimSetIDArr, GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
        end;

        if SummarizePerVend then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, GenJnlLine."Dimension Set ID");
            if AdjustAgainstSelectedDim(TempDimSetEntry, TempDimSetEntry2) then
                GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
              GenJnlLine."Shortcut Dimension 2 Code");
        end;
    end;

    local procedure SetBankAccCurrencyFilter(
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAcc: Record "Bank Account";
    begin
        if BalAccType = BalAccType::"Bank Account" then
            if BalAccNo <> '' then begin
                BankAcc.Get(BalAccNo);
                if BankAcc."Currency Code" <> '' then
                    TmpPayableVendLedgEntry.SetRange("Currency Code", BankAcc."Currency Code");
            end;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        if GenJnlLineInserted then begin
            if ShowPostingDateWarning then
                Text += ReplacePostingDateMsg;
            if Text <> '' then
                Message(Text);
        end;
    end;

    local procedure CheckCurrencies(
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAcc: Record "Bank Account";
        TempPayableVendLedgEntry2: Record "Payable Vendor Ledger Entry" temporary;
    begin
        if BalAccType = BalAccType::"Bank Account" then
            if BalAccNo <> '' then begin
                BankAcc.Get(BalAccNo);
                if BankAcc."Currency Code" <> '' then begin
                    TempPayableVendLedgEntry2.Reset;
                    TempPayableVendLedgEntry2.DeleteAll;
                    if TmpPayableVendLedgEntry.FindSet then
                        repeat
                            TempPayableVendLedgEntry2 := TmpPayableVendLedgEntry;
                            TempPayableVendLedgEntry2.Insert;
                        until TmpPayableVendLedgEntry.Next = 0;

                    TempPayableVendLedgEntry2.SetFilter("Currency Code", '<>%1', BankAcc."Currency Code");
                    SeveralCurrencies := SeveralCurrencies or TempPayableVendLedgEntry2.FindFirst;

                    if SeveralCurrencies then
                        MessageText :=
                          StrSubstNo(OtherOpenVendLedgEntriesMsg, BankAcc.FieldCaption("Currency Code"), BankAcc."Currency Code")
                    else
                        MessageText :=
                          StrSubstNo(NoOtherOpenVendLedgEntriesMsg, BankAcc.FieldCaption("Currency Code"), BankAcc."Currency Code");
                end else
                    MessageText := AllCurrenciesMsg;
            end;
    end;

    local procedure ClearNegative()
    var
        TempCurrency: Record Currency temporary;
        TempPayableVendLedgEntry2: Record "Payable Vendor Ledger Entry" temporary;
        CurrencyBalance: Decimal;
    begin
        Clear(TempPayableVendLedgEntry);
        TempPayableVendLedgEntry.SetRange("Vendor No.", Vendor."No.");

        while TempPayableVendLedgEntry.Next <> 0 do begin
            TempCurrency.Code := TempPayableVendLedgEntry."Currency Code";
            CurrencyBalance := 0;
            if TempCurrency.Insert then begin
                TempPayableVendLedgEntry2 := TempPayableVendLedgEntry;
                TempPayableVendLedgEntry.SetRange("Currency Code", TempPayableVendLedgEntry."Currency Code");
                repeat
                    CurrencyBalance := CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)"
                until TempPayableVendLedgEntry.Next = 0;
                if CurrencyBalance < 0 then begin
                    TempPayableVendLedgEntry.DeleteAll;
                    AmountAvailable += CurrencyBalance;
                end;
                TempPayableVendLedgEntry.SetRange("Currency Code");
                TempPayableVendLedgEntry := TempPayableVendLedgEntry2;
            end;
        end;
        TempPayableVendLedgEntry.Reset;
    end;

    local procedure DimCodeIsInDimBuf(DimCode: Code[20]; DimBuf: Record "Dimension Buffer"): Boolean
    begin
        DimBuf.Reset;
        DimBuf.SetRange("Dimension Code", DimCode);
        exit(not DimBuf.IsEmpty);
    end;

    local procedure RemovePaymentsAboveLimit(
        var TempPayableVendLedgEntry: Record "Payable Vendor Ledger Entry";
        RemainingAmtAvailable: Decimal)
    begin
        TempPayableVendLedgEntry.SetFilter("Amount (LCY)", '>%1', RemainingAmtAvailable);
        TempPayableVendLedgEntry.DeleteAll;
        TempPayableVendLedgEntry.SetRange("Amount (LCY)");
    end;

    local procedure InsertDimBuf(
        var DimBuf: Record "Dimension Buffer";
        TableID: Integer;
        EntryNo: Integer;
        DimCode: Code[20];
        DimValue: Code[20])
    begin
        DimBuf.Init;
        DimBuf."Table ID" := TableID;
        DimBuf."Entry No." := EntryNo;
        DimBuf."Dimension Code" := DimCode;
        DimBuf."Dimension Value Code" := DimValue;
        DimBuf.Insert;
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if SummarizePerVend then
            exit(CompanyInformation.Name);

        VendorLedgerEntry.Get(TempPaymentBuffer."Vendor Ledg. Entry No.");
        if VendorLedgerEntry."Message to Recipient" <> '' then
            exit(VendorLedgerEntry."Message to Recipient");

        exit(
          StrSubstNo(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;

    local procedure SetPostingDate(var GenJnlLine: Record "Gen. Journal Line"; DueDate: Date; PostingDate: Date): Boolean
    begin
        if not UseDueDateAsPostingDate then begin
            GenJnlLine.Validate("Posting Date", PostingDate);
            exit(false);
        end;

        if DueDate = 0D then
            DueDate := GenJnlLine.GetAppliesToDocDueDate;
        exit(GenJnlLine.SetPostingDateAsDueDate(DueDate, DueDateOffset));
    end;

    local procedure GetApplDueDate(VendLedgEntryNo: Integer): Date
    var
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        if AppliedVendLedgEntry.Get(VendLedgEntryNo) then
            exit(AppliedVendLedgEntry."Due Date");

        exit(PostingDate);
    end;

    local procedure AdjustAgainstSelectedDim(
        var TempDimSetEntry: Record "Dimension Set Entry" temporary;
        var TempDimSetEntry2: Record "Dimension Set Entry" temporary): Boolean
    begin
        if SelectedDim.FindSet then begin
            repeat
                TempDimSetEntry.SetRange("Dimension Code", SelectedDim."Dimension Code");
                if TempDimSetEntry.FindFirst then begin
                    TempDimSetEntry2.TransferFields(TempDimSetEntry, true);
                    TempDimSetEntry2.Insert;
                end;
            until SelectedDim.Next = 0;
            exit(true);
        end;
        exit(false);
    end;

    local procedure SetTempPaymentBufferDims(var DimBuf: Record "Dimension Buffer")
    var
        GLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
    begin
        if SummarizePerDim then begin
            DimBuf.Reset;
            DimBuf.DeleteAll;
            if SelectedDim.FindSet then
                repeat
                    if DimSetEntry.Get(VendLedgEntry."Dimension Set ID", SelectedDim."Dimension Code") then
                        InsertDimBuf(DimBuf, Database::"Dimension Buffer", 0, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                until SelectedDim.Next = 0;
            EntryNo := DimBufMgt.FindDimensions(DimBuf);
            if EntryNo = 0 then
                EntryNo := DimBufMgt.InsertDimensions(DimBuf);
            TempPaymentBuffer."Dimension Entry No." := EntryNo;
            if TempPaymentBuffer."Dimension Entry No." <> 0 then begin
                GLSetup.Get;
                if DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code", DimBuf) then
                    TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code"
                else
                    TempPaymentBuffer."Global Dimension 1 Code" := '';
                if DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code", DimBuf) then
                    TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code"
                else
                    TempPaymentBuffer."Global Dimension 2 Code" := '';
            end else begin
                TempPaymentBuffer."Global Dimension 1 Code" := '';
                TempPaymentBuffer."Global Dimension 2 Code" := '';
            end;
            TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
        end else begin
            TempPaymentBuffer."Dimension Entry No." := 0;
            TempPaymentBuffer."Global Dimension 1 Code" := '';
            TempPaymentBuffer."Global Dimension 2 Code" := '';
            TempPaymentBuffer."Dimension Set ID" := 0;
        end;
    end;

    local procedure IsNotAppliedEntry(
        GenJournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry"): Boolean
    begin
        exit(
          IsNotAppliedToCurrentBatchLine(GenJournalLine, VendorLedgerEntry) and
          IsNotAppliedToOtherBatchLine(GenJournalLine, VendorLedgerEntry));
    end;

    local procedure IsNotAppliedToCurrentBatchLine(
        GenJournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry"): Boolean
    var
        PaymentGenJournalLine: Record "Gen. Journal Line";
    begin
        PaymentGenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        PaymentGenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        PaymentGenJournalLine.SetRange("Account Type", GenJournalLine."Account Type"::Vendor);
        PaymentGenJournalLine.SetRange("Account No.", VendorLedgerEntry."Vendor No.");
        PaymentGenJournalLine.SetRange("Applies-to Doc. Type", VendorLedgerEntry."Document Type");
        PaymentGenJournalLine.SetRange("Applies-to Doc. No.", VendorLedgerEntry."Document No.");
        exit(PaymentGenJournalLine.IsEmpty);
    end;

    local procedure IsNotAppliedToOtherBatchLine(
        GenJournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry"): Boolean
    var
        PaymentGenJournalLine: Record "Gen. Journal Line";
    begin
        if not CheckOtherJournalBatches then
            exit(true);

        PaymentGenJournalLine.SetRange("Document Type", PaymentGenJournalLine."Document Type"::Payment);
        PaymentGenJournalLine.SetRange("Account Type", PaymentGenJournalLine."Account Type"::Vendor);
        PaymentGenJournalLine.SetRange("Account No.", VendorLedgerEntry."Vendor No.");
        PaymentGenJournalLine.SetRange("Applies-to Doc. Type", VendorLedgerEntry."Document Type");
        PaymentGenJournalLine.SetRange("Applies-to Doc. No.", VendorLedgerEntry."Document No.");
        if PaymentGenJournalLine.IsEmpty then
            exit(true);

        if PaymentGenJournalLine.FindSet then begin
            repeat
                if (PaymentGenJournalLine."Journal Batch Name" <> GenJournalLine."Journal Batch Name") or
                   (PaymentGenJournalLine."Journal Template Name" <> GenJournalLine."Journal Template Name")
                then
                    LogNotSuggestedPaymentMessage(PaymentGenJournalLine);
            until PaymentGenJournalLine.Next = 0;
            exit(TempErrorMessage.IsEmpty);
        end;
    end;

    local procedure LogNotSuggestedPaymentMessage(GenJournalLine: Record "Gen. Journal Line")
    begin
        TempErrorMessage.LogMessage(
          GenJournalLine, GenJournalLine.FieldNo("Applies-to ID"),
          TempErrorMessage."Message Type"::Warning,
          StrSubstNo(
            NotSuggestedPaymentInfoTxt,
            GenJournalLine.FieldCaption("Journal Template Name"),
            GenJournalLine."Journal Template Name",
            GenJournalLine.FieldCaption("Journal Batch Name"),
            GenJournalLine."Journal Batch Name",
            GenJournalLine.FieldCaption("Applies-to Doc. No."),
            GenJournalLine."Applies-to Doc. No."));
    end;

    local procedure SetDefaults()
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        if GenJnlBatch."Bal. Account No." <> '' then begin
            GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
        end;
    end;

    local procedure CopyFieldsFromVendorLedgerEntry(
        var PaymentBuffer: Record "Payment Buffer";
        VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        PaymentBuffer."Creditor No." := VendorLedgerEntry."Creditor No.";
        PaymentBuffer."Payment Reference" := VendorLedgerEntry."Payment Reference";
        PaymentBuffer."Exported to Payment File" := VendorLedgerEntry."Exported to Payment File";
        PaymentBuffer."Applies-to Ext. Doc. No." := VendorLedgerEntry."External Document No.";
        PaymentBuffer.lvnPostingGroupCode := VendorLedgerEntry."Vendor Posting Group";
    end;

    local procedure CopyFieldsToGenJournalLine(
        PaymentBuffer: Record "Payment Buffer";
        var GenJournalLine: Record "Gen. Journal Line")
    var
        PurchInvLine: Record "Purch. Inv. Line";
        TempLoanReportingBuffer: Record lvnLoanReportingBuffer temporary;
        MultipleLoans: Boolean;
    begin
        GenJournalLine."Creditor No." := PaymentBuffer."Creditor No.";
        GenJournalLine."Payment Reference" := PaymentBuffer."Payment Reference";
        GenJournalLine."Exported to Payment File" := PaymentBuffer."Exported to Payment File";
        GenJournalLine."Applies-to Ext. Doc. No." := PaymentBuffer."Applies-to Ext. Doc. No.";
        GenJournalLine."Posting Group" := PaymentBuffer.lvnPostingGroupCode;
        if VendLedgEntry.Get(GenJournalLine."Source Line No.") then begin
            GenJournalLine."External Document No." := VendLedgEntry."External Document No.";
            GenJournalLine.lvnLoanNo := VendLedgEntry.lvnLoanNo;
            GenJournalLine."Reason Code" := VendLedgEntry."Reason Code";
            GenJournalLine.Comment := VendLedgEntry.Description;
            if (GenJournalLine.lvnLoanNo = '') and (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice) then begin
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", VendLedgEntry."Document No.");
                PurchInvLine.SetFilter(lvnLoanNo, '<>%1', '');
                if PurchInvLine.FindSet() then begin
                    repeat
                        Clear(TempLoanReportingBuffer);
                        TempLoanReportingBuffer."Loan No." := PurchInvLine.lvnLoanNo;
                        if TempLoanReportingBuffer.Insert(false) then;
                        MultipleLoans := TempLoanReportingBuffer.Count() > 1;
                    until (PurchInvLine.Next() = 0) or (MultipleLoans);
                    if not MultipleLoans then begin
                        TempLoanReportingBuffer.Reset();
                        if TempLoanReportingBuffer.FindFirst() then
                            GenJournalLine.lvnLoanNo := TempLoanReportingBuffer."Loan No.";
                    end;
                end;
            end;
        end;
    end;
}