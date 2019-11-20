codeunit 14135999 lvngImplementationManagement
{
    SingleInstance = true;

    var
        NotImplementedErr: Label 'Procedure or Action is not implemented!';

    procedure ThrowNotImplementedError()
    begin
        Error(NotImplementedErr);
    end;
}