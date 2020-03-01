unit About;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TAboutBox }

  TAboutBox = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OKBtn: TBitBtn;
    BitBtn4: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  AboutBox: TAboutBox;

implementation

uses LCLIntf;

{$R *.lfm}

{ TAboutBox }

procedure TAboutBox.BitBtn1Click(Sender: TObject);
begin
  if not OpenDocument('mailto:messages@jakobsche.de') then
    ShowMessage('EMail-Client nicht gefunden')
end;

procedure TAboutBox.BitBtn2Click(Sender: TObject);
begin

end;

procedure TAboutBox.BitBtn4Click(Sender: TObject);
begin
  OpenDocument('https://github.com/jakobsche/classchart')
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
  FocusControl(OKBtn);
end;

end.

