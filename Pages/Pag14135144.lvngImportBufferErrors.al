page 14135144 "lvngImportBufferErrors"
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
            repeater(lvngRepeater)
            {
                field(lvngDescription; lvngDescription)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetEntries(var lvngImportBufferError: Record lvngImportBufferError)
    begin
        lvngImportBufferError.reset;
        lvngImportBufferError.FindSet();
        repeat
            Clear(Rec);
            Rec := lvngImportBufferError;
            Rec.Insert();
        until lvngImportBufferError.Next() = 0;
    end;

}