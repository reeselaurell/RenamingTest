query 14135301 lvnCommissionJournalOverrides
{
    elements
    {
        dataitem(CommissionJournalLine; lvnCommissionJournalLine)
        {
            DataItemTableFilter = "Profile Line Type" = const("Loan Level");

            filter(ScheduleNo; "Schedule No.") { }
            filter(ProfileCode; "Profile Code") { }
            filter(IdentifierCode; "Identifier Code") { }
            column(LoanNo; "Loan No.") { }
            column(Bps; Bps) { Method = Sum; }
            column(CommissionAmount; "Commission Amount") { Method = Sum; }
            dataitem(CommissionIdentifier; lvnCommissionIdentifier)
            {
                DataItemLink = Code = CommissionJournalLine."Identifier Code";
                SqlJoinType = LeftOuterJoin;

                filter(Code; Code) { }
                filter(Additional_Identifier; "Additional Identifier") { }
            }
        }
    }
}