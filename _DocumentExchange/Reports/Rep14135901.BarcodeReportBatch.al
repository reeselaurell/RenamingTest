report 14135901 lvngBarcodeReportBatch
{
    Caption = 'Barcode Report Batch';
    UsageCategory = Administration;
    RDLCLayout = '_DocumentExchange/Layouts/BarcodeReportBatch.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.";

            column(BarcodeValue; "Purchase Header"."No.") { }
        }
    }
}