xmlport 14135105 "lvnDimensionChangeSetImport"
{
    Caption = 'Dimension Change Set Import';
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(DimensionJournalEntry; lvnDimensionChangeJnlEntry)
            {
                fieldelement(EntryNo; DimensionJournalEntry."Entry No.")
                {
                }
                fieldelement(Dimension1; DimensionJournalEntry."New Dimension 1 Code")
                {
                }
                fieldelement(Dimension2; DimensionJournalEntry."New Dimension 2 Code")
                {
                }
                fieldelement(Dimension3; DimensionJournalEntry."New Dimension 3 Code")
                {
                }
                fieldelement(Dimension4; DimensionJournalEntry."New Dimension 4 Code")
                {
                }
                fieldelement(Dimension5; DimensionJournalEntry."New Dimension 5 Code")
                {
                }
                fieldelement(Dimension6; DimensionJournalEntry."New Dimension 6 Code")
                {
                }
                fieldelement(Dimension7; DimensionJournalEntry."New Dimension 7 Code")
                {
                }
                fieldelement(Dimension8; DimensionJournalEntry."New Dimension 8 Code")
                {
                }
                fieldelement(BusinessUnit; DimensionJournalEntry."New Business Unit Code")
                {
                }
                fieldelement(LoanNo; DimensionJournalEntry."New Loan No.")
                {
                }
                trigger OnBeforeInsertRecord()
                begin
                    DimensionJournalEntry."Change Set ID" := ChangeSetId;
                    DimensionJournalEntry.TransferValuesImport();
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(OverwriteField; Overwrite) { Caption = 'Overwrite Existing Entries'; ApplicationArea = All; }
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        if Overwrite then begin
            DimensionJournalEntry.SetRange("Change Set ID", ChangeSetId);
            DimensionJournalEntry.DeleteAll();
        end;
    end;

    var
        Overwrite: Boolean;
        ChangeSetId: Guid;

    procedure SetParams(pChangeSetID: Guid)
    begin
        ChangeSetId := pChangeSetID;
    end;
}