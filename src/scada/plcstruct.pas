{$i ../common/language.inc}
{$IFDEF PORTUGUES}
{:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)

  @abstract(Implementação de um tag estrutura de comunicação.)
}
{$ELSE}
{:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
  @abstract(Unit that implements a structure communication tag.)

  ****************************** History  *******************************
  ***********************************************************************
  07/2013 - Moved OpenElementMapper to StructTagAssistant to remove form dependencies
  @author(Juanjo Montero <juanjo.montero@gmail.com>)
  ***********************************************************************
}
{$ENDIF}
unit PLCStruct;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes, PLCBlock, Tag;

type
  {$IFDEF PORTUGUES}
  {:
    @author(Fabio Luis Girardi <fabio@pascalscada.com>)

    @abstract(Classe de tag estrutura de comunicação.)
  }
  {$ELSE}
  {:
    @author(Fabio Luis Girardi <fabio@pascalscada.com>)

    @abstract(Class of an structure communication tag.)
  }
  {$ENDIF}
  TPLCStruct = class(TPLCBlock)
  protected
    //: @seealso(TPLCTag.IsMyCallBack)
    function IsMyCallBack(Cback: TTagCommandCallBack): Boolean; override;
    //: @seealso(TPLCTag.TagCommandCallBack)
    procedure TagCommandCallBack(Values:TArrayOfDouble; ValuesTimeStamp:TDateTime; TagCommand:TTagCommand; LastResult:TProtocolIOResult; Offset:Integer); override;
    //: @seealso(TPLCTag.SetTagType)
    procedure SetTagType(newType:TTagType); override;
    //: @seealso(TPLCTag.SwapDWords)
    procedure SetSwapDWords(v:Boolean); override;
    //: @seealso(TPLCTag.SetSwapWords)
    procedure SetSwapWords(v:Boolean); override;
    //: @seealso(TPLCTag.SetSwapBytes)
    procedure SetSwapBytes(v:Boolean); override;
  public
    //: @xclude
    constructor Create(AOwner:TComponent); override;
  end;

implementation

uses sysutils;

constructor TPLCStruct.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Inherited SetTagType(pttByte);
end;


function TPLCStruct.IsMyCallBack(Cback: TTagCommandCallBack): Boolean;
begin
  Result:=inherited IsMyCallBack(Cback) and (TMethod(Cback).Code=@TPLCStruct.TagCommandCallBack);
end;

procedure TPLCStruct.TagCommandCallBack(Values:TArrayOfDouble; ValuesTimeStamp:TDateTime; TagCommand:TTagCommand; LastResult:TProtocolIOResult; Offset:Integer);
begin
  inherited TagCommandCallBack(Values, ValuesTimeStamp, TagCommand, LastResult, Offset);
end;

procedure TPLCStruct.SetTagType(newType:TTagType);
begin
  Inherited SetTagType(pttByte);
end;

procedure TPLCStruct.SetSwapDWords(v: Boolean);
begin
  inherited SetSwapDWords(false);
end;

procedure TPLCStruct.SetSwapWords(v:Boolean);
begin
  inherited SetSwapWords(false);
end;

procedure TPLCStruct.SetSwapBytes(v:Boolean);
begin
  inherited SetSwapBytes(false);
end;

end.
