unit UnitEmailConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, sLabel,
  sSpinEdit, sEdit, IniFiles, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdBaseComponent, IdMessage;

type
  TEmailConfForm = class(TForm)
    FromEdit: TsEdit;
    ToEdit: TsEdit;
    HostEdit: TsEdit;
    UserNameEdit: TsEdit;
    PassEdit: TsEdit;
    PortEdit: TsSpinEdit;
    sLabel1: TsLabel;
    SaveBtn: TsButton;
    CancelBtn: TsButton;
    SendTestBtn: TsButton;
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SendTestBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EmailConfForm: TEmailConfForm;

implementation

{$R *.dfm}

uses UnitMainForm;

procedure TEmailConfForm.CancelBtnClick(Sender: TObject);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
  Close;
end;

procedure TEmailConfForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Enabled := True;
  MainForm.BringToFront;
end;

procedure TEmailConfForm.FormShow(Sender: TObject);
var
  LEmailSetFile: TIniFile;
begin
  LEmailSetFile := TIniFile.Create(MainForm.AppDataFolder + '\email.ini');
  try
    with LEmailSetFile do
    begin
      FromEdit.Text := ReadString('EMail', 'From', '');
      ToEdit.Text := ReadString('Email', 'To', '');
      HostEdit.Text := ReadString('Email', 'Host', '');
      PortEdit.Text := ReadString('Email', 'Port', '25');
      UserNameEdit.Text := ReadString('Email', 'User', '');
      PassEdit.Text := ReadString('Email', 'Pass', '');
    end;
  finally
    LEmailSetFile.Free;
  end;
end;

procedure TEmailConfForm.SaveBtnClick(Sender: TObject);
var
  LEmailSetFile: TIniFile;
begin
  LEmailSetFile := TIniFile.Create(MainForm.AppDataFolder + '\email.ini');
  try
    with LEmailSetFile do
    begin
      WriteString('EMail', 'From', FromEdit.Text);
      WriteString('Email', 'To', ToEdit.Text);
      WriteString('Email', 'Host', HostEdit.Text);
      WriteString('Email', 'Port', PortEdit.Text);
      WriteString('Email', 'User', UserNameEdit.Text);
      WriteString('Email', 'Pass', PassEdit.Text);
    end;
  finally
    LEmailSetFile.Free;
  end;
end;

procedure TEmailConfForm.SendTestBtnClick(Sender: TObject);
begin
  if (Length(FromEdit.Text) > 0) and (Length(ToEdit.Text) > 0) and (Length(HostEdit.Text) > 0) and (Length(PortEdit.Text) > 0) and (Length(UserNameEdit.Text) > 0) and (Length(PassEdit.Text) > 0) then
  begin
    IdMessage1.From.Address := FromEdit.Text;
    IdMessage1.Recipients.EMailAddresses := ToEdit.Text;
    IdMessage1.Body.Text := 'OneWay Backup Test Mail';
    IdMessage1.Subject := 'OneWay Backup Test Mail';
    try
      IdSMTP1.Host := HostEdit.Text;
      IdSMTP1.Port := PortEdit.Value;
      IdSMTP1.AuthType := satDefault;
      IdSMTP1.Username := UserNameEdit.Text;
      IdSMTP1.Password := PassEdit.Text;
      IdSMTP1.Connect;
      IdSMTP1.Send(IdMessage1);
      Application.MessageBox('Sent test email.', 'Info', MB_ICONINFORMATION);
    except on E: Exception do
      begin
        Application.MessageBox(PWideChar(E.Message), 'Error', MB_ICONERROR);
      end;
    end;
  end;
end;

end.
