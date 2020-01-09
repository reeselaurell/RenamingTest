page 14135184 lvngForm1098RulesCollection
{
    Description = '1098';
    PageType = List;
    SourceTable = lvngForm1098ColRuleDetails;
    Caption = 'Form 1098 Rules Collection';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; Caption = 'Line No.'; }
                field(Description; Description) { ApplicationArea = All; Caption = 'Description'; }
                field(Type; Type) { ApplicationArea = All; Caption = 'Type'; }
                field("Condition Code"; "Condition Code") { ApplicationArea = All; Caption = 'Condition Code'; }
                field("Formula Code"; "Formula Code") { ApplicationArea = All; Caption = 'Formula Code'; Editable = Type = Type::"Loan Card"; }
                field("G/L Filter"; "G/L Filter".HasValue()) { ApplicationArea = All; Caption = 'G/L Entry Filters'; }
                field("Document Paid"; "Document Paid") { ApplicationArea = All; Caption = 'Document Paid'; }
                field("Paid Before Current Year"; "Paid Before Current Year") { ApplicationArea = All; Caption = 'Paid Before Current Year'; }
                field("Reverse Amount"; "Reverse Amount") { ApplicationArea = All; Caption = 'Reverse Amount'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}