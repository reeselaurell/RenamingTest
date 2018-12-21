codeunit 14135100 "lvngGLEntryEventsSubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        DimensionManagement: Codeunit DimensionManagement;
        ShortcutDimValues: array[8] of Code[20];
    begin
        DimensionManagement.GetShortcutDimensions(GLEntry."Dimension Set ID", ShortcutDimValues);
        GLEntry.lvngShortcutDimension3Code := ShortcutDimValues[3];
        GLEntry.lvngShortcutDimension4Code := ShortcutDimValues[4];
        GLEntry.lvngShortcutDimension5Code := ShortcutDimValues[5];
        GLEntry.lvngShortcutDimension6Code := ShortcutDimValues[6];
        GLEntry.lvngShortcutDimension7Code := ShortcutDimValues[7];
        GLEntry.lvngShortcutDimension8Code := ShortcutDimValues[8];
    end;
}