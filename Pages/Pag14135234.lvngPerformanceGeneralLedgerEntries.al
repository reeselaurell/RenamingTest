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
                field(lvngLoanNo; "Loan No.") { ApplicationArea = All; Caption = 'Loan No.'; DrillDown = false; Lookup = false; AssistEdit = false; }
                field(Description; Description) { ApplicationArea = All; }
                field(Amount; Amount) { ApplicationArea = All; }
                field("Reason Code"; "Reason Code") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field("Business Unit Code"; "Business Unit Code") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngGlobalDimension1Name; "Global Dimension 1 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngGlobalDimension2Name; "Global Dimension 2 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension3Name; "Shortcut Dimension 3 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension4Name; "Shortcut Dimension 4 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension5Name; "Shortcut Dimension 5 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension6Name; "Shortcut Dimension 6 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension7Name; "Shortcut Dimension 7 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngShortcutDimension8Name; "Shortcut Dimension 8 Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(lvngBorrowerSearchName; "Borrower Search Name") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; Caption = 'Borrower Name'; }
                field("Source Type"; "Source Type") { ApplicationArea = All; }
                field(lvngSourceName; "Source Name") { ApplicationArea = All; Caption = 'Source Name'; }
                field(lvngWarehouseLineCode; "Warehouse Line Code") { ApplicationArea = All; Lookup = false; DrillDown = false; AssistEdit = false; }
                field(InvestorCustomerNumber; Loan."Investor Customer No.") { ApplicationArea = All; Caption = 'Investor Customer No.'; Lookup = false; DrillDown = false; AssistEdit = false; }

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
        if not Loan.Get("Loan No.") then
            Clear(Loan)
        else
            if Loan."Investor Customer No." <> '' then
                if Customer.Get(Loan."Investor Customer No.") then
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