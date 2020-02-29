unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, PairSplitter,
  ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    TreeView: TTreeView;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure AddClass(AClass: TClass);
  end;

var
  Form1: TForm1;

implementation

uses DrawnControl, RetroClock;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddClass(TRetroClock);
  AddClass(TClockScaleLines);
  AddClass(TClockScale);
  AddClass(TClock);
  AddClass(TLine);
  AddClass(TRotativePointer);
  AddClass(TWSRectangle);
  AddClass(TCircle);
  TreeView.FullExpand;
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

