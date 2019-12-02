codeunit 14135100 lvngGLEntryEventsSubscriber
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
        GLEntry.lvngShortcutDimension3Code := ShortcutDimValues[3];
        GLEntry.lvngShortcutDimension4Code := ShortcutDimValues[4];
        GLEntry.lvngShortcutDimension5Code := ShortcutDimValues[5];
        GLEntry.lvngShortcutDimension6Code := ShortcutDimValues[6];
        GLEntry.lvngShortcutDimension7Code := ShortcutDimValues[7];
        GLEntry.lvngShortcutDimension8Code := ShortcutDimValues[8];
        GLEntry.lvngLoanNo := GenJournalLine.lvngLoanNo;
        GLEntry.lvngServicingType := GenJournalLine.lvngServicingType;
        GLEntry.lvngEntryDate := Today();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterPurchasePostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(PurchaseLine."Line No.");
        InvoicePostBuffer.lvngLoanNo := PurchaseLine.lvngLoanNo;
        InvoicePostBuffer.lvngDescription := PurchaseLine.Description;
        InvoicePostBuffer.lvngReasonCode := PurchaseLine.lvngReasonCode;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', false, false)]
    local procedure OnAfterSalesPostBufferPrepate(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesLine: Record "Sales Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(SalesLine."Line No.");
        InvoicePostBuffer.lvngLoanNo := SalesLine.lvngLoanNo;
        InvoicePostBuffer.lvngDescription := SalesLine.Description;
        InvoicePostBuffer.lvngServicingType := SalesLine.lvngServicingType;
        InvoicePostBuffer.lvngReasonCode := SalesLine.lvngReasonCode;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromInvPostBuffer(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        GenJournalLine.lvngServicingType := InvoicePostBuffer.lvngServicingType;
        GenJournalLine.lvngLoanNo := InvoicePostBuffer.lvngLoanNo;
        GenJournalLine.Description := InvoicePostBuffer.lvngDescription;
        if InvoicePostBuffer.lvngReasonCode <> '' then
            GenJournalLine."Reason Code" := InvoicePostBuffer.lvngReasonCode;
    end;
}