page 14135213 lvngPerformanceGLEntries
{
    PageType = List;
    SourceTable = "G/L Entry";
    Caption = 'General Ledger Entries';
    Editable = false;
    DataCaptionExpression = GetCaption;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;
    LinksAllowed = false;
    PopulateAllFields = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date") { ApplicationArea = All; }
                field("G/L Account No."; "G/L Account No.") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field("G/L Account Name"; "G/L Account Name") { ApplicationArea = All; Visible = false; DrillDown = false; }
                field("Document Type"; "Document Type") { ApplicationArea = All; }
                field("Document No."; "Document No.") { ApplicationArea = All; }
                field("External Document No."; "External Document No.") { ApplicationArea = All; }
                field(lvngLoanNo; lvngLoanNo) { ApplicationArea = All; Caption = 'Loan No.'; DrillDown = false; Lookup = false; AssistEdit = false; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngGlobalDimension1Name; lvngGlobalDimension1Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngGlobalDimension2Name; lvngGlobalDimension2Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension3Name; lvngShortcutDimension3Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension4Name; lvngShortcutDimension4Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension5Name; lvngShortcutDimension5Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension6Name; lvngShortcutDimension6Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension7Name; lvngShortcutDimension7Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension8Name; lvngShortcutDimension8Name) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngBorrowerSearchName; lvngBorrowerSearchName) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; Caption = 'Borrower Name'; }
                field("Source Type"; "Source Type") { ApplicationArea = All; }
                field(lvngSourceName; lvngSourceName) { ApplicationArea = All; Caption = 'Source Name'; }
                field(lvngWarehouseLineCode; lvngWarehouseLineCode) { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(InvestorCustomerNumber; Loan."Investor Customer No.") { ApplicationArea = All; Caption = 'Investor Customer No.'; Lookup = false; DrillDown = false; AssistEdit = false; }

            }
        }
        area(FactBoxes)
        {
            part(DocumentExchange; lvngDocumentListFactbox) { ApplicationArea = All; }
        }
    }

    var
        GLAcc: Record "G/L Account";
        Loan: Record lvngLoan;
        DimensionManagement: Codeunit DimensionManagement;
        CostCenterDimNo: Integer;
        UseCostCenterFiltering: Boolean;
        InvestorName: Text;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvngLoanVisionSetup;
        DimMgmt: Codeunit lvngDimensionsManagement;
    begin
        if UseCostCenterFiltering then begin
            LoanVisionSetup.Get();
            if LoanVisionSetup."Cost Center Dimension Code" <> '' then
                CostCenterDimNo := DimMgmt.GetDimensionNo(LoanVisionSetup."Cost Center Dimension Code");
        end;
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6, DimensionVisible7, DimensionVisible8);
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        InvestorName := '';
        if not Loan.Get(lvngLoanNo) then
            Clear(Loan)
        else
            if Loan."Investor Customer No." <> '' then
                if Customer.Get(Loan."Investor Customer No.") then
                    InvestorName := Customer.Name;
    end;

    trigger OnAfterGetCurrRecord()
    var
        GLEntry: Record "G/L Entry";
        OriginalCostCenter: Code[20];
    begin
        if CostCenterDimNo <> 0 then begin
            OriginalCostCenter := GetCostCenter(Rec);
            if OriginalCostCenter <> '' then begin
                GLEntry.Reset();
                GLEntry.SetCurrentKey("Transaction No.");
                GLEntry.SetRange("Transaction No.", "Transaction No.");
                if GLEntry.FindSet() then begin
                    repeat
                        if GetCostCenter(GLEntry) <> OriginalCostCenter then begin
                            CurrPage.DocumentExchange.Page.ReloadDocuments(CreateGuid());
                            exit;
                        end;
                    until GLEntry.Next() = 0;
                end;
            end;
        end;
        CurrPage.DocumentExchange.Page.ReloadDocuments(lvngDocumentGuid);
    end;

    procedure EnableCostCenterDocumentFiltering()
    begin
        UseCostCenterFiltering := true;
    end;

    local procedure GetCostCenter(var GLEntry: Record "G/L Entry"): Code[20];
    begin
        case CostCenterDimNo of
            1:
                exit(GLEntry."Global Dimension 1 Code");
            2:
                exit(GLEntry."Global Dimension 2 Code");
            3:
                exit(GLEntry.lvngShortcutDimension3Code);
            4:
                exit(GLEntry.lvngShortcutDimension4Code);
            5:
                exit(GLEntry.lvngShortcutDimension5Code);
            6:
                exit(GLEntry.lvngShortcutDimension6Code);
            7:
                exit(GLEntry.lvngShortcutDimension7Code);
            8:
                exit(GLEntry.lvngShortcutDimension8Code);
            else
                exit('');
        end;
    end;

    local procedure GetCaption(): Text
    begin
        if GLAcc."No." <> "G/L Account No." then
            if not GLAcc.Get("G/L Account No.") then
                if GetFilter("G/L Account No.") <> '' then
                    if GLAcc.Get(GetRangeMin("G/L Account No.")) then;
        exit(StrSubstNo('%1 %2', GLAcc."No.", GLAcc.Name));
    end;
}