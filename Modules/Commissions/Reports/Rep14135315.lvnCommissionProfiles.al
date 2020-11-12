report 14135315 lvnCommissionProfiles
{
    Caption = 'Commission Profiles';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvnCommissionProfile; lvnCommissionProfile)
        {
            RequestFilterFields = Blocked, Code, "Cost Center Code";

            dataitem(lvnCommissionProfileLine; lvnCommissionProfileLine)
            {
                DataItemLink = "Profile Code" = field(Code);
                RequestFilterFields = "Calculation Only", "Identifier Code", "Loan Officer Type Code", "Period Identifier Code", "Profile Line Type";
            }
        }
    }
}