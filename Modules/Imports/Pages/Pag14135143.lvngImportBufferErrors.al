page 14135143 lvngImportBufferErrors
{
    PageType = ListPart;
    SourceTable = lvngImportBufferError;
    Caption = 'Import Errors';
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }

    procedure SetEntries(var ImportBufferError: Record lvngImportBufferError)
    begin
        ImportBufferError.Reset();
        ImportBufferError.FindSet();
        repeat
            Clear(Rec);
            Rec := ImportBufferError;
            Rec.Insert();
        until ImportBufferError.Next() = 0;
    end;
}