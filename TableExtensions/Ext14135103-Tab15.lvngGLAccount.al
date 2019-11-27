tableextension 14135103 lvngGLAccount extends "G/L Account"
{
    fields
    {
        field(14135100; "Reporting Account Name"; Text[50]) { Caption = 'Reporting Account Name'; DataClassification = CustomerContent; }
        field(14135102; "Loan No. Mandatory"; Boolean) { Caption = 'Loan No. Mandatory'; DataClassification = CustomerContent; }
        field(14135103; "Linked Bank Account No."; Code[20]) { Caption = 'Linked Bank Account No.'; DataClassification = CustomerContent; TableRelation = "Bank Account"."No."; }
        field(14135104; "Reconciliation Field No."; Integer) { Caption = 'Reconciliation Field No.'; DataClassification = CustomerContent; TableRelation = lvngLoanFieldsConfiguration."Field No." where("Value Type" = const(Decimal)); }
        field(14135105; "Report Grouping"; Option) { Caption = 'Report Grouping'; DataClassification = CustomerContent; OptionMembers = " ",Loan; }
        field(14135106; "Shortcut Dimension 3 Filter"; Code[20]) { Caption = 'Shortcut Dimension 3 Filter'; CaptionClass = '1,4,3'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3)); }
        field(14135107; "Shortcut Dimension 4 Filter"; Code[20]) { Caption = 'Shortcut Dimension 4 Filter'; CaptionClass = '1,4,4'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4)); }
        field(14135108; "Shortcut Dimension 5 Filter"; Code[20]) { Caption = 'Shortcut Dimension 5 Filter'; CaptionClass = '1,4,5'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5)); }
        field(14135109; "Shortcut Dimension 6 Filter"; Code[20]) { Caption = 'Shortcut Dimension 6 Filter'; CaptionClass = '1,4,6'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6)); }
        field(14135110; "Shortcut Dimension 7 Filter"; Code[20]) { Caption = 'Shortcut Dimension 7 Filter'; CaptionClass = '1,4,7'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7)); }
        field(14135111; "Shortcut Dimension 8 Filter"; Code[20]) { Caption = 'Shortcut Dimension 8 Filter'; CaptionClass = '1,4,8'; FieldClass = FlowFilter; TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8)); }
        field(14135112; "Revenue G/L Account No."; Code[20]) { Caption = 'Revenue G/L Account'; DataClassification = CustomerContent; TableRelation = "G/L Account"."No." where("Account Type" = const(Posting)); }
    }
}