report 14135900 lvngBarcodeReport
{
    Caption = 'Barcode Report';
    RDLCLayout = '_DocumentExchange/Layouts/BarcodeReport.rdl';

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