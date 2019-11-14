report 14135315 "lvngCommissionProfiles"
{
    Caption = 'Commission Profiles';
    ProcessingOnly = true;

    dataset
    {
        dataitem(lvngCommissionProfile; lvngCommissionProfile)
        {
            RequestFilterFields = lvngBlocked, lvngCode, lvngCostCenterCode;

            dataitem(lvngCommissionProfileLine; lvngCommissionProfileLine)
            {
                DataItemLink = lvngProfileCode = field(lvngCode);
                RequestFilterFields = lvngCalculationOnly, lvngIdentifierCode, lvngLoanOfficerTypeCode, lvngPeriodIdentifierCode, lvngProfileLineType;
            }

        }
    }
}