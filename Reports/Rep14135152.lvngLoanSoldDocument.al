report 14135152 "lvngLoanSoldDocument"
{
    Caption = 'Loan Sold Document';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Rep14135152.rdl';

    dataset
    {
        dataitem(lvngLoanSoldDocument; lvngLoanSoldDocument)
        {
            RequestFilterFields = lvngDocumentNo;

            column(DocumentType; DocumentType)
            {

            }
            column(lvngDocumentNo; lvngDocumentNo)
            {

            }
            column(lvngCustomerNo; lvngCustomerNo)
            {

            }
            column(lvngLoanNo; lvngLoanNo)
            {

            }
            column(BorrowerName; BorrowerName)
            {

            }
            column(lvngPostingDate; lvngPostingDate)
            {

            }
            column(lvngVoid; lvngVoid)
            {

            }
            column(PropertyAddress; PropertyAddress)
            {

            }
            column(lvngVoidDocumentNo; lvngVoidDocumentNo)
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

            dataitem(lvngLoanSoldDocumentLine; lvngLoanSoldDocumentLine)
            {
                DataItemTableView = sorting(lvngDocumentNo, lvngLineNo);
                DataItemLinkReference = lvngLoanSoldDocument;
                DataItemLink = lvngDocumentNo = field(lvngDocumentNo);
                column(lvngAccountNo; lvngAccountNo)
                {

                }
                column(lvngDescription; lvngDescription)
                {

                }
                column(lvngAmount; lvngAmount)
                {

                }
                column(lvngBalancingEntry; lvngBalancingEntry)
                {

                }
                column(lvngLineNo; lvngLineNo)
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
                    lvngDimensionsManagement.FillDimensionsFromTable(lvngLoanSoldDocumentLine, DimensionValues);
                    DocumentLineCostCenter := GetDimensionValueName(lvngLoanVisionSetup."Cost Center Dimension Code");
                    ServicingType := Format(lvngServicingType);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(CostCenter);
                Clear(LoanOfficer);
                Clear(LoanType);
                Clear(State);
                Clear(DimensionValues);
                lvngLoan.Get(lvngLoanSoldDocument.lvngLoanNo);
                PropertyAddress := lvngLoan.GetLoanAddress(lvngLoanAddressTypeEnum::lvngProperty);
                BorrowerName := StrSubstNo(lvngLoanVisionSetup."Search Name Template", lvngLoan."Borrower First Name", lvngloan."Borrower Last Name", lvngLoan."Borrower Middle Name");
                lvngDimensionsManagement.FillDimensionsFromTable(lvngLoan, DimensionValues);
                CostCenter := GetDimensionValueName(lvngLoanVisionSetup."Cost Center Dimension Code");
                LoanType := GetDimensionValueName(lvngLoanVisionSetup."Loan Type Dimension Code");
                State := GetDimensionValueName(lvngLoanVisionSetup."Property State Dimension Code");
                LoanOfficer := GetDimensionValueName(lvngLoanVisionSetup."Loan Officer Dimension Code");
                DocumentType := Format(lvngDocumentType);


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