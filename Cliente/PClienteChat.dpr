program PClienteChat;

uses
  Vcl.Forms,
  UCliente in 'UCliente.pas' {Frm_Principal},
  UFuncoes in '..\Comum\UFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.Run;
end.
