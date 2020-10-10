report 14135151 "lvngLoanFundedDocument"
{
    Caption = 'Loan Funded Document';
    DefaultLayout = RDLC;
    RDLCLayout = 'Base\Reports\Layouts\Rep14135151.rdl';

    dataset
    {
        dataitem(lvngLoanFundedDocument; lvngLoanFundedDocument)
        {
            RequestFilterFields = "Document No.";

            column(DocumentType; DocumentType)
            {

            }
            column(lvngDocumentNo; "Document No.")
            {

            }
            column(lvngCustomerNo; "Customer No.")
            {

            }
            column(lvngLoanNo; "Loan No.")
            {

            }
            column(BorrowerName; BorrowerName)
            {

            }
            column(lvngPostingDate; "Posting Date")
            {

            }
            column(lvngVoid; Void)
            {

            }
            column(PropertyAddress; PropertyAddress)
            {

            }
            column(lvngVoidDocumentNo; "Void Document No.")
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

            dataitem(lvngLoanFundedDocumentLine; lvngLoanFundedDocumentLine)
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = lvngLoanFundedDocument;
                DataItemLink = "Document No." = field("Document No.");
                column(lvngAccountNo; "Account No.")
                {

                }
                column(lvngDescription; Description)
                {

                }
                column(lvngAmount; Amount)
                {

                }
                column(lvngBalancingEntry; "Balancing Entry")
                {

                }
                column(lvngLineNo; "Line No.")
                {

                }
                column(lvngServicingType; ServicingType)
                {

                }

                column(DocumentLineCostCenter; DocumentLineCostCenter)
                {

                }

                trigger OnAfterGetRecord()
                begin
                    Clear(DimensionValues);
                    Clear(DocumentLineCostCenter);
                    lvngDimensionsManagement.FillDimensionsFromTable(lvngLoanFundedDocumentLine, DimensionValues);
                    DocumentLineCostCenter := GetDimensionValueName(lvngLoanVisionSetup."Cost Center Dimension Code");
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
                lvngLoan.Get(lvngLoanFundedDocument."Loan No.");
                PropertyAddress := lvngLoan.GetLoanAddress(lvngLoanAddressTypeEnum::Property);
                BorrowerName := lvngLoanManagement.GetBorrowerName(lvngLoan);
                lvngDimensionsManagement.FillDimensionsFromTable(lvngLoan, DimensionValues);
                CostCenter := GetDimensionValueName(lvngLoanVisionSetup."Cost Center Dimension Code");
                LoanType := GetDimensionValueName(lvngLoanVisionSetup."Loan Type Dimension Code");
                State := GetDimensionValueName(lvngLoanVisionSetup."Property State Dimension Code");
                LoanOfficer := GetDimensionValueName(lvngLoanVisionSetup."Loan Officer Dimension Code");
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
        lvngLoanVisionSetup.Get();
        lvngLoanVisionSetup.TestField("Search Name Template");
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
        lvngLoanVisionSetup: Record lvngLoanVisionSetup;
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DimensionValues: array[8] of Code[20];
        lvngDimensionsManagement: Codeunit lvngDimensionsManagement;
        lvngLoanManagement: Codeunit lvngLoanManagement;
        lvngLoan: Record lvngLoan;
        lvngLoanAddressTypeEnum: Enum lvngAddressType;
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