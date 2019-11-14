page 14135406 lvngBranchMetricPart
{
    PageType = ListPart;
    SourceTable = lvngBranchMetric;
    Caption = '';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.") { ApplicationArea = All; Editable = false; }
                field(Description; Description) { ApplicationArea = All; }
                field("Calculation Unit Code"; "Calculation Unit Code") { ApplicationArea = All; }
                field("Number Format Code"; "Number Format Code") { ApplicationArea = All; }
            }
        }
    }

    var
        OnlyLastMetricDeletableErr: Label 'Only the last metric can be deleted!';
        MaxCountReachedErr: Label 'Maximum possible count of metrics is %1 here';
        DashboardCaptionTxt: Label 'Dashboard Metrics';
        TileCaptionTxt: Label 'Tile Metrics';

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        BranchMetric: Record lvngBranchMetric;
    begin
        BranchMetric.Reset();
        BranchMetric.SetRange(Type, Type);
        if BranchMetric.FindLast() then
            "No." := BranchMetric."No." + 1
        else
            "No." := 1;
        case Type of
            Type::lvngDashboard:
                if "No." >= 6 then
                    Error(MaxCountReachedErr, 5);
            Type::lvngTile:
                if "No." >= 4 then
                    Error(MaxCountReachedErr, 3);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        BranchMetric: Record lvngBranchMetric;
    begin
        BranchMetric.Reset();
        BranchMetric.SetRange(Type, Type);
        if BranchMetric.FindLast() then
            if BranchMetric."No." > "No." then
                Error(OnlyLastMetricDeletableErr);
    end;
}