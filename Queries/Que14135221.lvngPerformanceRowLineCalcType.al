query 14135221 lvngPerformanceRowLiteralLine
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
                DataItemLink = Code = RowLine."Schema Code";
                DataItemTableFilter = Type = filter(<> lvngExpression);

                column(CalcUnitCode; Code) { }
            }
        }
    }
}