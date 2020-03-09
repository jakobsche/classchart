unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, PairSplitter, ComCtrls, Menus, Dialogs,
  ActnList, StdCtrls, ExtCtrls;

type

  TExtendedClassInfo = record
    ClassType: TClass;
    PackageName: string;
  end;
  PExtendedClassInfo = ^TExtendedClassInfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    AboutAction: TAction;
    ClassTreeView: TTreeView;
    LicenseAction: TAction;
    FindAction: TAction;
    ActionList1: TActionList;
    FindDialog: TFindDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PageControl1: TPageControl;
    InheritanceSheet: TTabSheet;
    PairSplitter1: TPairSplitter;
    PairSplitter2: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    PackageSheet: TTabSheet;
    PackageTreeView: TTreeView;
    procedure AboutActionExecute(Sender: TObject);
    procedure FindActionExecute(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LicenseActionExecute(Sender: TObject);
    procedure ClassTreeViewSelectionChanged(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
  public
    procedure BuildPackageTree;
    function GetPackageName(AClassNode: TTreeNode): string;
    function GetUnitName(AClassNode: TTreeNode): string;
    procedure SetPackageName(AClassNode: TTreeNode; AValue: string);
    function FindClassNode(AClass: TClass): TTreeNode;
    function FindPackageNode(AName: string): TTreeNode;
    function FindUnitNode(APackageNode: TTreeNode; AUnitName: string): TTreeNode;
    procedure AddClass(AClass: TClass; APackageName: string);
    procedure FixPackagesInClassNodes;
    procedure FreeData(ATreeView: TTreeView);
  end;

var
  Form1: TForm1;

implementation

uses About, GraphType, LCLIntf,
{ Units declaring the classes to explore }
  BinPropStorage, ChipTemp, {DCF77,} DaemonApp, DOM, DrawnControl, DTV, DynArray, EvMsg,
  FIFORAM, GPIO, LangMenu,
  LEDView, MasterFm,
  NewtonsMethod, PathView, PresEdit, Retain, RetroClock, SinusGenerator,
  SlaveSelDlg, SlvSelFm, StreamBase, Universe;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

{ Package Computer }
  AddClass(TChipTempSensor, 'Computer');
  AddClass(TTripPoint, 'Computer');
  AddClass(TTripPointDescriptions, 'Computer');
  AddClass(TChipTempSensors, 'Computer');
  AddClass(TLEDView, 'Computer');
  AddClass(TRetainData, 'Computer');
  AddClass(TSinusGenerator, 'Computer');

{ Package FCL }
  AddClass(TCustomDaemonApplication, 'FCL');
  AddClass(TDOMNode, 'FCL');

{ Package HMI }
  AddClass(TRetroClock, 'HMI');
  AddClass(TClockScaleLines, 'HMI');
  AddClass(TClockScale, 'HMI');
  AddClass(TClock, 'HMI');
  AddClass(TLine, 'HMI');
  AddClass(TRotativePointer, 'HMI');
  AddClass(TWSRectangle, 'HMI');
  AddClass(TCircle, 'HMI');

{ Package LCL }
  AddClass(TApplication, 'LCL');

{ Package LCLPatch }
  AddClass(TLanguageMenu, 'LCLPatch');
  AddClass(TMasterForm, 'LCLPatch');
  AddClass(TSlaveFormCaptions, 'LCLPatch');
  AddClass(TSlaveSelDlg, 'LCLPatch');
  AddClass(TSlaveSelForm, 'LCLPatch');

{ Package Newton }
  AddClass(TNewtonsMethod, 'Newton');

{ Package Nick }
  AddClass(TDetailledTreeView, 'Nick');
  AddClass(TPathTreeView, 'Nick');
  AddClass(TPresentationPage, 'Nick');
  AddClass(TPresentationEditor, 'Nick');
  AddClass(TPresentation, 'Nick');
  AddClass(TMiniPageView, 'Nick');

{ Package Raspi }
  AddClass(TBinaryInput, 'Raspi');
  AddClass(TBinaryOutput, 'Raspi');
  AddClass(TEdgeDrivenInput, 'Raspi');
  AddClass(TGPIOPort, 'Raspi');

{ Package RTL }
  AddClass(TObject, 'RTL');
  AddClass(TDataModule, 'RTL');

{ Package RTLPatch }
  AddClass(TInt32Array, 'RTLPatch');
  AddClass(TQWordArray, 'RTLPatch');
  AddClass(TByteBoolArray, 'RTLPatch');
  AddClass(TInt32Matrix, 'RTLPatch');

{ Package Streams }
  AddClass(TAppPropStorage, 'Streams');
  AddClass(TFIFORAM, 'Streams');
  AddClass(TRegisteredComponentReader, 'Streams');
  AddClass(TStreamableClasses, 'Streams');

{ Package Threads }
  AddClass(TMessageGenerator, 'Threads');

{ Package World}
  AddClass(TUniverse, 'World');

  FixPackagesInClassNodes;
  ClassTreeView.AlphaSort;
  ClassTreeView.FullExpand;

  BuildPackageTree;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeData(ClassTreeView);
  {FreeData(PackageTreeView) Zeiger auf Daten in ClassTreeView}
end;

procedure TForm1.LicenseActionExecute(Sender: TObject);
var
  FileName: string;
begin
  FileName := ExtractfilePath(Application.ExeName) + 'LICENSE.txt';
  if not OpenDocument(FileName) then
    ShowMessageFmt('"%s" nicht gefunden', [FileName]);
end;

procedure TForm1.FindDialogFind(Sender: TObject);
var Node: TTreeNode;
begin
  Node := ClassTreeView.Items.FindNodeWithText((Sender as TFindDialog).FindText);
  if Node <> nil then begin
    Node.Selected := True;
    (Sender as TFindDialog).CloseDialog;
  end
  else ShowMessageFmt('Klasse "%s" nicht gefunden', [(Sender as TFindDialog).FindText])
end;

procedure TForm1.FindActionExecute(Sender: TObject);
begin
  FindDialog.Execute
end;

procedure TForm1.AboutActionExecute(Sender: TObject);
begin
  AboutBox.ShowModal
end;

procedure TForm1.ClassTreeViewSelectionChanged(Sender: TObject);
begin
  StaticText1.Caption := Format('Unit %s', [PExtendedClassInfo((Sender as TTreeView).Selected.Data)^.ClassType.UnitName]);
  StaticText2.Caption := Format('Package %s', [PExtendedClassInfo((Sender as TTreeView).Selected.Data)^.PackageName]);
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;

procedure TForm1.BuildPackageTree;
var
  Node, PackageNode, UnitNode: TTreeNode;
  PackageName, UnitId: string;
begin
  Node := ClassTreeView.Items.GetFirstNode;
  while Node <> nil do begin
    PackageName := GetPackageName(Node);
    PackageNode := FindPackageNode(PackageName);
    if PackageNode = nil then PackageNode := PackageTreeView.Items.Add(nil, PackageName);
    UnitId := GetUnitName(Node);
    UnitNode := FindUnitNode(PackageNode, UnitId);
    if UnitNode = nil then UnitNode := PackageTreeView.Items.AddChild(PackageNode, UnitId);
    PackageTreeView.Items.AddChildObject(UnitNode, Node.Text, Node.Data);
    Node := Node.GetNext;
  end;
  PackageTreeView.AlphaSort;
  PackageTreeView.FullExpand;
end;

function TForm1.GetPackageName(AClassNode: TTreeNode): string;
begin
  Result := PExtendedClassInfo(AClassNode.Data)^.PackageName;
end;

function TForm1.GetUnitName(AClassNode: TTreeNode): string;
begin
  Result := PExtendedClassInfo(AClassNode.Data)^.ClassType.UnitName;
end;

procedure TForm1.SetPackageName(AClassNode: TTreeNode; AValue: string);
begin
  PExtendedClassInfo(AClassNode.Data)^.PackageName := AValue
end;

function TForm1.FindClassNode(AClass: TClass): TTreeNode;
begin
  Result := ClassTreeView.Items.GetFirstNode;
  while Result <> nil do begin
    if PExtendedClassInfo(Result.Data)^.ClassType = AClass then Exit;
    Result := Result.GetNext;
  end;
end;

function TForm1.FindPackageNode(AName: string): TTreeNode;
begin
  Result := PackageTreeView.Items.GetFirstNode;
  while Result <> nil do begin
    if Result.Text = AName then Exit;
    Result := Result.GetNextSibling;
  end;
end;

function TForm1.FindUnitNode(APackageNode: TTreeNode; AUnitName: string
  ): TTreeNode;
begin
  Result := APackageNode.GetFirstChild;
  while Result <> nil do begin
    if Result.Text = AUnitName then Exit;
    Result := Result.GetNextSibling;
  end;
end;

procedure TForm1.AddClass(AClass: TClass; APackageName: string);
  function NewInfo(AClass: TClass; APackageName: string): PExtendedClassInfo;
  begin
    New(Result);
    Result^.ClassType := AClass;
    Result^.PackageName := APackageName
  end;
var
  ParentNode: TTreeNode;
  ParentClass: TClass;
  Path: TList;
  i: Integer;
begin
  if AClass = nil then Exit;
  if FindClassNode(AClass) <> nil then Exit;
  ParentClass := AClass.ClassParent;
  if ParentClass = nil then begin
    ClassTreeView.Items.AddObject(nil, AClass.ClassName, NewInfo(AClass, APackageName));
    Exit
  end;
  ParentNode := FindClassNode(ParentClass);
  Path := TList.Create;
  try
    while ParentNode = nil do begin
      Path.Add(ParentClass);
      ParentClass := ParentClass.ClassParent;
      if ParentClass = nil then begin
        for i := Path.Count - 1 downto 0 do begin
          ParentNode := ClassTreeView.Items.AddChildObject(ParentNode, TClass(Path[i]).ClassName, NewInfo(TClass(Path[i]), ''));
        end;
        ClassTreeView.Items.AddChildObject(ParentNode, AClass.ClassName, NewInfo(AClass, APackageName));
        Exit
      end;
      ParentNode := FindClassNode(ParentClass);
    end;
    for i := Path.Count - 1 downto 0 do begin
      ParentNode := ClassTreeView.Items.AddChildObject(ParentNode, TClass(Path[i]).ClassName, NewInfo(TClass(Path[i]), ''))
    end;
    ClassTreeView.Items.AddChildObject(ParentNode, AClass.ClassName, NewInfo(AClass, APackageName));
  finally
    Path.Free
  end;
end;

procedure TForm1.FixPackagesInClassNodes;
var Node, SourceNode: TTreeNode;
begin
  Node := ClassTreeView.Items.GetFirstNode;
  while Node <> nil do begin
    if GetPackageName(Node) = '' then begin
      SourceNode := ClassTreeView.Items.GetFirstNode;
      while SourceNode <> nil do begin
        if SourceNode = Node then begin
          SourceNode := SourceNode.GetNext;
          Continue;
        end;
        if GetUnitName(SourceNode) = GetUnitName(Node) then
          if GetPackageName(SourceNode) <> '' then begin
            SetPackageName(Node, GetPackageName(SourceNode));
            Break
          end;
        SourceNode := SourceNode.GetNext;
      end;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TForm1.FreeData(ATreeView: TTreeView);
var
  Node: TTreeNode;
begin
  Node := ATreeView.Items.GetFirstNode;
  while Assigned(Node) do begin
      if Assigned(Node.Data) then begin
        Dispose(PExtendedClassInfo(Node.Data));
        Node.Data := nil
      end;
    Node := Node.GetNext;
  end;
end;

end.

