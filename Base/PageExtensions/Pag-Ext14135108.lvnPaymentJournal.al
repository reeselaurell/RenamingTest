pageextension 14135108 "lvnPaymentJournal" extends "Payment Journal"
{
    layout
    {
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = true;
        }
        modify(ShortcutDimCode5)
        {
            Visible = true;
        }
        modify(ShortcutDimCode6)
        {
            Visible = true;
        }
        modify(ShortcutDimCode7)
        {
            Visible = true;
        }
        modify(ShortcutDimCode8)
        {
            Visible = true;
        }
        modify("Reason Code")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field(lvnLoanNo; Rec.lvnLoanNo)
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify(SuggestVendorPayments)
        {
            Visible = false;
        }
        addafter(SuggestVendorPayments)
        {
            action(lvnSuggestVendorPayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Vendor Payments';
                Ellipsis = true;
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';

                trigger OnAction()
                var
                    SuggestVendorPayments: Report lvnSuggestVendorPayments;
                begin
                    Clear(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RunModal;
                end;
            }
        }
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action(lvnFileImport)
            {
                Caption = 'Import From File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TempGenJnlImportBuffer: Record lvnGenJnlImportBuffer temporary;
                    TempImportBufferError: Record lvnImportBufferError temporary;
                    ImportGenJnlFile: Codeunit lvnGenJnlFileImportManagement;
                    JournalDataImport: Page lvnJournalDataImport;
                begin
                    Clear(ImportGenJnlFile);
                    if not ImportGenJnlFile.ManualFileImport(TempGenJnlImportBuffer, TempImportBufferError) then
                        exit;
                    TempImportBufferError.Reset();
                    if not TempImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(TempGenJnlImportBuffer, TempImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(TempGenJnlImportBuffer, Rec."Journal Template Name", Rec."Journal Batch Name", CreateGuid());
                    CurrPage.Update(false);
                end;
            }
        }
        addafter("Void &All Checks")
        {
            action(OneOffChecks)
            {
                Caption = 'Import One Off Checks';
                ApplicationArea = All;
                Image = ImportLog;
                Promoted = true;
                PromotedCategory = Category11;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    OneOffCheckImport: XMLport lvnOneOffChecksImport;
                begin
                    Clear(OneOffCheckImport);
                    OneOffCheckImport.SetParams(Rec."Journal Template Name", Rec."Journal Batch Name");
                    OneOffCheckImport.Run();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.lvnDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvnDocumentGuid);
    end;
}