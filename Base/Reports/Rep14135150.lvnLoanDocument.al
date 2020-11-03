report 14135150 "lvnLoanDocument"
{
    Caption = 'Loan Document';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135150.rdl';

    dataset
    {
        dataitem(lvnLoanDocument; lvnLoanDocument)
        {
            RequestFilterFields = "Transaction Type", "Document No.";

            column(DocumentType; DocumentType)
            {

            }
            column(lvnDocumentNo; "Document No.")
            {

            }
            column(lvnCustomerNo; "Customer No.")
            {

            }
            column(lvnLoanNo; "Loan No.")
            {

            }
            column(BorrowerName; BorrowerName)
            {

            }
            column(lvnPostingDate; "Posting Date")
            {

            }
            column(lvnVoid; Void)
            {

            }
            column(PropertyAddress; PropertyAddress)
            {

            }
            column(lvnVoidDocumentNo; "Void Document No.")
            {
            }
            column(CostCenter; CostCenter)
            {

            }
            column(LoanType; LoanType)
            {

            }
            column(LoanOfficer; LoanOfficer)
            {

            }
            column(State; State)
            {

            }

            dataitem(lvnLoanDocumentLine; lvnLoanDocumentLine)
            {
                DataItemTableView = sorting("Transaction Type", "Document No.", "Line No.");
                DataItemLinkReference = lvnLoanDocument;
                DataItemLink = "Transaction Type" = field("Transaction Type"), "Document No." = field("Document No.");
                column(lvnAccountNo; "Account No.")
                {

                }
                column(lvnDescription; Description)
                {

                }
                column(lvnAmount; Amount)
                {

                }
                column(lvnBalancingEntry; "Balancing Entry")
                {

                }
                column(lvnLineNo; "Line No.")
                {

                }
                column(lvnServicingType; ServicingType)
                {

                }

                column(DocumentLineCostCenter; DocumentLineCostCenter)
                {

                }

                trigger OnAfterGetRecord()
                begin
                    Clear(DimensionValues);
                    Clear(DocumentLineCostCenter);
                    lvnDimensionsManagement.FillDimensionsFromTable(lvnLoanDocumentLine, DimensionValues);
                    DocumentLineCostCenter := GetDimensionValueName(lvnLoanVisionSetup."Cost Center Dimension Code");
                    ServicingType := Format("Servicing Type");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(CostCenter);
                Clear(LoanOfficer);
                Clear(LoanType);
                Clear(State);
                Clear(DimensionValues);
                lvnLoan.Get(lvnLoanDocument."Loan No.");
                PropertyAddress := lvnLoan.GetLoanAddress(lvnLoanAddressTypeEnum::Property);
                BorrowerName := lvnLoanManagement.GetBorrowerName(lvnLoan);
                lvnDimensionsManagement.FillDimensionsFromTable(lvnLoan, DimensionValues);
                CostCenter := GetDimensionValueName(lvnLoanVisionSetup."Cost Center Dimension Code");
                LoanType := GetDimensionValueName(lvnLoanVisionSetup."Loan Type Dimension Code");
                State := GetDimensionValueName(lvnLoanVisionSetup."Property State Dimension Code");
                LoanOfficer := GetDimensionValueName(lvnLoanVisionSetup."Loan Officer Dimension Code");
                DocumentType := Format("Document Type");


            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        GeneralLedgerSetup.Get();
        lvnLoanVisionSetup.Get();
        lvnLoanVisionSetup.TestField("Search Name Template");
    end;

    local procedure GetDimensionValueName(DimensionCode: Code[20]): Text
    begin

        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", DimensionCode);
        DimensionValue.SetRange(Code, GetDimensionValueCode(DimensionCode));
        DimensionValue.SetLoadFields(DimensionValue.Name);
        if DimensionValue.FindFirst() then
            exit(DimensionValue.Name);
        exit('');
    end;

    local procedure GetDimensionValueCode(DimensionCode: Code[20]): Code[20]
    begin
        case DimensionCode of
            GeneralLedgerSetup."Global Dimension 1 Code":
                exit(DimensionValues[1]);
            GeneralLedgerSetup."Global Dimension 2 Code":
                exit(DimensionValues[2]);
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                exit(Dimensionvalues[3]);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                exit(Dimensionvalues[4]);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                exit(Dimensionvalues[5]);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                exit(Dimensionvalues[6]);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                exit(Dimensionvalues[7]);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                exit(Dimensionvalues[8]);
        end;
    end;

    var
        lvnLoanVisionSetup: Record lvnLoanVisionSetup;
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DimensionValues: array[8] of Code[20];
        lvnDimensionsManagement: Codeunit lvnDimensionsManagement;
        lvnLoanManagement: Codeunit lvnLoanManagement;
        lvnLoan: Record lvnLoan;
        lvnLoanAddressTypeEnum: Enum lvnAddressType;
        LoanOfficer: Text;
        LoanType: Text;
        CostCenter: Text;
        DocumentLineCostCenter: Text;
        State: Text;
        BorrowerName: Text;
        ServicingType: Text;
        DocumentType: Text;
        PropertyAddress: Text;
}