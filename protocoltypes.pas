{:
  @abstract(Implementa tipos comuns para drivers de protocolos e tags.)
  @author(Fabio Luis Girardi <papelhigienico@gmail.com>)
}
unit ProtocolTypes;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface


uses Tag, variants;


type
  //: Array dinamico de valores flutuantes.
  TArrayOfDouble = array of double;
  //: Ponteiro para um array dinamico de pontos flutuantes.
  PArrayOfDouble = ^TArrayOfDouble;

  //: Array de objetos.
  TArrayOfObject = array of TObject;

  {:
  Enumera todos os poss�veis resultados de um pedido de leitura/escrita de um
  tag para um driver de protocolo (TProtocolDriver).
  
  @value(ioDriverError            Erro interno do driver.)
  @value(ioCommError              Erro de comunica��o.)
  @value(ioOk                     Comando com sucesso.)
  @value(ioTimeout                Timeout de comunica��o.)
  @value(ioIllegalFunction        Fun��o de IO inv�lida.)
  @value(ioIllegalRegAddress      O endereco da mem�ria � inv�lido.)
  @value(ioIllegalValue           O valor � inv�lido.)
  @value(ioPLCError               Erro no equipamento.)
  @value(ioTagError               Erro interno do Tag.)
  @value(ioNullDriver             Tag SEM DRIVER.)
  @value(ioIllegalStationAddress  Endere�o do equipamento � inv�lido.)
  }
  TProtocolIOResult = (ioNone, ioDriverError, ioCommError, ioOk, ioTimeOut,
                       ioIllegalFunction, ioIllegalRegAddress,ioIllegalValue,
                       ioPLCError, ioTagError, ioNullDriver,
                       ioIllegalStationAddress);

  {:
  Enumera os tipos de altera��es que um tag pode sofrer. Usado internamente
  pelos tags e drivers de protocolos (TProtocolDriver).
  
  @value(tcPLCHack           O tag teve a propriedade PLCHack alterada.)
  @value(tcPLCSlot           O tag teve a propriedade PLCSlot alterada.)
  @value(tcPLCStation        O tag teve a propriedade PLCStation alterada.)
  @value(tcMemFile_DB        O tag teve a propriedade MemFile_DB alterada.)
  @value(tcMemAddress        O tag teve a propriedade MemAddress alterada.)
  @value(tcMemSubElement     O tag teve a propriedade MemSubElement alterada.)
  @value(tcMemReadFunction   O tag teve a propriedade MemReadFunction alterada.)
  @value(tcMemWriteFunction  O tag teve a propriedade MemWriteFunction alterada.)
  @value(tcScanTime          O tag teve a propriedade RefreshTime alterada.)
  @value(tcSize              O tag teve a propriedade Size alterada (tags blocos).)
  @value(tcPath              O tag teve a propriedade LongAddress alterada.)
  }
  TChangeType = (tcPLCHack, tcPLCSlot, tcPLCStation, tcMemFile_DB, tcMemAddress,
                 tcMemSubElement, tcMemReadFunction, tcMemWriteFunction,
                 tcScanTime, tcSize, tcPath);
                 
  {:
  Enumera os poss�veis tipos de comandos aceitos pelo driver de protocolo (TProtocolDriver).
  
  @value(tcScanRead  Leitura de valor atrav�s do scan do driver de protocolo (assincrona).)
  @value(tcScanWrite Escrita de valor atrav�s do scan do driver de protocolo (assincrona).)
  @value(tcRead      Leitura de valor direta (sincrona).)
  @value(tcWrite     Escrita de valor direta (sincrona).)
  }
  TTagCommand = (tcScanRead, tcScanWrite, tcRead, tcWrite);

  {:
  Callback chamado pelo driver de protocolo (TProtocolDriver) para retornar o
  resultado de uma solicita��o e os respectivos valores.
  @param(Values TArrayOfDouble: Array com os valores lidos/escritos.)
  @param(ValuesTimeStamp TDateTime: Data/Hora em que esses valores foram lidos/escritos.)
  @param(TagCommand TTagCommand: Tipo de comando.)
  @param(LastResult TProtocolIOResult: Resultado do driver ao processar o pedido.)
  @param(Offset Cardinal: Posi��o dentro do bloco onde os valores come�am.)
  }
  TTagCommandCallBack = procedure(Values:TArrayOfDouble; ValuesTimeStamp:TDateTime; TagCommand:TTagCommand; LastResult:TProtocolIOResult; OffSet:Integer) of object;

  {:
  Estrutura usada internamente pelo driver de protocolo (TProtocoloDriver) para
  processar leitura por scan.
  @member Values Valores lidos pelo ScanRead.
  @member ValuesTimestamp Data/Hora dos valores lidos.
  @member ReadsOK N�mero de leituras com sucesso da area de mem�ria.
  @member ReadFaults N�mero de leituras com falha da area de mem�ria.
  @member LastQueryResult Resulado do �ltimo pedido de leitura.
  @member Offset Indice dentro do bloco.
  }
  TScanReadRec = record
    Values:TArrayOfDouble;
    ValuesTimestamp:TDateTime;
    ReadsOK,ReadFaults:Cardinal;
    LastQueryResult:TProtocolIOResult;
    Offset:Integer;
  end;
  PScanReadRec = ^TScanReadRec;

  {:
  Estrutura usada para notificar o driver de protocolo sobre altera��es nos tags.
  @member Tag Tag que est� sofrendo a mudan�a.
  @member Change Tipo de mudan�a.
  @member OldValue Valor antigo da propriedade alterada.
  @member NewValue Novo valor da proprieadade alterada.
  }
  TTagChangeRec = record
    Tag:TTag;
    Change:TChangeType;
    OldValue,NewValue:Cardinal
  end;
  //: Ponteiro de mudan�as de Tag.
  PTagChangeRec = ^TTagChangeRec;

  {:
  Estrutura usada internamente pelos drivers de protocolo (TProtocolDriver) para
  realizar leituras e escritas por Scan. Representa a configura��o do tag que
  est� sendo tratado.
  
  @member Hack Valor da propriedade PLCHack.
  @member Slot Valor da propriedade PLCSlot.
  @member Station Valor da propriedade PLCStation.
  @member File_DB Valor da propriedade MemFile_DB.
  @member Address Valor da propriedade MemAddress.
  @member SubElement Valor da propriedade MemSubElement.
  @member Size Valor da propriedade Size (Tags Blocos).
  @member OffSet Indice do bloco (Tags Blocos).
  @member Path Valor da propriedade LongAddress.
  @member ReadFunction Valor da propriedade MemReadFunction.
  @member WriteFunction Valor da propriedade MemWriteFunction.
  @member Retries Valor da propriedade Retries.
  @member ScanTime Valor da propriedade RefreshTime.
  @member CallBack Procedimento que ser� chamado quando o comando for completado.
  }
  TTagRec = record
    Hack:Integer;
    Slot:Integer;
    Station:Integer;
    File_DB:Integer;
    Address:Integer;
    SubElement:Integer;
    Size:Integer;
    OffSet:Integer;
    Path:String;
    ReadFunction:Integer;
    WriteFunction:Integer;
    Retries:Integer;
    ScanTime:Integer;
    CallBack:TTagCommandCallBack;
  end;
  //: Aponta para uma estrutura de Tag.
  PTagRec = ^TTagRec;
  
  {:
  Estrutura usada internamente pelos drivers de protocolo (TProtocolDriver) para
  realizar escritas por scan (assincronas).
  @member SWID Identifica��o do comando de escrita (n�mero �nico).
  @member Tag  Estrutura que cont�m as informa��es do Tag que ser� escrito.
  @member ValuesToWrite Array com os valores a serem escritos.
  @member WriteResult Resultado do comando de escrita.
  @member ValueTimeStamp Data/Hora em que os valores foram escritos.
  }
  TScanWriteRec = record
    SWID:Cardinal;
    Tag:TTagRec;
    ValuesToWrite:TArrayOfDouble;
    WriteResult:TProtocolIOResult;
    ValueTimeStamp:TDateTime;
  end;
  PScanWriteRec = ^TScanWriteRec;
  
  {:
  Define a fun��o respons�vel por executar uma escrita por Scan.
  @param(Tag TTagRec: estrutura que contem as informa��es do tag que vai ser escrito.)
  @param(values TArrayOfDouble: Array com os valores que devem ser escritos.)
  @returns(Todos os poss�veis retornos est�o definidos em TProtocolIOResult.)
  }
  TScanWriteProc = function(const Tag:TTagRec; const values:TArrayOfDouble):TProtocolIOResult of object;
  //: Ponteiro para uma fun��o de escrita por Scan.
  PScanWriteProc = ^TScanWriteProc;

  {:
  Define o procedimento respons�vel por executar leituras por Scan.
  @param(Sender TObject: thread do driver que est� realizando o scan..)
  @param(Sleep Integer: informa ao driver se ele deve dormir por um tempo, a fim
                        de liberar processador.)
  }
  TScanReadProc = procedure(Sender:TObject; var NeedSleep:Integer) of object;

  {:
  Define o procedimento respons�vel por buscar os valores de um tag.
  @param(Tag TTagRec: estrutura que contem as informa��es do tag que vai ser escrito.)
  @param(values TArrayOfDouble: Array onde ser�o retornados os valores do tag.)
  }
  TGetValues = procedure(const Tag:TTagRec; var values:TScanReadRec) of object;
  
  //: Interface comum a todos os tags.
  ITagInterface = interface
    ['{188FEF6D-036D-4B01-A854-421973AA7D58}']
    function  GetValueAsText(Prefix, Sufix, Format:string):String;
    function  GetVariantValue:Variant;
    procedure SetVariantValue(V:Variant);
    function  IsValidValue(Value:Variant):Boolean;
    function  GetValueTimestamp:TDatetime;
    property  ValueVariant:Variant read GetVariantValue write SetVariantValue;
    property  ValueTimestamp:TDatetime read GetValueTimestamp;
  end;

  //: Interface de tags num�ricos.
  ITagNumeric = interface(ITagInterface)
    ['{F15D0CCC-7C97-4611-A7F4-AD1BEAFA2C96}']
    function  GetValue:Double;
    procedure SetValue(v:Double);
    function  GetValueRaw:Double;
    procedure SetValueRaw(v:Double);

    property Value:Double read GetValue write SetValue;
    property ValueRaw:Double read GetValueRaw write SetValueRaw;
  end;

  //: Interface de tags de texto.
  ITagString = interface(ITagInterface)
    ['{D2CB0A30-B93B-4D8D-BD98-248AE9FC5F22}']
    function  GetValue:String;
    procedure SetValue(v:String);

    property Value:String read GetValue write SetValue;
  end;

const
  //: Constante de mensagem para adicionar um tag no scan.
  PSM_ADDTAG       =  200;

  //: Constante de mensagem para remover um tag do scan.
  PSM_DELTAG       =  201;

  //: Constante de mensagem para sinalizar mudan�as nas proprieadades do tag.
  PSM_TAGCHANGE    =  202;

  //: Constante de mensagem para suspens�o de thread sincronizada.
  PSM_PROTSUSPEND  =  203;

  //: Constante de mensagem para atualiza��o de tag.
  PSM_UPDATETAG    =  204;

  //: Constante de mensagem para leitura de tag por scan.
  PSM_TAGSCANREAD  =  205;

  //: Constante de mensagem para escrita de valores de tags por scan
  PSM_TAGSCANWRITE =  206;

implementation

end.
 
