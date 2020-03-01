unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, PairSplitter,
  ComCtrls, Menus, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    FindDialog: TFindDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    TreeView: TTreeView;
    procedure FindDialogCanClose(Sender: TObject; var CanClose: boolean);
    procedure FindDialogFind(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private

  public
    procedure AddClass(AClass: TClass);
  end;

var
  Form1: TForm1;

implementation

uses BinPropStorage, ChipTemp, {DCF77,} DrawnControl, DTV, DynArray, EvMsg,
  FIFORAM, GPIO, LangMenu,
  LEDView, MasterFm,
  NewtonsMethod, PathView, PresEdit, Retain, RetroClock, SinusGenerator,
  SlaveSelDlg, SlvSelFm, StreamBase, Universe;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

{ Package Computer }
  AddClass(TChipTempSensor);
  AddClass(TTripPoint);
  AddClass(TTripPointDescriptions);
  AddClass(TChipTempSensors);
  AddClass(TLEDView);
  AddClass(TRetainData);
  AddClass(TSinusGenerator);

{ Package HMI }
  AddClass(TRetroClock);
  AddClass(TClockScaleLines);
  AddClass(TClockScale);
  AddClass(TClock);
  AddClass(TLine);
  AddClass(TRotativePointer);
  AddClass(TWSRectangle);
  AddClass(TCircle);

{ Package LCLPatch }
  AddClass(TLanguageMenu);
  AddClass(TMasterForm);
  AddClass(TSlaveFormCaptions);
  AddClass(TSlaveSelDlg);
  AddClass(TSlaveSelForm);

{ Package Newton }
  AddClass(TNewtonsMethod);

{ Package Nick }
  AddClass(TDetailledTreeView);
  AddClass(TPathTreeView);
  AddClass(TPresentationPage);
  AddClass(TPresentationEditor);
  AddClass(TPresentation);
  AddClass(TMiniPageView);

{ Package Raspi }
  AddClass(TBinaryInput);
  AddClass(TBinaryOutput);
  AddClass(TEdgeDrivenInput);
  AddClass(TGPIOPort);

{ Package RTLPatch }
  AddClass(TInt32Array);
  AddClass(TQWordArray);
  AddClass(TByteBoolArray);
  AddClass(TInt32Matrix);

{ Package Streams }
  AddClass(TAppPropStorage);
  AddClass(TFIFORAM);
  AddClass(TRegisteredComponentReader);
  AddClass(TStreamableClasses);

{ Package Threads }
  AddClass(TMessageGenerator);

{ Package World}
  AddClass(TUniverse);

  TreeView.AlphaSort;
  TreeView.FullExpand;
end;

procedure TForm1.FindDialogFind(Sender: TObject);
var Node: TTreeNode;
begin
  Node := TreeView.Items.FindNodeWithText((Sender as TFindDialog).FindText);
  if Node <> nil then begin
    Node.Selected := True;
    (Sender as TFindDialog).CloseDialog;
  end
  else ShowMessageFmt('Klasse "%s" nicht gefunden', [(Sender as TFindDialog).FindText])
end;

procedure TForm1.FindDialogCanClose(Sender: TObject; var CanClose: boolean);
begin

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  FindDialog.Execute
end;

procedure TForm1.AddClass(AClass: TClass);
var
  ParentNode: TTreeNode;
  ParentClass: TClass;
  Path: TList;
  i, MaxIndex: Integer;
begin
  if AClass = nil then Exit;
  if TreeView.Items.FindNodeWithData(AClass) <> nil then Exit;
  ParentNode := nil;
  Path := TList.Create;
  try
    Path.Add(AClass);
    ParentClass := AClass.ClassParent;
    if ParentClass <> nil then begin
      ParentNode := TreeView.Items.FindNodeWithData(ParentClass);
      while ParentNode = nil do begin
        Path.Add(ParentClass);
        ParentClass := ParentClass.ClassParent;
        if ParentClass = nil then Break;
        ParentNode := TreeView.Items.FindNodeWithData(ParentClass);
      end
    end;

    MaxIndex := Path.Count - 1;
    if ParentNode = nil then begin
      ParentNode := TreeView.Items.AddObject(nil, TClass(Path[MaxIndex]).ClassName, Path[MaxIndex]);
      Dec(MaxIndex)
    end;
    for i := MaxIndex downto 0 do
      ParentNode := TreeView.Items.AddChildObject(ParentNode, TClass(Path[i]).ClassName, Path[i]);
  finally
    Path.Free
  end;
end;

end.

