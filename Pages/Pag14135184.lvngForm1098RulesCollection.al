page 14135184 lvngForm1098RulesCollection
{
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
            action(EditFilter)
            {
                ApplicationArea = All;
                Caption = 'Edit G/L Filter';
                Image = Filter;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    MakeFilter();
                    CurrPage.Update(true);
                end;
            }
        }
    }

    var
        GLEntryLbl: Label 'G/L Entry';

    local procedure MakeFilter()
    var
        GLEntry: Record "G/L Entry";
        FPBuilder: FilterPageBuilder;
        IStream: InStream;
        OStream: OutStream;
        ViewText: Text;
    begin
        CalcFields("G/L Filter");
        FPBuilder.AddRecord(GLEntryLbl, GLEntry);
        FPBuilder.AddFieldNo(GLEntryLbl, 3);
        FPBuilder.AddFieldNo(GLEntryLbl, 4);
        FPBuilder.AddFieldNo(GLEntryLbl, 5);
        FPBuilder.AddFieldNo(GLEntryLbl, 23);
        FPBuilder.AddFieldNo(GLEntryLbl, 24);
        FPBuilder.AddFieldNo(GLEntryLbl, 47);
        FPBuilder.AddFieldNo(GLEntryLbl, 53);
        FPBuilder.AddFieldNo(GLEntryLbl, 54);
        FPBuilder.AddFieldNo(GLEntryLbl, 58);
        FPBuilder.AddFieldNo(GLEntryLbl, 14135103);
        FPBuilder.AddFieldNo(GLEntryLbl, 14135105);
        FPBuilder.AddFieldNo(GLEntryLbl, 14135106);
        if "G/L Filter".HasValue() then begin
            "G/L Filter".CreateInStream(IStream);
            IStream.ReadText(ViewText);
            FPBuilder.SetView(GLEntryLbl, ViewText);
        end;
        if FPBuilder.RunModal() then begin
            Clear("G/L Filter");
            "G/L Filter".CreateOutStream(OStream);
            OStream.WriteText(FPBuilder.GetView(GLEntryLbl, false));
            Modify();
        end;
    end;
}