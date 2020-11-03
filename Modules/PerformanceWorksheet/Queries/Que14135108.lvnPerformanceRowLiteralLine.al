query 14135108 "lvnPerformanceRowLiteralLine"
{
    QueryType = Normal;

    elements
    {
        dataitem(RowLine; lvnPerformanceRowSchemaLine)
        {
            filter(SchemaCode; "Schema Code") { }
            filter(ColumnNo; "Column No.") { }
            column(LineNo; "Line No.") { }
            dataitem(CalculationUnit; lvnCalculationUnit)
            {
                DataItemLink = Code = RowLine."Calculation Unit Code";
                DataItemTableFilter = Type = filter(<> Expression);

                column(CalcUnitCode; Code) { }
            }
        }
    }
}