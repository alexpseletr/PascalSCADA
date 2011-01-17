unit us7tagbuilder;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Spin, CheckLst, tag {$IFDEF FPC}, LCLIntf, LResources{$ENDIF}
  {$IF defined(WINDOWS) or defined(WIN32) or defined(WIN64)}, windows{$IFEND};

type
  TCheckNames = procedure (Sender:TObject; NewName:String; var AcceptNewName:Boolean) of object;

  TTagBitItemEditor = class(TPanel)
  private
    FTagName:String;
    FStartBit,
    FEndBit:Integer;
    FCheckNames:TCheckNames;
    fedtItemName:TEdit;
    lblStart,
    lblEnd:TLabel;
    spinStart,
    spinEnd:TSpinEdit;
    btnDel:TButton;
    fondelclick:TNotifyEvent;
    procedure SetTagName(newname:String);
    procedure SetStartBit(bitindex:integer);
    procedure SetEndBit(bitindex:integer);
  private
    procedure SpinEditChanges(Sender:TObject);
    procedure edtItemNameExit(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property TagName:String read FTagName write SetTagName;
    property StartBit:Integer read FStartBit write SetStartBit;
    property EndBit:Integer read FEndBit write SetEndBit;
    property OnCheckNames:TCheckNames read FCheckNames write FCheckNames;
    property OnDelClick:TNotifyEvent read fondelclick write fondelclick;
  end;

  TS7TagItemEditor = class(TPanel)
  private
    FTagName:String;
    FTagType:TTagType;
    FTagScan:TRefreshTime;
    FSwapWords,
    FSwapBytes,
    FSkip:Boolean;
    edtItemName:TEdit;
    cmbItemType:TComboBox;
    spinScan:TSpinEdit;
    optSwapBytes,
    optSwapWords,
    optSkip:TCheckBox;
    btnUp,
    btnDown,
    btnDel,
    btnBits:TButton;
    TagArea,
    BitArea:TPanel;
    FCheckNames:TCheckNames;
    FUpClickEvent,
    FDownClickEvent,
    FDelClickEvent,
    FBitsClickEvent:TNotifyEvent;
    BitList:TList;
    DelTimer:TTimer;
    DelList:TList;
    procedure SetTagName(newName:String);
    procedure SetTagType(newType:TTagType);
    procedure SetTagScan(newScan:TRefreshTime);
    procedure SetSwapBytes(swap:Boolean);
    procedure SetSwapWords(swap:Boolean);
    procedure SetSkipTag(Skip:Boolean);
  private
    procedure CheckNames(Sender:TObject; NewName:String; var AcceptNewName:Boolean);
    procedure btnClick(Sender:TObject);
    procedure optChange(Sender:TObject);
    procedure edtItemNameExit(Sender:TObject);
    procedure DelBitItem(Sender:TObject);
  private
    function GetBitCount:Integer;
    function GetBit(Index:Integer):TTagBitItemEditor;
    procedure OnDelTimer(Sender:TObject);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure PopulateCombo;
    procedure EnablePLCNumberTagMode;
    procedure EnablePLCBlockMode;
    procedure EnablePLCStructMode;
    property  Bit[index:Integer]:TTagBitItemEditor read GetBit;
  published
    property  BitCount:Integer read GetBitCount;
    function  AddBit:TTagBitItemEditor;
    procedure DelBit(index:Integer);
    function  GetIndex(tbitEditor:TTagBitItemEditor):Integer;
    function  AcceptName(TheName:String):Boolean;
  published
    property TagName:String Read FTagName write SetTagName;
    property TagType:TTagType read FTagType write SetTagType;
    property TagScan:TRefreshTime read FTagScan write SetTagScan;
    property SwapBytes:Boolean read FSwapBytes write SetSwapBytes;
    property SwapWords:Boolean read FSwapWords write SetSwapWords;
    property SkipTag:Boolean read FSkip write SetSkipTag;
    property OnCheckNames:TCheckNames read FCheckNames write FCheckNames;
    property OnUpClick:TNotifyEvent read FUpClickEvent write FUpClickEvent;
    property OnDownClickEvent:TNotifyEvent read FDownClickEvent write FDownClickEvent;
    property OnDelClickEvent:TNotifyEvent read FDelClickEvent write FDelClickEvent;
    property OnBitsClickEvent:TNotifyEvent read FBitsClickEvent write FBitsClickEvent;
  end;

  { TfrmS7TagBuilder }

  TfrmS7TagBuilder = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MemoryArea: TRadioGroup;
    Panel3: TPanel;
    Panel4: TPanel;
    PLCAddress: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PLCStation: TSpinEdit;
    PLCSlot: TSpinEdit;
    PLCRack: TSpinEdit;
    grptagtype: TGroupBox;
    optplctagnumber: TRadioButton;
    optplcblock: TRadioButton;
    optplcStruct: TRadioButton;
    TabSheet2: TTabSheet;
    IOStartByte: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    IOEndByte: TSpinEdit;
    BitList: TCheckListBox;
    Label8: TLabel;
    Label9: TLabel;
    IOBlockName: TEdit;
    Label10: TLabel;
    IOByteNames: TEdit;
    Label11: TLabel;
    IOBitNames: TEdit;
    Memo1: TMemo;
    IOByteNumberZeroFill: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    TabSheet3: TTabSheet;
    Label14: TLabel;
    CTStartAddress: TSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    CTEndAddress: TSpinEdit;
    Label18: TLabel;
    CTBlockName: TEdit;
    Label19: TLabel;
    CTNames: TEdit;
    Memo2: TMemo;
    Label20: TLabel;
    Label21: TLabel;
    CTZeroFill: TCheckBox;
    TabSheet4: TTabSheet;
    btnSelectAll: TButton;
    btnUnselectAll: TButton;
    btnInvertSelection: TButton;
    IOStatus: TMemo;
    CTStatus: TMemo;
    Panel5: TPanel;
    Label7: TLabel;
    spinNumStructs: TSpinEdit;
    spinStructStartAddress: TSpinEdit;
    Label22: TLabel;
    spinDBNum: TSpinEdit;
    Label23: TLabel;
    ScrollBox1: TScrollBox;
    Label24: TLabel;
    Label25: TLabel;
    BlockType: TComboBox;
    Button1: TButton;
    BlockScan: TSpinEdit;
    Label26: TLabel;
    BlockSwapBytes: TCheckBox;
    BlockSwapWords: TCheckBox;
    StructScan: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Timer1: TTimer;
    btnCancel: TButton;
    btnBack: TButton;
    btnNext: TButton;
    btnFinish: TButton;
    procedure BitListKeyPress(Sender: TObject; var Key: char);
    procedure MemoryAreaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnUnselectAllClick(Sender: TObject);
    procedure btnInvertSelectionClick(Sender: TObject);
    procedure optplcblockClick(Sender: TObject);
    procedure IOStartByteChange(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure CTStartAddressChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnBitsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BlockTypeChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
  private
    OldPage:TTabSheet;
    FItemId:Integer;
    TagList,
    ItemsToDel:TList;
    procedure CheckNames(Sender:TObject; NewName:String; var AcceptNewName:Boolean);
    function GetStructItemsCount:Integer;
    function GetStructItem(index:Integer):TS7TagItemEditor;
  public
    destructor Destroy; override;
    property StructItemsCount:Integer read GetStructItemsCount;
    property StructItem[index:integer]:TS7TagItemEditor read GetStructItem;
  end;

var
  frmS7TagBuilder: TfrmS7TagBuilder;

implementation

uses strutils, Math, ubitmapper;

{$IFDEF FPC }
  {$IF defined(FPC) AND (FPC_FULLVERSION >= 20400) }
  {$R us7tagbuilder.lfm}
  {$IFEND}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

///////////////////////////////////////////////////////////////////////////////
//TagBitEditor
///////////////////////////////////////////////////////////////////////////////
constructor TTagBitItemEditor.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Align:=alTop;
  BevelOuter:=bvNone;
  Height:=25;
  Caption:='';

  fedtItemName:=TEdit.Create(Self);
  with fedtItemName do begin
    Parent:=Self;
    Left :=16;
    Top  := 2;
    Width:=137;
    OnExit:=edtItemNameExit;
  end;

  lblStart:=TLabel.Create(Self);
  with lblStart do begin
    Parent:=Self;
    AutoSize:=false;
    Alignment:=taRightJustify;
    Layout:=tlCenter;
    Caption:='Start Bit';
    Height:=21;
    Width:=49;
    Left:=168;
    Top:=2;
  end;

  lblEnd:=TLabel.Create(Self);
  with lblEnd do begin
    Parent:=Self;
    AutoSize:=false;
    Alignment:=taRightJustify;
    Layout:=tlCenter;
    Caption:='End Bit';
    Height:=21;
    Width:=49;
    Left:=272;
    Top:=2;
  end;

  spinStart:=TSpinEdit.Create(Self);
  with spinStart do begin
    Parent:=Self;
    Height:=22;
    Left:=224;
    MaxValue:=31;
    MinValue:=0;
    Top:=2;
    Width:=41;
    OnChange := SpinEditChanges;
  end;

  spinEnd:=TSpinEdit.Create(Self);
  with spinEnd do begin
    Parent:=Self;
    Height:=22;
    Left:=328;
    MaxValue:=31;
    MinValue:=0;
    Top:=2;
    Width:=41;
    OnChange := SpinEditChanges;
  end;

  btnDel:=TButton.Create(Self);
  with btnDel do begin
    Parent:=Self;
    Caption:='Del';
    Height:=22;
    Left:=503;
    Top:=3;
    Width:=33;
    OnClick:=btnDelClick;
  end;
end;

destructor  TTagBitItemEditor.Destroy;
begin
  fedtItemName.Destroy;
  lblStart.Destroy;
  lblEnd.Destroy;
  spinStart.Destroy;
  spinEnd.Destroy;
  btnDel.Destroy;
  inherited Destroy;
end;

procedure TTagBitItemEditor.SetTagName(newname:String);
var
  accept:Boolean;
begin
  accept:=true;
  if Assigned(FCheckNames) then
    FCheckNames(Self,newname,accept);

  if accept then begin
    FTagName:=newname;
    fedtItemName.Text:=newname;
    fedtItemName.Modified:=false;
  end;
end;

procedure TTagBitItemEditor.SetStartBit(bitindex:integer);
begin
  FStartBit:=bitindex;
  spinStart.Value:=bitindex;

  if FStartBit>FEndBit then begin
    FEndBit:=bitindex;
    spinEnd.Value:=FEndBit;
  end;
end;

procedure TTagBitItemEditor.SetEndBit(bitindex:integer);
begin
  FEndBit:=bitindex;
  spinEnd.Value:=bitindex;

  if FStartBit>FEndBit then begin
    FStartBit:=bitindex;
    spinStart.Value:=FStartBit;
  end;
end;

procedure TTagBitItemEditor.SpinEditChanges(Sender:TObject);
begin
  if (Sender=spinStart) then begin
    FStartBit:=spinStart.Value;
    if (spinStart.Value>spinEnd.Value) then begin
      spinEnd.Value := spinStart.Value;
      FEndBit:=spinEnd.Value;
    end;
  end;

  if (Sender=spinEnd) then begin
    FEndBit:=spinEnd.Value;
    if (spinStart.Value>spinEnd.Value) then begin
      spinStart.Value := spinEnd.Value;
      FStartBit:=spinStart.Value;
    end;
  end;
end;

procedure TTagBitItemEditor.edtItemNameExit(Sender:TObject);
var
  accept:Boolean;
begin
  if not fedtItemName.Modified then exit;
  accept:=true;
  if Assigned(FCheckNames) then
    FCheckNames(Self,fedtItemName.Text,accept);

  if accept then begin
    fedtItemName.Modified:=false;
    FTagName:=fedtItemName.Text;
  end else begin
    fedtItemName.Text:=FTagName;
    fedtItemName.Modified:=false;
  end;
end;

procedure TTagBitItemEditor.btnDelClick(Sender:TObject);
begin
  if assigned(fondelclick) then
    fondelclick(Self);
end;

///////////////////////////////////////////////////////////////////////////////
//S7TagEditor
///////////////////////////////////////////////////////////////////////////////

constructor TS7TagItemEditor.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Align:=altop;
  BevelOuter:=bvNone;
  Height:=30;
  Caption:='';
  Top:=$7FFFFFFF;

  BitList:=TList.Create;
  DelList:=TList.Create;
  DelTimer:=TTimer.Create(Self);  
  DelTimer.Enabled:=false;
  DelTimer.Interval:=10;
  DelTimer.OnTimer:=OnDelTimer;

  FSkip:=false;
  FSwapWords:=false;
  FSwapBytes:=false;
  FTagType:=pttDefault;

  TagArea:=TPanel.Create(Self);
  with TagArea do begin
    Parent:=Self;
    Align:=alTop;
    BevelOuter:=bvNone;
    Height:=25;
    Caption:='';
  end;

  BitArea:=TPanel.Create(Self);
  with BitArea do begin
    Parent:=Self;
    Align:=alClient;
    BevelOuter:=bvNone;
    Top:=31;
    Height:=0;
    Caption:='';
  end;

  edtItemName:=TEdit.Create(Self);
  with edtItemName do begin
    Parent := TagArea;
    Height:=21;
    Width:=152;
    Left:=2;
    Top:=2;
    OnExit:=edtItemNameExit;
  end;

  cmbItemType:=TComboBox.Create(Self);
  with cmbItemType do begin
    Parent:=TagArea;
    Left:=155;
    top:=2;
    Style:=csDropDownList;
    Width:=78;
    OnChange:=optChange;
  end;

  spinScan:=TSpinEdit.Create(Self);
  with spinScan do begin
    Parent:=TagArea;
    Height:=22;
    Left:=238;
    MaxValue:=$7FFFFFFF;
    MinValue:=0;
    Value:=1000;
    Top:=2;
    Width:=55;
    OnChange:=optChange;
  end;

  optSwapBytes:=TCheckBox.Create(Self);
  with optSwapBytes do begin
    Parent:=TagArea;
    Caption:='Bytes';
    Height:=17;
    Left:=297;
    Top:=4;
    Width:=50;
    Checked:=FSwapBytes;
    Enabled:=false;
    OnClick:=optChange;
  end;

  optSwapWords:=TCheckBox.Create(Self);
  with optSwapWords do begin
    Parent:=TagArea;
    Caption:='Words';
    Height:=17;
    Left:=347;
    Top:=4;
    Width:=51;
    Checked:=FSwapWords;
    Enabled:=false;
    OnClick:=optChange;
  end;

  optSkip:=TCheckBox.Create(Self);
  with optSkip do begin
    Parent:=TagArea;
    Caption:='';
    Height:=17;
    Left:=409;
    Top:=4;
    Width:=15;
    Checked:=FSkip;
    OnClick:=optChange;
  end;

  btnUp:=TButton.Create(Self);
  with btnUp do begin
    Parent:=TagArea;
    Caption:='UP';
    Height:=22;
    Left:=437;
    Top:=3;
    Width:=33;
    OnClick:=btnClick;
  end;

  btnDown:=TButton.Create(Self);
  with btnDown do begin
    Parent:=TagArea;
    Caption:='Down';
    Height:=22;
    Left:=470;
    Top:=3;
    Width:=33;
    OnClick:=btnClick;
  end;

  btnDel:=TButton.Create(Self);
  with btnDel do begin
    Parent:=TagArea;
    Caption:='Del';
    Height:=22;
    Left:=503;
    Top:=3;
    Width:=33;
    OnClick:=btnClick;
  end;

  btnBits:=TButton.Create(Self);
  with btnBits do begin
    Parent:=TagArea;
    Caption:='Bits';
    Height:=22;
    Left:=536;
    Top:=3;
    Width:=28;
    OnClick:=btnClick;
  end;
end;

destructor TS7TagItemEditor.Destroy;
var
  c:Integer;
begin
  for c:=GetBitCount-1 downto 0 do
    DelBit(c);
  BitList.Destroy;
  inherited Destroy;
end;

procedure TS7TagItemEditor.PopulateCombo;
begin
  with cmbItemType do begin
    Items.Clear;
    Items.Clear;
    Items.Add('pttDefault');
    Items.Add('pttShortInt');
    Items.Add('pttByte');
    Items.Add('pttSmallInt');
    Items.Add('pttWord');
    Items.Add('pttInteger');
    Items.Add('pttDWord');
    Items.Add('pttFloat');
    ItemIndex:=0;
  end;
end;

procedure TS7TagItemEditor.EnablePLCNumberTagMode;
begin
  spinScan.Enabled:=true;
  cmbItemType.Enabled:=true;
  //optSwapBytes.Enabled:=true;
  //optSwapWords.Enabled:=true;
end;

procedure TS7TagItemEditor.EnablePLCBlockMode;
begin
  spinScan.Enabled:=false;
  cmbItemType.Enabled:=false;
  //optSwapBytes.Enabled:=false;
  //optSwapWords.Enabled:=false;
end;

procedure TS7TagItemEditor.EnablePLCStructMode;
begin
  spinScan.Enabled:=false;
  cmbItemType.Enabled:=true;
  //optSwapBytes.Enabled:=true;
  //optSwapWords.Enabled:=true;
end;

function TS7TagItemEditor.GetBitCount:Integer;
begin
  Result:=BitList.Count;
end;

function TS7TagItemEditor.GetBit(Index:Integer):TTagBitItemEditor;
begin
  Result:=TTagBitItemEditor(BitList.Items[index])
end;

function  TS7TagItemEditor.AddBit:TTagBitItemEditor;
var
  tb:TTagBitItemEditor;
begin
  tb:=TTagBitItemEditor.Create(Self);
  tb.Parent:=BitArea;
  tb.OnDelClick:=DelBitItem;
  tb.OnCheckNames:=CheckNames;
  tb.Top:=BitList.Count*tb.Height+1;
  BitList.Add(tb);
  Self.Height:=TagArea.Height+(tb.Height*BitList.Count)+3;
  Result:=tb;
end;

procedure TS7TagItemEditor.OnDelTimer(Sender:TObject);
var
  c, i:Integer;
begin
  for c:=DelList.Count-1 downto 0 do begin
    i:=GetIndex(TTagBitItemEditor(DelList.Items[c]));
    DelBit(i);
    DelList.Delete(c);
  end;
  DelTimer.Enabled:=false;
end;

procedure TS7TagItemEditor.DelBit(index:Integer);
var
  tb:TTagBitItemEditor;
begin
  tb:=TTagBitItemEditor(BitList.Items[index]);
  BitList.Remove(tb);
  self.Height:=TagArea.Height+(tb.Height*BitList.Count);
  tb.Destroy;
end;

function  TS7TagItemEditor.GetIndex(tbitEditor:TTagBitItemEditor):Integer;
begin
  Result:=BitList.IndexOf(tbitEditor);
end;

function  TS7TagItemEditor.AcceptName(TheName:String):Boolean;
var
  accept1, accept2 :Boolean;
begin
  accept1:=true;
  accept2:=true;

  //checa o nome com os bits...
  CheckNames(Self, TheName, accept1);

  //checa o nome com os demais itens...
  if accept1 and Assigned(FCheckNames) then
    FCheckNames(Self,TheName,accept2);

  //Ok caso passe nos dois testes...
  Result:=accept1 and accept2;
end;

procedure TS7TagItemEditor.SetTagName(newName:String);
var
  accept:Boolean;
begin
  accept:=true;
  if Assigned(FCheckNames) then
    FCheckNames(Self,newname,accept);

  if accept then begin
    FTagName:=newname;
    edtItemName.Text:=newname;
    edtItemName.Modified:=false;
  end;
end;

procedure TS7TagItemEditor.SetTagType(newType:TTagType);
begin
  FTagType:=newType;
  case newType of
    pttDefault:
      cmbItemType.ItemIndex:=0;
    pttShortInt:
      cmbItemType.ItemIndex:=1;
    pttByte:
      cmbItemType.ItemIndex:=2;
    pttSmallInt:
      cmbItemType.ItemIndex:=3;
    pttWord:
      cmbItemType.ItemIndex:=4;
    pttInteger:
      cmbItemType.ItemIndex:=5;
    pttDWord:
      cmbItemType.ItemIndex:=6;
    pttFloat:
      cmbItemType.ItemIndex:=7;
  end;
end;

procedure TS7TagItemEditor.SetTagScan(newScan:TRefreshTime);
begin
  FTagScan:=newScan;
  spinScan.Value:=FTagScan;
end;

procedure TS7TagItemEditor.SetSwapBytes(swap:Boolean);
begin
  FSwapBytes:=swap;
  optSwapBytes.Checked:=FSwapBytes;
end;

procedure TS7TagItemEditor.SetSwapWords(swap:Boolean);
begin
  FSwapWords:=swap;
  optSwapWords.Checked:=FSwapWords;
end;

procedure TS7TagItemEditor.SetSkipTag(Skip:Boolean);
begin
  FSkip:=Skip;
  optSkip.Checked:=FSkip;
end;

procedure TS7TagItemEditor.edtItemNameExit(Sender:TObject);
var
  accept1, accept2 :Boolean;
  b:Integer;
  oldname:String;
begin
  if not edtItemName.Modified then exit;

  accept1:=true;
  accept2:=true;

  //checa o nome com os bits...
  CheckNames(Sender,edtItemName.Text,accept1);

  //checa o nome com os demais itens...
  if accept1 and Assigned(FCheckNames) then
    FCheckNames(Self,edtItemName.Text,accept2);

  //se pelo menos um falhou, volta o nome anterior...
  if (accept1=true) and (accept2=true) then begin
    edtItemName.Modified:=false;
    oldname:=FTagName;
    FTagName:=edtItemName.Text;

    //atualiza nome dos bits
    for b:=0 to BitCount-1 do
      TTagBitItemEditor(Bit[b]).TagName := StringReplace(TTagBitItemEditor(Bit[b]).TagName,oldname,FTagName,[rfReplaceAll, rfIgnoreCase]);
      
  end else begin
    edtItemName.Text:=FTagName;
    edtItemName.Modified:=false;
  end;
end;

procedure TS7TagItemEditor.DelBitItem(Sender:TObject);
begin
  if not (Sender is TTagBitItemEditor) then exit;

  if MessageDlg('Delete item "'+(Sender as TTagBitItemEditor).TagName+'"?',mtConfirmation,[mbyes,mbNo],0)=mrno then exit;

  DelList.Add(Sender);
  DelTimer.Enabled:=true;
end;

procedure TS7TagItemEditor.optChange(Sender:TObject);
begin
  if Sender=optSwapBytes then
    FSwapBytes:=optSwapBytes.Checked;

  if Sender=optSwapWords then
    FSwapWords:=optSwapWords.Checked;

  if Sender=optSkip then
    FSkip:=optSkip.Checked;

  if Sender=spinScan then
    FTagScan:=spinScan.Value;

  if Sender=cmbItemType then begin
    case cmbItemType.ItemIndex of
      0:
        FTagType:=pttDefault;
      1:
        FTagType:=pttShortInt;
      2:
        FTagType:=pttByte;
      3:
        FTagType:=pttSmallInt;
      4:
        FTagType:=pttWord;
      5:
        FTagType:=pttInteger;
      6:
        FTagType:=pttDWord;
      7:
        FTagType:=pttFloat;
    end;
    case cmbItemType.ItemIndex of
      0,1,2: begin
        optSwapBytes.Checked:=false;
        optSwapBytes.Enabled:=false;
        optSwapWords.Checked:=false;
        optSwapWords.Enabled:=false;
      end;
      3,4: begin
        optSwapBytes.Checked:=True;
        optSwapBytes.Enabled:=True;
      end;
      5,6,7: begin
        optSwapBytes.Checked:=True;
        optSwapBytes.Enabled:=True;
        optSwapWords.Checked:=True;
        optSwapWords.Enabled:=True;
      end;
    end;
  end;
end;

//evento chamado pelos bits do tag para verificar seu nome...
procedure TS7TagItemEditor.CheckNames(Sender:TObject; NewName:String; var AcceptNewName:Boolean);
var
  b:Integer;
begin
  if (Sender<>Self) and (NewName=TagName) then begin
    AcceptNewName:=false
  end else begin
    for b:=0 to GetBitCount-1 do
      if (Sender<>Bit[b]) and (Bit[b].TagName=NewName) then begin
        AcceptNewName:=false ;
        exit;
      end;

    if Assigned(FCheckNames) then
      FCheckNames(sender,NewName, AcceptNewName);
  end;
end;

procedure TS7TagItemEditor.btnClick(Sender:TObject);
begin
  if (Sender=btnUp) and Assigned(FUpClickEvent) then
    FUpClickEvent(Self);

  if (Sender=btnDown) and Assigned(FDownClickEvent) then
    FDownClickEvent(Self);

  if (Sender=btnBits) and Assigned(FBitsClickEvent) then
    FBitsClickEvent(Self);

  //esta linha tem q ficar por ultimo sempre!!!
  if (Sender=btnDel) and Assigned(FDelClickEvent) then
    FDelClickEvent(Self);    
end;

///////////////////////////////////////////////////////////////////////////////

procedure TfrmS7TagBuilder.MemoryAreaClick(Sender: TObject);
begin
  optplctagnumber.Enabled:=false;
  optplcblock.Enabled:=false;
  optplcStruct.Enabled:=false;

  case MemoryArea.ItemIndex of
    0, 1, 4, 5: begin
      optplctagnumber.Enabled:=false;
      optplcblock.Enabled:=true;

      if optplcStruct.Checked then
        optplcblock.Checked:=true;

      IOBlockName.Visible:=optplcblock.Checked;
      CTBlockName.Visible:=optplcblock.Checked;

      label25.Enabled:=false;
      BlockType.Enabled:=false;

      case MemoryArea.ItemIndex of
        0: begin
          IOBlockName.Text := 'Inputs_%sb_to_%eb';
          IOByteNames.Text := 'IB%B';
          IOBitNames.Text  := 'I%B_%b';
          BlockType.ItemIndex := 2;
        end;
        1: begin
          IOBlockName.Text := 'Outputs_%sb_to_%eb';
          IOByteNames.Text := 'QB%B';
          IOBitNames.Text  := 'Q%B_%b';
          BlockType.ItemIndex := 2;
        end;
        4: begin
          CTBlockName.Text := 'Counters_%si_to_%ei';
          CTNames.Text     := 'C%I';
          BlockType.ItemIndex := 4;
        end;
        5: begin
          CTBlockName.Text := 'Timers_%si_to_%ei';
          CTNames.Text     := 'T%I';
          BlockType.ItemIndex := 4;
        end;
      end;
    end;
    2, 3: begin
      optplctagnumber.Enabled:=true;
      optplcblock.Enabled:=true;
      optplcStruct.Enabled:=true;

      Label23.Enabled:=MemoryArea.ItemIndex=3;
      spinDBNum.Enabled:=Label23.Enabled;

      label25.Enabled:=true;
      BlockType.Enabled:=true;
    end;
  end;
  BlockTypeChange(Sender);
end;

procedure TfrmS7TagBuilder.BitListKeyPress(Sender: TObject; var Key: char);
begin
  IOStartByteChange(Sender);
end;

procedure TfrmS7TagBuilder.FormCreate(Sender: TObject);
begin
  btnSelectAllClick(Sender);
  PageControl1.ActivePageIndex:=0;
  TagList:=TList.Create;
  ItemsToDel:=TList.Create;
end;

procedure TfrmS7TagBuilder.FormShow(Sender: TObject);
begin
  MemoryAreaClick(Sender);
end;

procedure TfrmS7TagBuilder.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
end;

procedure TfrmS7TagBuilder.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //onclose query
end;

procedure TfrmS7TagBuilder.btnSelectAllClick(Sender: TObject);
var
  c:Integer;
begin
  for c:=0 to 7 do
    BitList.Checked[c]:=true;
  IOStartByteChange(Sender);
end;

procedure TfrmS7TagBuilder.btnUnselectAllClick(Sender: TObject);
var
  c:Integer;
begin
  for c:=0 to 7 do
    BitList.Checked[c]:=false;
  IOStartByteChange(Sender);
end;

procedure TfrmS7TagBuilder.btnInvertSelectionClick(Sender: TObject);
var
  c:Integer;
begin
  for c:=0 to 7 do
    BitList.Checked[c]:=not BitList.Checked[c];
  IOStartByteChange(Sender);
end;

procedure TfrmS7TagBuilder.optplcblockClick(Sender: TObject);
var
  c:Integer;
begin
  IOBlockName.Enabled:=optplcblock.Checked;
  CTBlockName.Enabled:=optplcblock.Checked;
  Label9.Enabled:=IOBlockName.Enabled;
  Label18.Enabled:=CTBlockName.Enabled;
  label25.Enabled:=optplcblock.Checked and (MemoryArea.ItemIndex in [2,3]);
  BlockType.Enabled:=optplcblock.Checked and (MemoryArea.ItemIndex in [2,3]);

  for c:=0 to TagList.Count-1 do begin
    if optplctagnumber.Checked then
      TS7TagItemEditor(TagList.Items[c]).EnablePLCNumberTagMode
    else
      if optplcblock.Checked then
        TS7TagItemEditor(TagList.Items[c]).EnablePLCBlockMode
      else
        TS7TagItemEditor(TagList.Items[c]).EnablePLCStructMode;
  end;
end;

procedure TfrmS7TagBuilder.IOStartByteChange(Sender: TObject);
var
  nbytes, nbits, c:Integer;
begin
  if (IOEndByte.Value<IOStartByte.Value) then begin
    if (Sender=IOStartByte) then
      IOEndByte.Value:=IOStartByte.Value;

    if (Sender=IOEndByte) then
      IOStartByte.Value:=IOEndByte.Value;
  end;


  nbytes:=IOEndByte.Value-IOStartByte.Value+1;
  nbits:=0;
  for c:=0 to 7 do
    if BitList.Checked[c] then
      inc(nbits);

  with IOStatus.Lines do begin
    Clear;
    Add('Sera criado/Will be created:');
    Add(IfThen(optplcblock.checked, '1 PLCBlock, ', '')+
        IntToStr(nBytes)+IfThen(optplcblock.checked, ' PLCBlockElement(s) and ', ' PLCTagNumber(s) and ')+
        IntToStr(nbits*nbytes)+' TagBit(s)')
  end;
end;

procedure TfrmS7TagBuilder.TabSheet2Show(Sender: TObject);
begin
  btnBack.Enabled:=true;
  btnFinish.Enabled:=true;
  btnNext.Enabled:=false;

  IOStartByteChange(sender);
end;

procedure TfrmS7TagBuilder.CTStartAddressChange(Sender: TObject);
var
  nitems:Integer;
begin
  if (CTEndAddress.Value<CTStartAddress.Value) then begin
    if (Sender=CTStartAddress) then
      CTEndAddress.Value:=CTStartAddress.Value;

    if (Sender=CTEndAddress) then
      CTStartAddress.Value:=CTEndAddress.Value;
  end;

  nitems := CTEndAddress.Value - CTStartAddress.Value + 1;
  with CTStatus.Lines do begin
    Clear;
    Add('Sera criado/Will be created:');
    Add(IfThen(optplcblock.checked, '1 PLCBlock and ', '')+
        IntToStr(nitems)+IfThen(optplcblock.checked, ' PLCBlockElement(s)', ' PLCTagNumber(s)'))
  end;
end;

procedure TfrmS7TagBuilder.Button1Click(Sender: TObject);
var
  tag, lastitem:TS7TagItemEditor;
begin
  inc(FItemId);

  tag:=TS7TagItemEditor.Create(Self);
  tag.Parent := ScrollBox1;
  tag.PopulateCombo;
  tag.OnCheckNames:=CheckNames;
  tag.OnUpClick:=btnUpClick;
  tag.OnDownClickEvent:=btnDownClick;
  tag.OnDelClickEvent:=btnDelClick;
  tag.OnBitsClickEvent:=btnBitsClick;
  tag.TagScan:=1000;
  tag.TagType:=pttDefault;
  tag.SwapBytes:=false;
  tag.SwapWords:=false;
  if TagList.Count>0 then begin
    lastitem:=TS7TagItemEditor(taglist.Items[TagList.Count-1]);
    tag.Top:=lastitem.Top+lastitem.Height;
  end else begin
    tag.Top:=0;
  end;

  if optplctagnumber.Checked then
    tag.EnablePLCNumberTagMode
  else
    if optplcblock.Checked then
      tag.EnablePLCBlockMode
    else
      tag.EnablePLCStructMode;

  TagList.Add(tag);

  while not tag.AcceptName('StructItem'+IntToStr(FItemId)) do
    inc(FItemId);
  tag.TagName:='StructItem'+IntToStr(FItemId);
end;

procedure TfrmS7TagBuilder.btnUpClick(Sender: TObject);
var
  idx:Integer;
  priortop, actualTop:Integer;
  prior:TS7TagItemEditor;
begin
  if not (Sender is TS7TagItemEditor) then exit;

  idx := TagList.IndexOf(Sender);
  if idx>0 then begin
    prior:=TS7TagItemEditor(TagList.Items[idx-1]);

    priortop:=prior.Top;
    actualTop:=(Sender as TS7TagItemEditor).Top;

    TagList.Exchange(idx-1, idx);

    (Sender as TS7TagItemEditor).Top:=priortop;
    (Sender as TS7TagItemEditor).TabOrder:=prior.TabOrder;
    prior.Top:=actualTop;
  end;
end;

procedure TfrmS7TagBuilder.btnDownClick(Sender: TObject);
var
  idx:Integer;
  nexttop, actualTop:Integer;
  next:TS7TagItemEditor;
begin
  if not (Sender is TS7TagItemEditor) then exit;

  idx := TagList.IndexOf(Sender);
  if (idx<>-1) and (idx<(TagList.Count-1)) then begin
    next:=TS7TagItemEditor(TagList.Items[idx+1]);

    nexttop:=next.Top;
    actualTop:=(Sender as TS7TagItemEditor).Top;

    TagList.Exchange(idx+1, idx);

    (Sender as TS7TagItemEditor).Top:=nexttop;
    next.TabOrder:=(Sender as TS7TagItemEditor).TabOrder;
    next.Top:=actualTop;
  end;
end;

procedure TfrmS7TagBuilder.btnDelClick(Sender: TObject);
begin
  if ItemsToDel.IndexOf(Sender)=-1 then begin
    ItemsToDel.Add(Sender);
    Timer1.Enabled:=true;
  end;
end;

procedure TfrmS7TagBuilder.btnBitsClick(Sender: TObject);
var
  frmbit:TfrmBitMapper;
  ti:TTagBitItemEditor;
  s7tageditor:TS7TagItemEditor;
  bitnum,
  bytenum,
  wordnum,
  startbit,
  endbit,
  curbit:Integer;

  procedure updatenumbers;
  begin
    bitnum:=curbit;
    if frmbit.bitnamestartsfrom1.Checked then inc(bitnum);

    bytenum:=curbit div 8;
    if frmbit.bytenamestartsfrom1.Checked then inc(bytenum);

    wordnum:=curbit div 16;
    if frmbit.Wordnamestartsfrom1.Checked then inc(wordnum);
  end;

  function GetNewTagBitName:String;
  var
    n:String;
  begin
    n:=IntToStr(bitnum);
    Result:=frmbit.edtNamepattern.Text;
    Result := StringReplace(Result,'%b',n,[rfReplaceAll]);

    n:=IntToStr(bytenum);
    Result := StringReplace(Result,'%B',n,[rfReplaceAll]);

    n:=IntToStr(wordnum);
    Result := StringReplace(Result,'%w',n,[rfReplaceAll]);

    n:=(Sender as TS7TagItemEditor).TagName;
    Result := StringReplace(Result,'%t',n,[rfReplaceAll]);
  end;
begin
  if not (Sender is TS7TagItemEditor) then exit;

  s7tageditor := (Sender as TS7TagItemEditor);

  frmbit:=TfrmBitMapper.Create(Self);
  try
    if frmbit.ShowModal=mrOk then begin
      startbit:=31-frmbit.StringGrid1.Selection.Right;
      endbit:=31-frmbit.StringGrid1.Selection.Left;
      curbit:=startbit;
      if frmbit.eachbitastag.Checked then begin
        while curbit<=endbit do begin
          updatenumbers;
          ti:=s7tageditor.AddBit;
          ti.TagName:=GetNewTagBitName;
          ti.EndBit:=curbit;
          ti.StartBit:=curbit;
          inc(curbit);
        end;
      end else begin
        updatenumbers;
        ti:=s7tageditor.AddBit;
        ti.TagName:=GetNewTagBitName;
        ti.EndBit:=endbit;
        ti.StartBit:=startbit;
      end;
    end;
  finally
    frmbit.Destroy;
  end;
end;

destructor TfrmS7TagBuilder.Destroy;
var
  t,b:Integer;
begin
  for t:=TagList.Count-1 downto 0 do begin
    for b:=0 to TS7TagItemEditor(TagList.Items[t]).BitCount-1 do begin
      TS7TagItemEditor(TagList.Items[t]).DelBit(b);
    end;
    TS7TagItemEditor(TagList.Items[t]).Destroy;
    TagList.Delete(t);
  end;
  TagList.Destroy;
  ItemsToDel.Destroy;
  inherited Destroy;
end;

procedure TfrmS7TagBuilder.CheckNames(Sender:TObject; NewName:String; var AcceptNewName:Boolean);
var
  t,b:Integer;
begin
  for t:=0 to TagList.Count-1 do begin
    if TagList.Items[t]=Sender then continue;
    if TS7TagItemEditor(TagList.Items[t]).TagName=NewName then begin
      AcceptNewName:=false;
      exit;
    end;
    for b:=0 to TS7TagItemEditor(TagList.Items[t]).BitCount-1 do begin
      if TS7TagItemEditor(TagList.Items[t]).Bit[b]=Sender then continue;
      if TTagBitItemEditor(TS7TagItemEditor(TagList.Items[t]).Bit[b]).TagName=NewName then begin
        AcceptNewName:=false;
        exit;
      end;
    end;
  end;
end;

function TfrmS7TagBuilder.GetStructItemsCount:Integer;
begin
  Result:=TagList.Count;
end;

function TfrmS7TagBuilder.GetStructItem(index:Integer):TS7TagItemEditor;
begin
  Result:=TS7TagItemEditor(TagList.Items[index]);
end;

procedure TfrmS7TagBuilder.Timer1Timer(Sender: TObject);
var
  c:Integer;
begin
  for c:=ItemsToDel.Count-1 downto 0 do begin
    TagList.Remove(ItemsToDel.Items[c]);
    TS7TagItemEditor(ItemsToDel.Items[c]).Destroy;
    ItemsToDel.Delete(c);
  end;
  Timer1.Enabled:=false
end;

procedure TfrmS7TagBuilder.TabSheet1Show(Sender: TObject);
begin
  btnBack.Enabled:=false;
  btnFinish.Enabled:=false;
  btnNext.Enabled:=true;
end;

procedure TfrmS7TagBuilder.PageControl1Change(Sender: TObject);
begin
  if (MemoryArea.ItemIndex in [0..1]) and (PageControl1.ActivePage<>TabSheet2) and (PageControl1.ActivePage<>TabSheet1) then begin
    PageControl1.ActivePage:=OldPage;
    exit;
  end;

  if (MemoryArea.ItemIndex in [2..3]) and (PageControl1.ActivePage<>TabSheet4) and (PageControl1.ActivePage<>TabSheet1) then begin
    PageControl1.ActivePage:=OldPage;
    exit;
  end;

  if (MemoryArea.ItemIndex in [4..5]) and (PageControl1.ActivePage<>TabSheet3) and (PageControl1.ActivePage<>TabSheet1) then begin
    PageControl1.ActivePage:=OldPage;
    exit;
  end;
end;

procedure TfrmS7TagBuilder.BlockTypeChange(Sender: TObject);
begin
  if BlockType.ItemIndex in [0..2] then begin
    BlockSwapBytes.Checked:=false;
    BlockSwapWords.Checked:=false;
    BlockSwapBytes.Enabled:=false;
    BlockSwapWords.Enabled:=false;
  end;
  if BlockType.ItemIndex in [3..4] then begin
    BlockSwapBytes.Checked:=true;
    BlockSwapWords.Checked:=false;
    BlockSwapBytes.Enabled:=true;
    BlockSwapWords.Enabled:=false;
  end;
  if BlockType.ItemIndex in [5..7] then begin
    BlockSwapBytes.Checked:=true;
    BlockSwapWords.Checked:=true;
    BlockSwapBytes.Enabled:=true;
    BlockSwapWords.Enabled:=true;
  end;
end;

procedure TfrmS7TagBuilder.btnNextClick(Sender: TObject);
begin
  case MemoryArea.ItemIndex of
    0..1:
      PageControl1.ActivePage:=TabSheet2;
    2..3:
      PageControl1.ActivePage:=TabSheet4;
    4..5:
      PageControl1.ActivePage:=TabSheet3;
  end;
end;

procedure TfrmS7TagBuilder.TabSheet3Show(Sender: TObject);
begin
  btnBack.Enabled:=true;
  btnFinish.Enabled:=true;
  btnNext.Enabled:=false;

  CTStartAddressChange(Sender);
end;

procedure TfrmS7TagBuilder.TabSheet4Show(Sender: TObject);
begin
  btnBack.Enabled:=true;
  btnFinish.Enabled:=true;
  btnNext.Enabled:=false;
end;

procedure TfrmS7TagBuilder.btnBackClick(Sender: TObject);
begin
  PageControl1.ActivePage:=TabSheet1;
end;

procedure TfrmS7TagBuilder.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  OldPage:=PageControl1.ActivePage;
end;

{$IFDEF FPC }
  {$IF defined(FPC) AND (FPC_FULLVERSION < 20400) }
initialization
  {$i us7tagbuilder.lrs}
  {$IFEND}
{$ENDIF}

end.