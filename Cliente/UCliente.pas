unit UCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Vcl.ExtCtrls, UFuncoes, System.Notification;

type
  TFrm_Principal = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    ClientSocket1: TClientSocket;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    NotificationCenter1: TNotificationCenter;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Str: String;
    procedure ShowMessage(Msg: String);
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.dfm}

procedure TFrm_Principal.Button1Click(Sender: TObject);
begin
  Str := Edit2.Text + ' diz: ' + Edit1.Text;
  Memo1.Text := Memo1.Text + Str + #13#10;
  Edit1.Text := ''; // Clears the edit box
  ClientSocket1.Socket.SendText(Str); // Send the messages to the server
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.Perform(em_scrollcaret, 0, 0);
end;

procedure TFrm_Principal.Button2Click(Sender: TObject);
begin
  if not(ClientSocket1.Socket.Connected) then
  begin
    if (Trim(Edit2.Text) = '') or (Trim(Edit3.Text) = '') or
      (Trim(Edit4.Text) = '') then
    begin
      MessageDlg('Informe o usu�rio e o servidor/porta de conex�o!',
        mtInformation, [mbOk], 0);
      Abort;
    end;

    Memo1.Enabled := True; // Conversa
    Edit1.Enabled := True; // Mensagem
    Button1.Enabled := True; // Enviar
    Edit2.Enabled := False; // Usuario
    Edit3.Enabled := False; // Porta
    Edit4.Enabled := False; // Servidor

    ClientSocket1.Port := StrToInt(Trim(Edit3.Text));
    ClientSocket1.Address := Trim(Edit4.Text);
    ClientSocket1.Active := True;
    Button2.Caption := 'Desconectar';
  end;

  if (ClientSocket1.Socket.Connected) then
  begin
    Memo1.Enabled := False; // Conversa
    Edit1.Enabled := False; // Mensagem
    Button1.Enabled := False; // Enviar
    Edit2.Enabled := True; // Usuario
    Edit3.Enabled := True; // Porta
    Edit4.Enabled := True; // Servidor

    Str := Edit2.Text + ' diz: ' + 'Desconectado';
    ClientSocket1.Active := False;
    Button2.Caption := 'Conectar';
  end;
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.Perform(em_scrollcaret, 0, 0);
end;

procedure TFrm_Principal.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Text := Memo1.Text + 'Desconectado' + #13#10;
  ShowMessage('Desconectado');
  Socket.SendText(Str);
  Button1.Enabled := False;
  Edit1.Enabled := False;
  Button2.Caption := 'Conectar';
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.Perform(em_scrollcaret, 0, 0);
end;

procedure TFrm_Principal.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  ClientSocket1.Active := False;
  Memo1.Text := Memo1.Text + 'Conex�o n�o encontrada' + #13#10;
  ShowMessage('Conex�o n�o encontrada');
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.Perform(em_scrollcaret, 0, 0);
end;

procedure TFrm_Principal.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  // Reads and displays the message received from the server;
  Memo1.Text := Memo1.Text + 'Servidor diz: ' + Socket.ReceiveText + #13#10;
  ShowMessage('Servidor diz: ' + Socket.ReceiveText);
  Memo1.SelStart := Length(Memo1.Text);
  Memo1.Perform(em_scrollcaret, 0, 0);
end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
  Memo1.Enabled := False; // Conversa
  Edit1.Enabled := False; // Mensagem
  Button1.Enabled := False; // Enviar
  Edit2.Enabled := True; // Usuario
  Edit3.Enabled := True; // Porta
  Edit4.Enabled := True; // Servidor
  Button2.Enabled := True; // Conectar/Desconectar
end;

procedure TFrm_Principal.ShowMessage(Msg: String);
var
  MyNotification: TNotification;
begin
  if NotificationCenter1.Supported then
  begin
    MyNotification := NotificationCenter1.CreateNotification;
    try
      MyNotification.Name := 'ChatNotification';
      MyNotification.Title := Msg;
      MyNotification.AlertBody := Msg;

      NotificationCenter1.PresentNotification(MyNotification);
    finally
      MyNotification.Free;
    end;
  end;
end;

end.
