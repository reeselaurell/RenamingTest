xmlport 14135100 lvngGeneralLedgerEntriesExport
{
    Direction = Export;
    Caption = 'General Ledger Entries Export';
    Format = VariableText;
    FieldSeparator = ',';
    FileName = 'GL Entries Export.csv';

    schema
    {
        textelement(Root)
        {
            tableelement(Header; Integer)
            {
                SourceTableView = sorting(Number) where(Number = const(1));

                textelement(EntryNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EntryNoCapt := 'Entry No.';
                    end;
                }
                textelement(PostingDateCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PostingDateCapt := 'Posting Date';
                    end;
                }
                textelement(EntryDateCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EntryDateCapt := 'Entry Date';
                    end;
                }
                textelement(DocumentTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DocumentTypeCapt := 'Document Type';
                    end;
                }
                textelement(DocumentNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DocumentNoCapt := 'Document No.';
                    end;
                }
                textelement(GLAccountNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GLAccountNoCapt := 'G/L Account No.';
                    end;
                }
                textelement(GLAccountNameCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GLAccountNameCapt := 'G/L Account Name';
                    end;
                }
                textelement(DescriptionCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DescriptionCapt := 'Description';
                    end;
                }
                textelement(AmountCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AmountCapt := 'Amount';
                    end;
                }
                textelement(ReasonCodeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReasonCodeCapt := 'Reason Code';
                    end;
                }
                textelement(BalAccountTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BalAccountTypeCapt := 'Bal. Account Type';
                    end;
                }
                textelement(BalAccountNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BalAccountNoCapt := 'Bal. Account No.';
                    end;
                }
                textelement(LoanNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LoanNoCapt := 'Loan No.';
                    end;
                }
                textelement(SourceTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceTypeCapt := 'Source Type';
                    end;
                }
                textelement(SourceNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceNoCapt := 'Source No.';
                    end;
                }
                textelement(SourceNameCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceNameCapt := 'Source Name';
                    end;
                }
                textelement(ReversedCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReversedCapt := 'Reversed';
                    end;
                }
                textelement(UserIdCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UserIdCapt := 'User ID';
                    end;
                }
                textelement(Dim1Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim1Capt := GeneralLedgerSetup."Shortcut Dimension 1 Code";
                    end;
                }
                textelement(Dim2Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim2Capt := GeneralLedgerSetup."Shortcut Dimension 2 Code";
                    end;
                }
                textelement(Dim3Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim3Capt := GeneralLedgerSetup."Shortcut Dimension 3 Code";
                    end;
                }
                textelement(Dim4Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim4Capt := GeneralLedgerSetup."Shortcut Dimension 4 Code";
                    end;
                }
                textelement(Dim5Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim5Capt := GeneralLedgerSetup."Shortcut Dimension 5 Code";
                    end;
                }
                textelement(Dim6Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim6Capt := GeneralLedgerSetup."Shortcut Dimension 6 Code";
                    end;
                }
                textelement(Dim7Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim7Capt := GeneralLedgerSetup."Shortcut Dimension 7 Code";
                    end;
                }
                textelement(Dim8Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim8Capt := GeneralLedgerSetup."Shortcut Dimension 8 Code";
                    end;
                }
            }

            tableelement(GLEntry; "G/L Entry")
            {
                RequestFilterFields = "Reason Code", "Posting Date", lvngEntryDate;
                SourceTableView = sorting("Entry No.");

                fieldelement(EntryNo; GLEntry."Entry No.") { }
                fieldelement(PostingDate; GLEntry."Posting Date") { }
                fieldelement(EntryDate; GLEntry.lvngEntryDate) { }
                fieldelement(DocumentType; GLEntry."Document Type") { }
                fieldelement(DocumentNo; GLEntry."Document No.") { }
                fieldelement(GLAccountNo; GLEntry."G/L Account No.") { }
                textelement(GLAccountName)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GLAccountName := GLAccount.Name;
                    end;
                }
                fieldelement(Description; GLEntry.Description) { }
                fieldelement(Amount; GLEntry.Amount) { }
                fieldelement(ReasonCode; GLEntry."Reason Code") { }
                fieldelement(BalAccountType; GLEntry."Bal. Account Type") { }
                fieldelement(BalAccountNo; GLEntry."Bal. Account No.") { }
                fieldelement(LoanNo; GLEntry.lvngLoanNo) { }
                fieldelement(SourceType; GLEntry."Source Type") { }
                fieldelement(SourceNo; GLEntry."Source No.") { }
                fieldelement(SourceName; GLEntry.lvngSourceName) { }
                fieldelement(Reversed; GLEntry.Reversed) { }
                fieldelement(UserId; GLEntry."User ID") { }
                fieldelement(Dim1; GLEntry."Global Dimension 1 Code") { }
                fieldelement(Dim2; GLEntry."Global Dimension 2 Code") { }
                fieldelement(Dim3; GLEntry.lvngShortcutDimension3Code) { }
                fieldelement(Dim4; GLEntry.lvngShortcutDimension4Code) { }
                fieldelement(Dim5; GLEntry.lvngShortcutDimension5Code) { }
                fieldelement(Dim6; GLEntry.lvngShortcutDimension6Code) { }
                fieldelement(Dim7; GLEntry.lvngShortcutDimension7Code) { }
                fieldelement(Dim8; GLEntry.lvngShortcutDimension8Code) { }

                trigger OnAfterGetRecord()
                begin
                    GLAccount.Get(GLEntry."G/L Account No.");
                end;
            }
        }
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";

    trigger OnPreXmlPort()
    begin
        GeneralLedgerSetup.Get();
    end;
}
