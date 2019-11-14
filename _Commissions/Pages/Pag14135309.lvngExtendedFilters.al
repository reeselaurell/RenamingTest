page 14135309 "lvngExtendedFilters"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = lvngCommissionExtendedFilter;

    layout
    {
        area(Content)
        {
            repeater(lvngRepeater)
            {
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
                field(lvngFilterExists; lvngFilter.HasValue)
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
            action(lvngEdit)
            {
                Caption = 'Edit Filter';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    MakeFilter();
                end;
            }
        }
    }

    local procedure MakeFilter()
    var
        lvngLoan: Record lvngLoan;
        lvngLoanFilterBuilder: FilterPageBuilder;
        lvngFilterText: Text;
        lvngInStream: InStream;
        lvngOutStream: OutStream;
        lvngFilterLabel: Label 'Loan Filters';
    begin
        CalcFields(lvngFilter);
        lvngLoanFilterBuilder.AddRecord(lvngFilterLabel, lvngLoan);
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Global Dimension 1 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Global Dimension 2 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 3 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 4 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 5 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 6 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 7 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Shortcut Dimension 8 Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Business Unit Code"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Commission Date"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Date Funded"));
        lvngLoanFilterBuilder.AddFieldNo(lvngFilterLabel, lvngLoan.FieldNo("Warehouse Line Code"));

        if lvngFilter.HasValue() then begin
            lvngFilter.CreateInStream(lvngInStream);
            lvngInStream.ReadText(lvngFilterText);
            lvngLoanFilterBuilder.SetView(lvngFilterLabel, lvngFilterText);
        end;
        if lvngLoanFilterBuilder.RunModal() then begin
            Clear(lvngFilter);
            lvngFilter.CreateOutStream(lvngOutStream);
            lvngFilterText := lvngLoanFilterBuilder.GetView(lvngFilterLabel, false);
            Clear(lvngLoan);
            lvngLoan.SETVIEW(lvngFilterText);
            if lvngLoan.GetFilters() <> '' then begin
                lvngOutStream.WRITE(lvngFilterText);
            end;
            Modify();
        end;
    end;
}