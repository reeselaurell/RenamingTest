report 14135174 lvngLegalExpenses
{
    Caption = 'Legal Expenses';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135174.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Posting Date", "Entry Date", "Source Type", "Source No.";

            column(EntryNo; "Entry No.") { }
            column(PostingDate; "Posting Date") { }
            column(DocumentType; "Document Type") { }
            column(ExtDocNo; "External Document No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(GLAccountName; "G/L Account Name") { }
            column(SourceName; "Source Name") { }
            column(DateFilter; DateFilter) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(BranchCode; BranchCode) { }

            trigger OnAfterGetRecord()
            begin
                case CostCenterDimNo of
                    1:
                        BranchCode := "Global Dimension 1 Code";
                    2:
                        BranchCode := "Global Dimension 2 Code";
                    3:
                        BranchCode := "Shortcut Dimension 3 Code";
                    4:
                        BranchCode := "Shortcut Dimension 4 Code";
                    5:
                        BranchCode := "Shortcut Dimension 5 Code";
                    6:
                        BranchCode := "Shortcut Dimension 6 Code";
                    7:
                        BranchCode := "Shortcut Dimension 7 Code";
                    8:
                        BranchCode := "Shortcut Dimension 8 Code";
                    else
                        BranchCode := '';
                end;
            end;
        }
    }

    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        GLSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
        BranchCode: Code[20];
        CostCenterDimNo: Integer;

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        GLSetup.Get();
        LoanVisionSetup.Get();
        DateFilter := "G/L Entry".GetFilter("Posting Date");
        case LoanVisionSetup."Cost Center Dimension Code" of
            GLSetup."Shortcut Dimension 1 Code":
                CostCenterDimNo := 1;
            GLSetup."Shortcut Dimension 2 Code":
                CostCenterDimNo := 2;
            GLSetup."Shortcut Dimension 3 Code":
                CostCenterDimNo := 3;
            GLSetup."Shortcut Dimension 4 Code":
                CostCenterDimNo := 4;
            GLSetup."Shortcut Dimension 5 Code":
                CostCenterDimNo := 5;
            GLSetup."Shortcut Dimension 6 Code":
                CostCenterDimNo := 6;
            GLSetup."Shortcut Dimension 7 Code":
                CostCenterDimNo := 7;
            GLSetup."Shortcut Dimension 8 Code":
                CostCenterDimNo := 8;
            else
                CostCenterDimNo := 0;
        end;
    end;
}