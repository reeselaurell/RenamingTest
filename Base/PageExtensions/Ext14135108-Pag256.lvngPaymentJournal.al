pageextension 14135108 lvngPaymentJournal extends "Payment Journal"
{
    layout
    {
        modify(ShortcutDimCode3) { Visible = true; }
        modify(ShortcutDimCode4) { Visible = true; }
        modify(ShortcutDimCode5) { Visible = true; }
        modify(ShortcutDimCode6) { Visible = true; }
        modify(ShortcutDimCode7) { Visible = true; }
        modify(ShortcutDimCode8) { Visible = true; }
        modify("Reason Code") { Visible = true; }
        modify("Currency Code") { Visible = false; }
        modify("Debit Amount") { Visible = true; }
        modify("Credit Amount") { Visible = true; }


        addlast(Control1)
        {
            field(lvngLoanNo; Rec.lvngLoanNo) { ApplicationArea = All; }
        }

        addfirst(factboxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
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
            action(lvngSuggestVendorPayments)
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
                    SuggestVendorPayments: Report lvngSuggestVendorPayments;
                begin
                    Clear(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RunModal;
                end;
            }
        }
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action(lvngFileImport)
            {
                Caption = 'Import From File';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportGenJnlFile: Codeunit lvngGenJnlFileImportManagement;
                    GenJnlImportBuffer: Record lvngGenJnlImportBuffer temporary;
                    ImportBufferError: Record lvngImportBufferError temporary;
                    JournalDataImport: Page lvngJournalDataImport;
                begin
                    Clear(ImportGenJnlFile);
                    if not ImportGenJnlFile.ManualFileImport(GenJnlImportBuffer, ImportBufferError) then
                        exit;
                    ImportBufferError.Reset();
                    if not ImportBufferError.IsEmpty() then begin
                        Clear(JournalDataImport);
                        JournalDataImport.SetParams(GenJnlImportBuffer, ImportBufferError);
                        JournalDataImport.Run();
                    end else
                        ImportGenJnlFile.CreateJournalLines(GenJnlImportBuffer, Rec."Journal Template Name", Rec."Journal Batch Name", CreateGuid());
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
                    OneOffCheckImport: XmlPort lvngOneOffChecksImport;
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
        Rec.lvngDocumentGuid := CreateGuid();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvngDocumentGuid);
    end;
}