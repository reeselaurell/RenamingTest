page 14135213 "lvnPerformanceGLEntries"
{
    PageType = List;
    SourceTable = "G/L Entry";
    Caption = 'General Ledger Entries';
    Editable = false;
    DataCaptionExpression = GetCaption();
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    DrillDown = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field(lvnLoanNo; Rec.lvnLoanNo)
                {
                    ApplicationArea = All;
                    Caption = 'Loan No.';
                    DrillDown = false;
                    Lookup = false;
                    AssistEdit = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnGlobalDimension1Name; Rec.lvnGlobalDimension1Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnGlobalDimension2Name; Rec.lvnGlobalDimension2Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension3Name; Rec.lvnShortcutDimension3Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension4Name; Rec.lvnShortcutDimension4Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension5Name; Rec.lvnShortcutDimension5Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension6Name; Rec.lvnShortcutDimension6Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension7Name; Rec.lvnShortcutDimension7Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnShortcutDimension8Name; Rec.lvnShortcutDimension8Name)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(lvnBorrowerSearchName; Rec.lvnBorrowerSearchName)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                    Caption = 'Borrower Name';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field(lvnSourceName; Rec.lvnSourceName)
                {
                    ApplicationArea = All;
                    Caption = 'Source Name';
                }
                field(lvnWarehouseLineCode; Rec.lvnWarehouseLineCode)
                {
                    ApplicationArea = All;
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
                field(InvestorCustomerNumber; Loan."Investor Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Investor Customer No.';
                    Lookup = false;
                    DrillDown = false;
                    AssistEdit = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(DocumentExchange; lvnDocumentListFactbox)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        LoanVisionSetup: Record lvnLoanVisionSetup;
        DimMgmt: Codeunit lvnDimensionsManagement;
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
        if not Loan.Get(Rec.lvnLoanNo) then
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
                GLEntry.SetRange("Transaction No.", Rec."Transaction No.");
                if GLEntry.FindSet() then
                    repeat
                        if GetCostCenter(GLEntry) <> OriginalCostCenter then begin
                            CurrPage.DocumentExchange.Page.ReloadDocuments(CreateGuid());
                            exit;
                        end;
                    until GLEntry.Next() = 0;
            end;
        end;
        CurrPage.DocumentExchange.Page.ReloadDocuments(Rec.lvnDocumentGuid);
    end;

    var
        GLAcc: Record "G/L Account";
        Loan: Record lvnLoan;
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
        PageCaptionFormatTxt: Label '%1 %2', Comment = '%1 - G/L Account No.; %2 - G/L Account Name';

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
                exit(GLEntry.lvnShortcutDimension3Code);
            4:
                exit(GLEntry.lvnShortcutDimension4Code);
            5:
                exit(GLEntry.lvnShortcutDimension5Code);
            6:
                exit(GLEntry.lvnShortcutDimension6Code);
            7:
                exit(GLEntry.lvnShortcutDimension7Code);
            8:
                exit(GLEntry.lvnShortcutDimension8Code);
            else
                exit('');
        end;
    end;

    local procedure GetCaption(): Text
    begin
        if GLAcc."No." <> Rec."G/L Account No." then
            if not GLAcc.Get(Rec."G/L Account No.") then
                if Rec.GetFilter("G/L Account No.") <> '' then
                    if GLAcc.Get(Rec.GetRangeMin("G/L Account No.")) then;
        exit(StrSubstNo(PageCaptionFormatTxt, GLAcc."No.", GLAcc.Name));
    end;
}