page 14135224 lvngPeriodPerfBandSchemaLines
{
    PageType = List;
    SourceTable = lvngPeriodPerfBandSchemaLine;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.") { ApplicationArea = All; Caption = 'Band No.'; }
                field("Period Type"; "Period Type") { ApplicationArea = All; }
                field("Period Offset"; "Period Offset") { ApplicationArea = All; }
                field("Period Length Formula"; "Period Length Formula") { ApplicationArea = All; }
                field("Header Description"; "Header Description") { ApplicationArea = All; }
                field("Dynamic Date Description"; "Dynamic Date Description") { ApplicationArea = All; }
                field("Date From"; "Date From") { ApplicationArea = All; }
                field("Date To"; "Date To") { ApplicationArea = All; }
            }
        }
    }
}