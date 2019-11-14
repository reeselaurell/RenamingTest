page 14135313 "lvngCommissionProfileCard"
{
    Caption = 'Commission Profile Card';
    PageType = Card;
    SourceTable = lvngCommissionProfile;

    layout
    {
        area(Content)
        {
            group(lvngGeneral)
            {
                Caption = 'General';
                field(lvngCode; lvngCode)
                {
                    ApplicationArea = All;
                }
                field(lvngName; lvngName)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(lvngCostCenterCode; lvngCostCenterCode)
                {
                    ApplicationArea = All;
                }
                field(lvngBlocked; lvngBlocked)
                {
                    ApplicationArea = All;
                }
                field(lvngCreationTimestamp; lvngCreationTimestamp)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngModificationTimestamp; lvngModificationTimestamp)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(lvngUpdatedBy; lvngUpdatedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            part(lvngCommissionProfileSubform; lvngCommissionProfileSubform)
            {
                Caption = 'Profile Details';
                SubPageLink = lvngProfileCode = field(lvngCode), lvngProfileLineType = const(lvngLoanLevel);
            }
        }


    }
}