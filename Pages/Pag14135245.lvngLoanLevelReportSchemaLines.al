page 14135245 lvngLoanLevelReportSchemaLines
{
    PageType = List;
    SourceTable = lvngLoanLevelReportSchemaLine;
    Caption = 'Loan Funding Schema Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Column No."; "Column No.") { ApplicationArea = All; }
                field(Description; Description) { ApplicationArea = All; }
                field(Type; Type) { ApplicationArea = All; }
                field("G/L Filter"; "G/L Filter".HasValue) { ApplicationArea = All; Caption = 'G/L Filters Applied'; }
                field("Value Field No."; "Value Field No.") { ApplicationArea = All; }
                field("Formula Code"; "Formula Code")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        ExpressionList: Page lvngExpressionList;
                        LoanLevelMgmt: Codeunit lvngLoanLevelReportManagement;
                        ExpressiontType: Enum lvngExpressionType;
                        NewCode: Code[20];
                    begin
                        NewCode := ExpressionList.SelectExpression(LoanLevelMgmt.GetLoanLevelFormulaConsumerId(), "Report Code", "Formula Code", ExpressiontType::Formula);
                        if NewCode <> '' then
                            "Formula Code" := NewCode;
                    end;
                }
                field("Number Format Code"; "Number Format Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditGLFilter)
            {
                ApplicationArea = All;
                Caption = 'Edit G/L Filter';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    FPBuilder: FilterPageBuilder;
                    IStream: InStream;
                    OStream: OutStream;
                    ViewText: Text;
                begin
                    FPBuilder.AddRecord(GLEntryTxt, GLEntry);
                    FPBuilder.AddFieldNo(GLEntryTxt, 3);        // G/L Account No.
                    FPBuilder.AddFieldNo(GLEntryTxt, 4);        // Posting Date
                    FPBuilder.AddFieldNo(GLEntryTxt, 5);        // Document Type
                    FPBuilder.AddFieldNo(GLEntryTxt, 23);       // Global Dimension 1 Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 24);       // Global Dimension 2 Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 14135101); // Shortcut Dimension 3 Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 14135102); // Shortcut Dimension 4 Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 45);       // Business Unit Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 47);       // Reason Code
                    FPBuilder.AddFieldNo(GLEntryTxt, 53);       // Debit Amount
                    FPBuilder.AddFieldNo(GLEntryTxt, 54);       // Credit Amount
                    FPBuilder.AddFieldNo(GLEntryTxt, 58);       // Source No.
                    FPBuilder.AddFieldNo(GLEntryTxt, 14135107); // Entry Date
                    FPBuilder.AddFieldNo(GLEntryTxt, 14135108); // Servicing Type
                    CalcFields("G/L Filter");
                    if "G/L Filter".HasValue then begin
                        "G/L Filter".CreateInStream(IStream);
                        IStream.ReadText(ViewText);
                        FPBuilder.SetView(GLEntryTxt, ViewText);
                    end;
                    if FPBuilder.RunModal() then begin
                        Clear("G/L Filter");
                        "G/L Filter".CreateOutStream(OStream);
                        ViewText := FPBuilder.GetView(GLEntryTxt, false);
                        GLEntry.Reset();
                        GLEntry.SetView(ViewText);
                        if GLEntry.GetFilters() <> '' then
                            OStream.WriteText(ViewText);
                        Modify();
                    end;
                end;
            }
        }
    }

    var
        GLEntryTxt: Label 'G/L Entry';
}