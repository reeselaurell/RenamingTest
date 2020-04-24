query 14135108 lvngPerformanceRowLiteralLine
{
    QueryType = Normal;

    elements
    {
        dataitem(RowLine; lvngPerformanceRowSchemaLine)
        {
            filter(SchemaCode; "Schema Code") { }
            filter(ColumnNo; "Column No.") { }
            column(LineNo; "Line No.") { }
            dataitem(CalculationUnit; lvngCalculationUnit)
            {
                DataItemLink = Code = RowLine."Calculation Unit Code";
                DataItemTableFilter = Type = filter(<> Expression);

                column(CalcUnitCode; Code) { }
            }
        }
    }
}