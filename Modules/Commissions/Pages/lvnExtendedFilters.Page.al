page 14135309 "lvnExtendedFilters"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvnCommissionExtendedFilter;
    Caption = 'Extended Filters';

    layout
    {
        area(Content)
        {
            repeater(DataRepeater)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(FilterExists; Rec."Extended Filter".HasValue())
                {
                    Caption = 'Filter Exists';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Edit)
            {
                Caption = 'Edit Filter';
                Image = EditFilter;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MakeFilter();
                end;
            }
        }
    }

    local procedure MakeFilter()
    var
        Loan: Record lvnLoan;
        LoanFilterBuilder: FilterPageBuilder;
        FilterText: Text;
        FilterInStream: InStream;
        FilterOutStream: OutStream;
        LoanFilterLbl: Label 'Loan Filters';
    begin
        Rec.CalcFields("Extended Filter");
        LoanFilterBuilder.AddRecord(LoanFilterLbl, Loan);
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Global Dimension 1 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Global Dimension 2 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 3 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 4 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 5 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 6 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 7 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Shortcut Dimension 8 Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Business Unit Code"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Commission Date"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Date Funded"));
        LoanFilterBuilder.AddFieldNo(LoanFilterLbl, Loan.FieldNo("Warehouse Line Code"));

        if Rec."Extended Filter".HasValue() then begin
            Rec."Extended Filter".CreateInStream(FilterInStream);
            FilterInStream.ReadText(FilterText);
            LoanFilterBuilder.SetView(LoanFilterLbl, FilterText);
        end;
        if LoanFilterBuilder.RunModal() then begin
            Clear(Rec."Extended Filter");
            Rec."Extended Filter".CreateOutStream(FilterOutStream);
            FilterText := LoanFilterBuilder.GetView(LoanFilterLbl, false);
            Clear(Loan);
            Loan.SetView(FilterText);
            if Loan.GetFilters() <> '' then
                FilterOutStream.Write(FilterText);
            Rec.Modify();
        end;
    end;
}