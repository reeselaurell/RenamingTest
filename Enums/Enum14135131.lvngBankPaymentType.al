enum 14135131 "lvngBankPaymentType"
{
    Extensible = false;
    // ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT
    value(0; lvngBlank)
    {
        Caption = ' ';
    }
    value(1; lvngComputerCheck)
    {
        Caption = 'Computer Check';
    }
    value(2; lvngManualCheck)
    {
        Caption = 'Manual Check';
    }
    value(3; lvngElectronicPayment)
    {
        Caption = 'Electronic Payment';
    }
    value(4; lvngElectronicPaymentIAT)
    {
        Caption = 'Electronic Payment-IAT';
    }

}