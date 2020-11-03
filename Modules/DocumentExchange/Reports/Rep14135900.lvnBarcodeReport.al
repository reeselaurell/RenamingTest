report 14135900 "lvnBarcodeReport"
{
    Caption = 'Barcode Report';
    RDLCLayout = 'Modules\DocumentExchange\Reports\Layouts\BarcodeReport.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(BarcodeValue; BarcodeValue) { }
        }
    }

    var
        BarcodeValue: Text;

    procedure SetBarcodeValue(_BarcodeValue: Text)
    begin
        BarcodeValue := _BarcodeValue;
    end;
}