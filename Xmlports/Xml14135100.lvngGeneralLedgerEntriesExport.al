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
                        EntryNoCapt := GLEntry.FieldCaption("Entry No.");
                    end;
                }
                textelement(PostingDateCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PostingDateCapt := GLEntry.FieldCaption("Posting Date");
                    end;
                }
                textelement(EntryDateCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EntryDateCapt := GLEntry.FieldCaption(lvngEntryDate);
                    end;
                }
                textelement(DocumentTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DocumentTypeCapt := GLEntry.FieldCaption("Document Type");
                    end;
                }
                textelement(DocumentNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DocumentNoCapt := GLEntry.FieldCaption("Document No.");
                    end;
                }
                textelement(GLAccountNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GLAccountNoCapt := GLEntry.FieldCaption("G/L Account No.");
                    end;
                }
                textelement(GLAccountNameCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GLAccountNameCapt := GLEntry.FieldCaption("G/L Account Name");
                    end;
                }
                textelement(DescriptionCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DescriptionCapt := GLEntry.FieldCaption(Description);
                    end;
                }
                textelement(AmountCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AmountCapt := GLEntry.FieldCaption(Amount);
                    end;
                }
                textelement(ReasonCodeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReasonCodeCapt := GLEntry.FieldCaption("Reason Code");
                    end;
                }
                textelement(BalAccountTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BalAccountTypeCapt := GLEntry.FieldCaption("Bal. Account Type");
                    end;
                }
                textelement(BalAccountNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BalAccountNoCapt := GLEntry.FieldCaption("Bal. Account No.");
                    end;
                }
                textelement(LoanNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LoanNoCapt := GLEntry.FieldCaption(lvngLoanNo);
                    end;
                }
                textelement(SourceTypeCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceTypeCapt := GLEntry.FieldCaption("Source Type");
                    end;
                }
                textelement(SourceNoCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceNoCapt := GLEntry.FieldCaption("Source No.");
                    end;
                }
                textelement(SourceNameCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SourceNameCapt := GLEntry.FieldCaption(lvngSourceName);
                    end;
                }
                textelement(ReversedCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ReversedCapt := GLEntry.FieldCaption(Reversed);
                    end;
                }
                textelement(UserIdCapt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UserIdCapt := GLEntry.FieldCaption("User ID");
                    end;
                }
                textelement(Dim1Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim1Capt := DimensionNames[1];
                    end;
                }
                textelement(Dim2Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim2Capt := DimensionNames[2];
                    end;
                }
                textelement(Dim3Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim3Capt := DimensionNames[3];
                    end;
                }
                textelement(Dim4Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim4Capt := DimensionNames[4];
                    end;
                }
                textelement(Dim5Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim5Capt := DimensionNames[5];
                    end;
                }
                textelement(Dim6Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim6Capt := DimensionNames[6];
                    end;
                }
                textelement(Dim7Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim7Capt := DimensionNames[7];
                    end;
                }
                textelement(Dim8Capt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Dim8Capt := DimensionNames[8];
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
                fieldelement(GLAccountName;GLEntry."G/L Account Name") { }
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
            }
        }
    }

    var
        DimensionNames: array[8] of Text;

    trigger OnPreXmlPort()
    var
        DimensionMgmt: Codeunit lvngDimensionsManagement;
    begin
        DimensionMgmt.GetDimensionNames(DimensionNames);
    end;
}
