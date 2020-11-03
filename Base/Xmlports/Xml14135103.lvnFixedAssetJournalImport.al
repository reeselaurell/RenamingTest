xmlport 14135103 "lvnFixedAssetJournalImport"
{
    Caption = 'Fixed Asset Journal Import';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = '<TAB>';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(FAJournalLine; "FA Journal Line")
            {
                SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");

                fieldelement(FAPostingDate; FAJournalLine."FA Posting Date") { }
                fieldelement(DocumentType; FAJournalLine."Document Type") { }
                fieldelement(DocumentNo; FAJournalLine."Document No.") { }
                fieldelement(FANo; FAJournalLine."FA No.") { }
                fieldelement(DepBookCode; FAJournalLine."Depreciation Book Code") { }
                fieldelement(FAPostingType; FAJournalLine."FA Posting Type") { }
                fieldelement(Description; FAJournalLine.Description) { }
                fieldelement(Amount; FAJournalLine.Amount) { }
                fieldelement(NoOfDepDays; FAJournalLine."No. of Depreciation Days") { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin
                    FAJournalLine."Journal Template Name" := JournalTemplateName;
                    FAJournalLine."Journal Batch Name" := JournalBatchName;
                    FAJournalLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;
                end;
            }
        }
    }

    var
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        LineNo: Integer;

    procedure SetParams(pJournalTemplateName: Code[20]; pJournalBatchName: Code[20])
    var
        FAJnlLine: Record "FA Journal Line";
    begin
        FAJnlLine.Reset();
        FAJnlLine.SetRange("Journal Batch Name", pJournalTemplateName);
        FAJnlLine.SetRange("Journal Batch Name", pJournalBatchName);
        if FAJnlLine.FindLast() then
            LineNo := FAJnlLine."Line No." + 10000
        else
            LineNo := 10000;
        JournalBatchName := pJournalBatchName;
        JournalTemplateName := pJournalTemplateName;
    end;
}