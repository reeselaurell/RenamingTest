page 14135161 lvngChooseCompany
{
    Caption = 'Choose Company';
    PageType = Card;
    SourceTable = Company;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SaveValues = false;
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            field(CompanyNameField; CompanyNameVar)
            {
                Caption = 'Copy To Company';
                ApplicationArea = All;
                TableRelation = Company.Name;
                Lookup = true;

                trigger OnValidate()
                begin
                    SetRange(Name, CompanyNameVar);
                    if FindFirst() then;
                end;
            }
            field(WarnIfRecordExists; WarnIfRecordExists) { Caption = 'Warn if record already exists'; ApplicationArea = All; }
        }
    }

    var
        CompanyNameVar: Text[50];
        WarnIfRecordExists: Boolean;

    trigger OnOpenPage()
    begin
        SetRange(Name, CompanyName);
        if FindFirst() then;
        WarnIfRecordExists := false;
    end;

    procedure GetParameters(var pWarnIfRecordExists: Boolean)
    begin
        pWarnIfRecordExists := WarnIfRecordExists;
    end;
}