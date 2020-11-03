codeunit 14135100 "lvnGLEntryEventsSubscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        DimensionManagement: Codeunit DimensionManagement;
        ShortcutDimValues: array[8] of Code[20];
    begin
        if GLEntry.IsTemporary() then
            exit;
        DimensionManagement.GetShortcutDimensions(GLEntry."Dimension Set ID", ShortcutDimValues);
        GLEntry.lvnShortcutDimension3Code := ShortcutDimValues[3];
        GLEntry.lvnShortcutDimension4Code := ShortcutDimValues[4];
        GLEntry.lvnShortcutDimension5Code := ShortcutDimValues[5];
        GLEntry.lvnShortcutDimension6Code := ShortcutDimValues[6];
        GLEntry.lvnShortcutDimension7Code := ShortcutDimValues[7];
        GLEntry.lvnShortcutDimension8Code := ShortcutDimValues[8];
        GLEntry.lvnLoanNo := GenJournalLine.lvnLoanNo;
        GLEntry.lvnServicingType := GenJournalLine.lvnServicingType;
        GLEntry.lvnComment := GenJournalLine.Comment;
        GLEntry.lvnEntryDate := Today();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterPurchasePostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(PurchaseLine."Line No.");
        InvoicePostBuffer.lvnLoanNo := PurchaseLine.lvnLoanNo;
        InvoicePostBuffer.lvnDescription := PurchaseLine.Description;
        InvoicePostBuffer.lvnReasonCode := PurchaseLine.lvnReasonCode;
        InvoicePostBuffer.lvnComment := PurchaseLine.lvnComment;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', false, false)]
    local procedure OnAfterSalesPostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesLine: Record "Sales Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(SalesLine."Line No.");
        InvoicePostBuffer.lvnLoanNo := SalesLine.lvnLoanNo;
        InvoicePostBuffer.lvnDescription := SalesLine.Description;
        InvoicePostBuffer.lvnServicingType := SalesLine.lvnServicingType;
        InvoicePostBuffer.lvnReasonCode := SalesLine.lvnReasonCode;
        InvoicePostBuffer.lvnComment := SalesLine.lvnComment;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromInvPostBuffer(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        GenJournalLine.lvnServicingType := InvoicePostBuffer.lvnServicingType;
        GenJournalLine.lvnLoanNo := InvoicePostBuffer.lvnLoanNo;
        GenJournalLine.Description := InvoicePostBuffer.lvnDescription;
        if InvoicePostBuffer.lvnReasonCode <> '' then
            GenJournalLine."Reason Code" := InvoicePostBuffer.lvnReasonCode;
        GenJournalLine.Comment := InvoicePostBuffer.lvnComment;
    end;
}