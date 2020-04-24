table 14135146 lvngLoanReportingBuffer
{
    Caption = 'Loan Reporting Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan No."; Code[20]) { Caption = 'Loan No.'; DataClassification = CustomerContent; NotBlank = true; }
        field(10; "Search Name"; Code[100]) { Caption = 'Search Name'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Search Name" where("No." = field("Loan No."))); Editable = false; }
        field(14; "Title Customer No."; Code[20]) { Caption = 'Title Customer No.'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Title Customer No." where("No." = field("Loan No."))); Editable = false; }
        field(15; "Investor Customer No."; Code[20]) { Caption = 'Investor Customer No.'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Investor Customer No." where("No." = field("Loan No."))); Editable = false; }
        field(17; "Alternative Loan No."; Code[50]) { Caption = 'Alternative Loan No.'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Alternative Loan No." where("No." = field("Loan No."))); Editable = false; }
        field(20; "Application Date"; Date) { Caption = 'Application Date'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Application Date" where("No." = field("Loan No."))); Editable = false; }
        field(21; "Date Closed"; Date) { Caption = 'Date Closed'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Date Closed" where("No." = field("Loan No."))); Editable = false; }
        field(22; "Date Funded"; Date) { Caption = 'Date Funded'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Date Funded" where("No." = field("Loan No."))); Editable = false; }
        field(23; "Date Sold"; Date) { Caption = 'Date Sold'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Date Sold" where("No." = field("Loan No."))); Editable = false; }
        field(25; "Loan Amount"; Decimal) { Caption = 'Loan Amount'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Loan Amount" where("No." = field("Loan No."))); Editable = false; }
        field(80; "Global Dimension 1 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Global Dimension 1 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Global Dimension 1 Code'; CaptionClass = '1,1,1'; }
        field(81; "Global Dimension 2 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Global Dimension 2 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Global Dimension 2 Code'; CaptionClass = '1,1,2'; }
        field(82; "Shortcut Dimension 3 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 3 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 3 Code'; CaptionClass = '1,2,3'; }
        field(83; "Shortcut Dimension 4 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 4 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 4 Code'; CaptionClass = '1,2,4'; }
        field(84; "Shortcut Dimension 5 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 5 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 5 Code'; CaptionClass = '1,2,5'; }
        field(85; "Shortcut Dimension 6 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 6 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 6 Code'; CaptionClass = '1,2,6'; }
        field(86; "Shortcut Dimension 7 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 7 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 7 Code'; CaptionClass = '1,2,7'; }
        field(87; "Shortcut Dimension 8 Code"; Code[20]) { FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Shortcut Dimension 8 Code" where("No." = field("Loan No."))); Editable = false; Caption = 'Shortcut Dimension 8 Code'; CaptionClass = '1,2,8'; }
        field(88; "Business Unit Code"; Code[10]) { Caption = 'Business Unit Code'; FieldClass = FlowField; CalcFormula = lookup (lvngLoan."Business Unit Code" where("No." = field("Loan No."))); Editable = false; }
    }

    keys
    {
        key(PK; "Loan No.")
        {
            Clustered = true;
        }
    }
}