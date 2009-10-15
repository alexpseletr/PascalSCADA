//: Define tipos usuais em controles de telas.
unit HMITypes;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  PLCTag;

type
  {:
  Define quando um valor deve ser escrito no Tag por um controle.
  @value(scLostFocus Quando o controle perde o foco.)
  @value(scPressEnter Quando � precionado a tecla enter.)
  @value(scPressESC Quando � precionado a tecla ESC.)
  @value(scAnyChange O valor � escrito no tag ap�s qualquer altera��o.)
  }
  TSendKind = (scLostFocus, scPressEnter, scPressESC, scAnyChange);
  {:
  Define o conjunto de a��es de escrita de valor de um controle no seu tag.
  @seealso(TSendKind)
  }
  TSendChange = set of TSendKind;
  {:
  Define como um controle booleano (CheckBox, RadioButton) deve interpretar
  valores que s�o verdadeiros e nem falsos.
  
  @value(isChecked o componente ir� aparecer marcado caso o valor do tag seja
  diferente de ValueFalse e ValueTrue.)

  @value(isUnchecked o componente ir� aparecer desmarcado caso o valor do tag
  seja diferente de ValueFalse e ValueTrue.)

  @value(isNone o componente n�o ir� mudar o seu estado caso o valor do tag
  seja diferente de ValueFalse e ValueTrue.)

  @value(IsGrayed o componente ir� aparecer acinzentado caso o valor do tag
  seja diferente de ValueFalse e ValueTrue.)
  }
  TOtherValues = (isChecked, isUnchecked, isNone, IsGrayed);

  {:
  Define os poss�veis tipos de bot�es.

  @value(btJog o bot�o ir� ficar precionado enquanto ele estiver precionado.)

  @value(btOnOff o bot�o fica precionado com um clique e com outro ele �
  liberado.)

  @value(btMomentary O bot�o fica precionado por alguns instantes e logo
  em seguinda liberado, mesmo que ele seja mantido precionado.)
  
  @value(btToogle O bot�o ir� inverter o valor do tag e manter a aparencia
  solta (n�o precionado).)
  }
  TButtonType = (btJog, btOnOff, btMomentary, btToogle);

  //: @name define a interface comum a todos os objetos de tela.
  IHMIInterface = interface
    ['{62FF1979-FA70-4965-B24F-347A69AC2EB1}']
    //: Procedimento que o TPLCTag ir� chamar para informar altera��es em seu valor.
    procedure HMINotifyChangeCallback(Sender:TObject);
    {:
    Procedimento que atualiza o componente de acordo com as regras atuais de
    seguran�a. � chamado quando um usu�rio faz login ou alguma regra de seguran�a
    � alterada.
    }
    procedure RefreshHMISecurity;
    //: For�a a remo��o da refer�ncia ao TPLCTag. Chamado quando o Tag est� sendo destruido.
    procedure RemoveHMITag(Sender:TObject);
    //: Seta o tag do controle, criando uma refer�ncia. @seealso(Tag)
    procedure SetHMITag(t:TPLCTag);
    //: Remove o tag do controle, eliminando a refer�ncia. @seealso(Tag)
    function  GetHMITag:TPLCTag;
    //: Informa se o controle est� habilitado. @seealso(Enabled)
    function  GetHMIEnabled:Boolean;
    //: Habilita/desabilita o controle. @seealso(Enabled)
    procedure SetHMIEnabled(v:Boolean);
    //: Propriedade criada para informar/setar o estado do controle atrav�s da interface.
    property  Enabled:Boolean read GetHMIEnabled write SetHMIEnabled;
    //: Propriedade criada para informar/setar o tag do controle atrav�s da interface.
    property  Tag:TPLCTag read GetHMITag write SetHMITag;
  end;

  IHMITagInterface = interface
    ['{4301B240-79D9-41F9-A814-68CFEFD032B8}']
    //: Chama o evento quando uma letura tem exito.
    procedure NotifyReadOk;
    //: Chama o evento quando uma leitura falha.
    procedure NotifyReadFault;
    //: Chama o evento quando uma escrita tem sucesso.
    procedure NotifyWriteOk;
    //: Chama o evento quando uma escrita do tag falha.
    procedure NotifyWriteFault;
    //: Chama o evento quando o valor do tag muda.
    procedure NotifyChange;
  end;

implementation

end.
