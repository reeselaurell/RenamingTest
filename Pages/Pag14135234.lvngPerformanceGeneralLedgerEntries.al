page 14135234 lvngPerformanceGLEntries
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
                field(InvestorCustomerNumber; Loan.lvngInvestorCustomerNo) { ApplicationArea = All; Caption = 'Investor Customer No.'; Lookup = false; DrillDown = false; AssistEdit = false; }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowDocument)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Error('Not Implemented');
                end;
            }
        }
    }

    var
        GLAcc: Record "G/L Account";
        Loan: Record lvngLoan;
        DimensionManagement: Codeunit DimensionManagement;
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
    begin
        DimensionManagement.UseShortcutDims(DimensionVisible1, DimensionVisible2, DimensionVisible3, DimensionVisible4, DimensionVisible5, DimensionVisible6,
        DimensionVisible7, DimensionVisible8);
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        InvestorName := '';
        if not Loan.Get(lvngLoanNo) then
            Clear(Loan)
        else
            if Loan.lvngInvestorCustomerNo <> '' then
                if Customer.Get(Loan.lvngInvestorCustomerNo) then
                    InvestorName := Customer.Name;
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