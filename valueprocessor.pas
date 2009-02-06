//: Implementa��o de processadores de escala.
unit ValueProcessor;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, PLCTag;

type
  //: Classe base processadora de escalas.
  TScaleProcessor = class(TComponent)
  private
    FValueIn:Double;
    FPIPEItens:array of TCollectionItem;
    procedure SetInput(value:Double);
    function  GetOutput:Double;
    procedure SetOutput(value:Double);
    procedure DoExceptionIndexOut(index:Integer);
    function  GetProperty(index:Integer):Double;
    procedure SetProperty(index:Integer; Value:Double);
  protected
    //: Array que armazena o valor das propriedades;
    FProperts:array of Double;
  public
    //: @exclude
    constructor Create(AOwner:TComponent); override;
    //: @exclude
    destructor Destroy; override;
    //: Adiciona um dependente desse processador de escalas.
    procedure AddPIPEItem(PIPEItem:TCollectionItem);
    //: Remove um dependente desse processador de escalas.
    procedure DelPIPEItem(PIPEItem:TCollectionItem);
    {:
    Fornece um valor processado a partir de um valor puro em fun��o dos
    parametros da escala, se existirem.
    
    @bold(Geralmente � a informa��o no sentido Equipamento -> Usu�rio.)

    @param(Sender TComponent: Quem est� solicitando esse processamento.)
    @param(Input Double: Valor de entrada.)
    @returns(Double. Valor processado em fun��o dos parametros da escala.)
    }
    function SetInGetOut(Sender:TComponent; Input:Double):Double; virtual;
    {:
    Fornece um valor puro a partir de um valor processado em fun��o dos
    parametros da escala, se existirem.

    @bold(Geralmente � a informa��o no sentido Usu�rio -> Equipamento.)
    
    @param(Sender TComponent: Quem est� solicitando esse processamento.)
    @param(Output Double: Valor processado da qual se deseja obter um valor puro.)
    @returns(Double. Valor puro em fun��o dos parametros da escala.)
    }
    function SetOutGetIn(Sender:TComponent; Output:Double):Double; virtual;
    //: Retorna uma propriedade da escala da array de propriedades.
    property Propriedade[index:Integer]:Double read GetProperty write SetProperty;
  published
    {:
    Propriedade para testes da escala.

    Se for escrito em @name, o valor processado ser� entregue em OutPut.

    Se for escrito em OutPut, o valor processado ser� entregue em @name.
    
    @seealso(OutPut)
    }
    property Input:Double read FValueIn write SetInput Stored false;
    {:
    Propriedade para testes da escala.

    Se for escrito em @name, o valor processado ser� entregue em InPut.

    Se for escrito em InPut, o valor processado ser� entregue em @name.

    @seealso(Input)
    }
    property Output:Double read GetOutput write SetOutput Stored false;
  end;
  
  //: Implementa um item de uma cole��o de processadores de escala.
  TScalePIPEItem = class(TCollectionItem)
  private
    SProcessor:TScaleProcessor;
    procedure SetScaleProcessor(SP:TScaleProcessor);
  protected
    //: @exclude
    function  GetDisplayName: string; override;
  public
    {:
    Procedimento chamado para remover a dependencia de um objeto de escalas que
    est� sendo destroido.
    }
    procedure RemoveScaleProcessor;
    {:
    Repassa a chamada para o m�todo SetInGetOut do processador de escalas
    configurado em ScaleProcessor.
    
    @param(Sender TComponent: Objeto que solicitante.)
    @param(Input Double: Valor puro que ser� processado pela escala.)
    
    @returns(O valor processado pela escala associada em ScaleProcessor. Caso
    ScaleProcessor n�o tenha um objeto associado, retorna o valor passado
    em Input.)
    
    @seealso(TScaleProcessor.SetInGetOut)
    }
    function SetInGetOut(Sender:TComponent; Input:Double):Double;
    {:
    Repassa a chamada para o m�todo SetOutGetIn do processador de escalas
    configurado em ScaleProcessor.

    @param(Sender TComponent: Objeto que solicitante.)
    @param(Output Double: Valor processado que se deseja obter um valor puro.)
    
    @returns(O valor puro retornado pela escala associada em ScaleProcessor. Caso
    ScaleProcessor n�o tenha um objeto associado, retorna o valor passado
    em Output.)

    @seealso(TScaleProcessor.SetOutGetIn)
    }
    function SetOutGetIn(Sender:TComponent; Output:Double):Double;
  published
    //: Objeto de escalas respons�vel por fazer os processamentos desse item.
    property ScaleProcessor:TScaleProcessor read SProcessor write SetScaleProcessor;
  end;
  
  //: Implementa uma cole��o de processadores de escala.
  TScalePIPE = class(TCollection)
  public
    //: @exclude
    constructor Create;
    {:
    Adiciona um novo item de processamento de escalas a cole��o.
    @returns(O novo item da cole��o.)
    }
    function Add:TScalePIPEItem;
    {:
    Tranforma um valor puro (Entrada) em um valor processado pelas multiplas
    escalas pertencentes a cole��o (Saida).
    
    Para isso ele passa Input para o m�todo SetInGetOut do primeiro item da
    cole��o e o resultado ele repassa como parametro do pr�ximo item cole��o,
    repetindo isso at� atingir o fim da cole��o.
    
    @bold(Logo, o primeiro item da lista � primeiro a ser chamado quando o valor
    vem no sentido Equipamento -> Usu�rio assim como o �ltimo item da cole��o �
    primeiro a ser chamado quando o valor vai do Usu�rio -> Equipamento.)
    
    @param(Sender TComponent: Quem chamou esse processamento.)
    @param(Input Double: Valor puro a processar.)
    @returns(Retorna o valor processado em fun��o das escalas associadas aos
             itens da cole��o. Se n�o h� itens na cole��o ou se os itens dela n�o
             tiverem um processador de escala associado, Input � retornado.)
    @seealso(TScalePIPEItem.SetInGetOut)
    }
    function SetInGetOut(Sender:TComponent; Input:Double):Double;
    {:
    Tranforma um valor processado pelas multiplas escalas da cole��o (Saida) em
    um valor puro (Entrada).
    
    Para isso ele passa Output para o m�todo SetOutGetIn do �ltimo item da
    cole��o e o resultado ele repassa como parametro do item que o antecede,
    repetindo isso at� atingir o inicio da cole��o.
    
    @bold(Logo, o primeiro item da lista � primeiro a ser chamado quando o valor
    vem no sentido Equipamento -> Usu�rio assim como o �ltimo item da cole��o �
    primeiro a ser chamado quando o valor vai do Usu�rio -> Equipamento.)

    @param(Sender TComponent: Quem chamou esse processamento.)
    @param(Output Double: Valor processado da qual se deseja obter um valor puro.)
    @returns(Retorna o valor puro em fun��o das escalas associadas aos
             itens da cole��o. Se n�o h� itens na cole��o ou se os itens dela n�o
             tiverem um processador de escala associado, Output � retornado.)
    @seealso(TScalePIPEItem.SetOutGetIn)
    }
    function SetOutGetIn(Sender:TComponent; Output:Double):Double;
  end;
  
  //: Componente de enfileiramento de processadores de escala.
  TPIPE = class(TComponent)
  private
    FScalePIPE:TScalePIPE;
    FTags:array of TPLCTag;
    function  GetScalePIPE:TScalePIPE;
    procedure SetScalePIPE(ScalePIPE:TScalePIPE);
  public
    //: @exclude
    constructor Create(AOwner:TComponent); override;
    //: @exclude
    destructor  Destroy; override;
    //: Adiciona um tag como dependente dessa fila.
    procedure AddTag(tag:TPLCTag);
    //: Remove um tag como dependente dessa fila.
    procedure DelTag(tag:TPLCTag);
    //: @seealso(TScalePIPE.SetInGetOut)
    function SetInGetOut(Sender:TComponent; Input:Double):Double;
    //: @seealso(TScalePIPE.SetOutGetIn)
    function SetOutGetIn(Sender:TComponent; Output:Double):Double;
  published
    //: Cole��o de escalas.
    property Escalas:TScalePIPE read GetScalePIPE write SetScalePIPE stored true;
  end;
    
implementation

uses PLCNumber;

////////////////////////////////////////////////////////////////////////////////
// implementa��o de TScalePIPEItem
////////////////////////////////////////////////////////////////////////////////
procedure TScalePIPEItem.SetScaleProcessor(SP:TScaleProcessor);
begin
  if sp=SProcessor then exit;
  
  if SProcessor<>nil then
     SProcessor.DelPIPEItem(self);

  if SP<>nil then
     SP.AddPIPEItem(self);

  DisplayName:=SP.Name;
  SProcessor := SP;
end;

function TScalePIPEItem.GetDisplayName: string;
begin
   if SProcessor<>nil then
      Result := SProcessor.Name
   else
      Result := 'Dummy';
end;

function TScalePIPEItem.SetInGetOut(Sender:TComponent; Input:Double):Double;
begin
  if SProcessor<>nil then
     Result := SProcessor.SetInGetOut(Sender,Input)
  else
     Result := Input;
end;

function TScalePIPEItem.SetOutGetIn(Sender:TComponent; Output:Double):Double;
begin
  if SProcessor<>nil then
     Result := SProcessor.SetOutGetIn(Sender,Output)
  else
     Result := Output;
end;

procedure TScalePIPEItem.RemoveScaleProcessor;
begin
  SProcessor := nil;
end;

////////////////////////////////////////////////////////////////////////////////
// implementa��o de TScalePIPE
////////////////////////////////////////////////////////////////////////////////

constructor TScalePIPE.Create;
begin
  inherited Create(TScalePIPEItem);
end;

function TScalePIPE.Add:TScalePIPEItem;
begin
   Result := TScalePIPEItem(inherited Add)
end;

function TScalePIPE.SetInGetOut(Sender:TComponent; Input:Double):Double;
var
  c:Integer;
begin
  Result := Input;
  for c:=0 to Count-1 do
    if GetItem(c) is TScalePIPEItem then
       Result := TScalePIPEItem(GetItem(c)).SetInGetOut(Sender,Result);
end;

function TScalePIPE.SetOutGetIn(Sender:TComponent; Output:Double):Double;
var
  c:Integer;
begin
  Result := Output;
  for c:=(Count-1) downto 0 do
    if GetItem(c) is TScalePIPEItem then
       Result := TScalePIPEItem(GetItem(c)).SetOutGetIn(Sender,Result);
end;

////////////////////////////////////////////////////////////////////////////////
// implementa��o de TPIPE
////////////////////////////////////////////////////////////////////////////////

constructor TPIPE.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FScalePIPE := TScalePIPE.Create;
end;

destructor  TPIPE.Destroy;
begin
  FScalePIPE.Destroy;
  inherited Destroy;
end;

function  TPIPE.GetScalePIPE:TScalePIPE;
begin
  Result := FScalePIPE;
end;

procedure TPIPE.SetScalePIPE(ScalePIPE:TScalePIPE);
begin
  FScalePIPE.Assign(ScalePIPE);
end;

procedure TPIPE.AddTag(tag:TPLCTag);
var
  found:Boolean;
  c:Integer;
begin
  if not (tag is TPLCNumber) then
    raise Exception.Create('Tipo do Tag inv�lido!');

  found := false;
  for c:=0 to High(FTags) do
    if FTags[c]=Tag then begin
      found := true;
      break;
    end;

  if not found  then begin
    c:=Length(FTags);
    SetLength(FTags,c+1);
    FTags[c]:=Tag;
  end;
end;

procedure TPIPE.DelTag(tag:TPLCTag);
var
  found:Boolean;
  c,h:Integer;
begin
  found := false;
  h:=High(FTags);
  for c:=0 to h do
    if FTags[c]=Tag then begin
      found := true;
      break;
    end;

  if found then begin
    FTags[c]:=FTags[h];
    SetLength(FTags,h);
  end;
end;

function TPIPE.SetInGetOut(Sender:TComponent; Input:Double):Double;
begin
   Result := FScalePIPE.SetInGetOut(Sender,Input);
end;

function TPIPE.SetOutGetIn(Sender:TComponent; Output:Double):Double;
begin
   Result := FScalePIPE.SetOutGetIn(Sender, Output);
end;

////////////////////////////////////////////////////////////////////////////////
// implementa��o de TScaleProcessor
////////////////////////////////////////////////////////////////////////////////
constructor TScaleProcessor.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  SetLength(FProperts,8);
end;

destructor TScaleProcessor.Destroy;
var
  c:Integer;
begin
  SetLength(FProperts,0);
  for c:=0 to High(FPIPEItens) do
    TScalePIPEItem(FPIPEItens[c]).RemoveScaleProcessor;
  SetLength(FPIPEItens,0);
  inherited Destroy;
end;

procedure TScaleProcessor.AddPIPEItem(PIPEItem:TCollectionItem);
var
  found:Boolean;
  c:Integer;
begin
  if not (PIPEItem is TScalePIPEItem) then
    raise Exception.Create('Tipo inv�lido!');

  found := false;
  for c:=0 to High(FPIPEItens) do
    if FPIPEItens[c]=PIPEItem then begin
      found := true;
      break;
    end;

  if not found  then begin
    c:=Length(FPIPEItens);
    SetLength(FPIPEItens,c+1);
    FPIPEItens[c]:=PIPEItem;
  end;
end;

procedure TScaleProcessor.DelPIPEItem(PIPEItem:TCollectionItem);
var
  found:Boolean;
  c,h:Integer;
begin
  found := false;
  h:=High(FPIPEItens);
  for c:=0 to h do
    if FPIPEItens[c]=PIPEItem then begin
      found := true;
      break;
    end;

  if found then begin
    FPIPEItens[c]:=FPIPEItens[h];
    SetLength(FPIPEItens,h);
  end;
end;

function TScaleProcessor.SetInGetOut(Sender:TComponent; Input:Double):Double;
begin
  Result := Input;
end;

function TScaleProcessor.SetOutGetIn(Sender:TComponent; Output:Double):Double;
begin
  Result := Output;
end;

function  TScaleProcessor.GetProperty(index:Integer):Double;
begin
  DoExceptionIndexOut(index);
  Result := FProperts[index];
end;

procedure TScaleProcessor.SetInput(value:Double);
begin
  FValueIn := value;
end;

procedure TScaleProcessor.SetOutput(value:Double);
begin
  FValueIn := SetOutGetIn(self, value);
end;

function  TScaleProcessor.GetOutput:Double;
begin
  Result := SetInGetOut(self, FValueIn);
end;

procedure TScaleProcessor.SetProperty(index:Integer; Value:Double);
begin
  DoExceptionIndexOut(index);
  FProperts[index] := Value;
end;

procedure TScaleProcessor.DoExceptionIndexOut(index:Integer);
begin
  if (index<0) or (index>=Length(FProperts)) then
    raise Exception.Create('Fora dos limites da array!');
end;


end.
