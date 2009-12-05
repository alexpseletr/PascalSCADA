{:
  @abstract(Escala definida pelo usu�rio.)
  @author(Fabio Luis Girardi <papelhigienico@gmail.com>)
}
unit UserScale;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes, ValueProcessor;

type
   //: Evento chamado para processar valores.
   TScaleEvent = procedure(Sender:TObject; const Input:Double; var Output:Double) of object;
   {:
   @abstract(Classe para processamento de escalas personalizaveis pelo usu�rio.)
   @author(Fabio Luis Girardi <papelhigienico@gmail.com>)
   }
   TUserScale = class(TScaleProcessor)
   private
     PPLCToUser:TScaleEvent;
     PUserToPLC:TScaleEvent;
   public
     {:
     @seealso(TScaleProcessor.SetInGetOut)
     @seealso(OnPLCToUser)
     }
     function SetInGetOut(Sender:TComponent; Entrada:Double):Double; override;
     {:
     @seealso(TScaleProcessor.SetOutGetIn)
     @seealso(OnUserToPLC)
     }
     function SetOutGetIn(Sender:TComponent; Saida:Double):Double; override;
   published
     {:
     Evento chamado atrav�s da fun��o SetInGetOut para o usu�rio fazer sua escala
     customizada no sentido Equipamento -> Usu�rio.
     
     Os parametros do evento correspondem aos seguintes paramestros da fun��o
     SetSetInGetOut:
     
     Sender => Sender da fun��o
     
     Input  => Entrada da fun��o
     
     Output => Resultado da fun��o.
     
     }
     property OnPLCToUser:TScaleEvent read PPLCToUser write PPLCToUser;
     {:
     Evento chamado atrav�s da fun��o SetOutGetIn para o usu�rio fazer sua escala
     customizada no sentido Usu�rio -> Equipamento.

     Os parametros do evento correspondem aos seguintes paramestros da fun��o
     SetSetInGetOut:

     Sender => Sender da fun��o

     Input  => Saida da fun��o

     Output => Resultado da fun��o.

     }
     property OnUserToPLC:TScaleEvent read PUserToPLC write PUserToPLC;
   end;

implementation

function TUserScale.SetInGetOut(Sender:TComponent; Entrada:Double):Double;
begin
  if Assigned(PPLCToUser) then begin
     Result := Entrada;
     PPLCToUser(Sender,Entrada,Result);
  end else
     Result := Entrada;
end;

function TUserScale.SetOutGetIn(Sender:TComponent; Saida:Double):Double;
begin
  if Assigned(PUserToPLC) then begin
     Result := Saida;
     PUserToPLC(Sender,Saida,Result);
  end else
     Result := Saida;
end;

end.
