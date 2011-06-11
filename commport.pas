{$IFDEF PORTUGUES}
{:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
  @abstract(Unit que implementa as bases de um driver de porta de comunicação)
}
{$ELSE}
{:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
  @abstract(Unit that implements the basis of a communication port driver)
}
{$ENDIF}
unit CommPort;

{$IFDEF FPC}
{$mode delphi}
{$IFDEF DEBUG}
  {$DEFINE FDEBUG}
{$ENDIF}
{$ENDIF}

interface

uses
  Commtypes, Classes, MessageSpool, CrossEvent, SyncObjs, ExtCtrls
  {$IFNDEF FPC}, Windows{$ENDIF};

type
  {$IFDEF PORTUGUES}
  {:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
  @name é responsável por notificar a aplicação e os drivers sobre erros de
  comunicação, abertura, fechamento e desconecção de uma porta de comunicação.
  É usado internamente por TCommPortDriver.
  }
  {$ELSE}
  {:
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
  @name notifies the application and protocol drivers when the following events
  occurs on port driver: communication error and when it was open, closed or disconnected.
  This class is used internaly by the TCommPortDriver.
  }
  {$ENDIF}
  TEventNotificationThread = class(TCrossThread)
  private
    PMsg:TMSMsg;
    FOwner:TComponent;
    FEvent:Pointer;
    FError:TIOResult;
    FDoSomethingEvent,
    FInitEvent:TCrossEvent;
    FSpool:TMessageSpool;
    procedure DoSomething;
    procedure WaitToDoSomething;

    procedure SyncCommErrorEvent;
    procedure SyncPortEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; AOwner:TComponent);
    destructor  Destroy; override;
    procedure   WaitInit;
    procedure   Terminate;
    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de erro de comunicação para a aplicação;
    {$ELSE}
    //: Sends a communication error message to application;
    {$ENDIF}
    procedure DoCommErrorEvent(Event:TCommPortErrorEvent; Error:TIOResult);
    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de evento porta aberta, fechada e disconectada para aplicação;
    {$ELSE}
    //: Sends a port event message (port open, closed or diconnected) to application;
    {$ENDIF}
    procedure DoCommPortEvent(Event:TNotifyEvent);
  end;

  {$IFDEF PORTUGUES}
  {:
  @abstract(Classe base de drivers de portas de comunicação)

  @author(Fabio Luis Girardi <fabio@pascalscada.com>)

  Esta classe foi criada com o intuito de diminuir os esforços na criação de
  drivers de portas de comunicações tanto no modo mono-tarefa (single thread) quanto
  no modo multi-tarefa (threads).

  As poucas partes a serem escritas é sobreescrever de cinco métodos virtuais que
  fazem todo o trabalho (e é lógico as rotinas das propriedades e demais funções
  de comunicação da sua porta). São eles:

  @code(function  ComSettingsOK:Boolean; virtual;)
  Sobrescreva a função para verificar se todas as propriedades de sua porta
  de comunicação estão certas. Retorne @true caso estejam.

  @code(procedure PortStart(var Ok:Boolean); virtual;)
  Abra a porta e retorne @true caso consiga abrir a porta de comunicação.

  @code(procedure PortStop(var Ok:Boolean); virtual;)
  Feche a porta e retorne @true caso consiga fechar a porta de comunicação.

  @code(procedure Read(Packet:PIOPacket); virtual; abstract;)
  Sobrescreva este método para poder executar as funções de leitura de sua porta de comunicação.

  @code(procedure Write(Packet:PIOPacket); virtual; abstract;)
  Sobrescreva este método para poder escrever dados na sua porta de comunicação.

  Feito isso, sua porta já é thread-safe!
  }
  {$ELSE}
  {:
  @abstract(The base class of an communication port driver.)

  @author(Fabio Luis Girardi <fabio@pascalscada.com>)

  This class was created to reduce the efforts to create new communication port
  drivers, both on single-thread and multi-threads environments.

  To make a minimal usable communication port driver, you must overwrite only
  five virtual methods that do all work (don't forget of the
  properties/procedures/functions particular of your communication port). The
  methods that you must overwrite are this:

  @code(function  ComSettingsOK:Boolean; virtual;)
  Overwrite this function to check if the setting of your communication port are
  rigth.

  @code(procedure PortStart(var Ok:Boolean); virtual;)
  Opens the communication port. If it was open successfully, return true on OK variable.

  @code(procedure PortStop(var Ok:Boolean); virtual;)
  Closes the communication port. If it was closed successfully, return true on OK variable.

  @code(procedure Read(Packet:PIOPacket); virtual; abstract;)
  Overwrite this method to read data of your communication port.

  @code(procedure Write(Packet:PIOPacket); virtual; abstract;)
  Overwrite this method to write data on your communication port.

  After do this, your communication port already is thread-safe!
  }
  {$ENDIF}
  TCommPortDriver = class(TComponent)
  private
    FLogActions,
    FReadedLogActions:Boolean;
    FLogFile:String;
    FLogFileStream:TFileStream;
    { @exclude }
    PLockedBy:Cardinal;
    {: @exclude }
    PPacketID:Cardinal;
    {: @exclude }
    FReadActive:Boolean;
    {: @exclude }
    PEventUpdater:TEventNotificationThread;
    {: @exclude }
    PIOCmdCS, PLockCS:TCriticalSection;
    {: @exclude }
    PLockEvent:TCrossEvent;
    {: @exclude }
    PUnlocked:Integer;
    {: @exclude }
    FLastOSErrorNumber:Integer;
    {: @exclude }
    FLastOSErrorMessage:String;
    {: @exclude }
    FTimer:TTimer;
    {: @exclude }
    FLastPkgId:Cardinal;
    {: @exclude }
    FCommandsSecond:Integer;

    {$IFDEF PORTUGUES}
    //: Estatisticas de comunicação (total de bytes enviados/recebitos e bytes enviados/recebidos por segundo).
    {$ELSE}
    //: Communication statistics (bytes sent/received and bytes sent/received per second).
    {$ENDIF}
    FTXBytes,
    FRXBytes,
    FTXBytesLast,
    FRXBytesLast,
    FTXBytesSecond,
    FRXBytesSecond:Int64;

    FOwnerThread:TPSThreadID;

    {$IFDEF PORTUGUES}
    //: Abertura forcada da porta em edicao
    {$ELSE}
    //: Opens the communication port in design time
    {$ENDIF}
    FOpenInEditMode:Boolean;

    //: @exclude
    FOnCommErrorReading:TCommPortErrorEvent;
    //: @exclude
    FOnCommErrorWriting:TCommPortErrorEvent;
    //: @exclude
    FOnCommPortOpened,
    FOnCommPortOpenError:TNotifyEvent;
    //: @exclude
    FOnCommPortClosed,
    FOnCommPortCloseError:TNotifyEvent;
    //: @exclude
    FOnCommPortDisconnected:TNotifyEvent;

    procedure OpenInEditMode(v:Boolean);

    {$IFDEF PORTUGUES}
    //: Atualiza as estatisticas de comunicação.
    {$ELSE}
    //: Updates the communication statistics.
    {$ENDIF}
    procedure TimerStatistics(Sender:TObject);
    {: @exclude }
    function GetLocked:Boolean;
    {: @exclude }
    procedure SetActive(v:Boolean);

    {$IFDEF PORTUGUES}
    //: Executa um comandos de IO (thread-safe).
    {$ELSE}
    //: Executes IO commands (thread-safe).
    {$ENDIF}
    procedure InternalIOCommand(cmd:TIOCommand; Packet:PIOPacket);

    {$IFDEF PORTUGUES}
    //: Abre a porta de comunicação (thread-safe).
    {$ELSE}
    //: Opens the communication port (thread-safe).
    {$ENDIF}
    procedure InternalPortStart(var Ok:Boolean);

    {$IFDEF PORTUGUES}
    //: Fecha a porta de comunicação (thread-safe).
    {$ELSE}
    //: Closes the communication port (thread-safe).
    {$ENDIF}
    procedure InternalPortStop(var Ok:Boolean);
    {$IFDEF PORTUGUES}
    {:
    @name é o metodo chamado para realizar as leituras/escritas do driver.

    @param(cmd TIOCommand. Informa os comandos de Leitura/escrita e sua ordem)
    @param(Packet PIOPacket. Aponta para uma estrutura TIOPacket que contem os valores a
           a serem escritos e os valores lidos.)
    @return(Retorna em Packet os valores lidos.)
    }
    {$ELSE}
    {:
    @name is called to do the I/O tasks of the communication port driver.

    @param(cmd TIOCommand. Contains the I/O commands and the sequence of your execution.)
    @param(Packet PIOPacket. Record that contains the information about what
           must be readed and/or write.)
    @return(Returns on variable Packet the result of the I/O's actions.)
    }
    {$ENDIF}
    procedure IOCommand(cmd:TIOCommand; Packet:PIOPacket);

    //: @seealso(TCommPortDriver.LogIOActions)
    procedure  SetLogActions(Log:Boolean);

    //: @seealso(TCommPortDriver.LogFile)
    procedure  SetLogFile(nFile:String);

    {$IFDEF PORTUGUES}
    //: Registra uma ação de IO no log de comunicações.
    {$ELSE}
    //: Register an IO action on communications log.
    {$ENDIF}
    procedure  LogAction(cmd:TIOCommand; Packet:TIOPacket);
  protected
    FDelayBetweenCmds:Cardinal;

    {$IFDEF PORTUGUES}
    //: Armazena se a porta é de uso exclusivo (como a porta serial)
    {$ELSE}
    //: Stores if the communication port is exclusive (like serial port)
    {$ENDIF}
    FExclusiveDevice:Boolean;
    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de erro de comunicação de uma thread para a aplicação
    {$ELSE}
    //: Send a communication error message from the thread to the application.
    {$ENDIF}
    procedure CommError(WriteCmd:Boolean; Error:TIOResult);

    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de porta aberta para a aplicação/thread de protocolo.
    {$ELSE}
    //: Sends a message to the application/protocol thread when the communication port was open.
    {$ENDIF}
    procedure CommPortOpened;

    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de falha na abertura da porta para a aplicação/thread de protocolo.
    {$ELSE}
    //: Sends a message to the application/protocol thread, if communication port can't be open.
    {$ENDIF}
    procedure CommPortOpenError;

    {$IFDEF PORTUGUES}
    //: Envia uma mensagem informando que a porta foi fechada para a aplicação/thread de protocolo.
    {$ELSE}
    //: Sends a message to the application/protocol thread when the communication port was close.
    {$ENDIF}
    procedure CommPortClose;

    {$IFDEF PORTUGUES}
    //: Envia uma mensagem informando falha fechando a porta de comunicação para a aplicação/thread de protocolo.
    {$ELSE}
    //: Sends a message to the application/protocol thread, if the communication port can't be closed.
    {$ENDIF}
    procedure CommPortCloseError;

    {$IFDEF PORTUGUES}
    //: Envia uma mensagem de porta desconectada para o aplicação/ thread de protocolo (TCP/IP).
    {$ELSE}
    //: Sends a message to the application/protocol thread, if the communication port was disconnected (TCP/IP).
    {$ENDIF}
    procedure CommPortDisconected;


    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário a respeito de um erro de leitura
    {$ELSE}
    //: Notifies the OnCommErrorReading event about an read error.
    {$ENDIF}
    procedure DoReadError(Error:TIOResult); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário a respeito de um erro de escrita
    {$ELSE}
    //: Notifies the OnCommErrorWriting event about an write error.
    {$ENDIF}
    procedure DoWriteError(Error:TIOResult); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário quando a porta é aberta com sucesso.
    {$ELSE}
    //: Notifies the OnCommPortOpened when the communication port opens.
    {$ENDIF}
    procedure DoPortOpened(sender:TObject); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário a respeito de uma falha abrindo a porta
    {$ELSE}
    //: Notifies the OnCommPortOpenError event if a error occurs when opening communication port.
    {$ENDIF}
    procedure DoPortOpenError(sender:TObject); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário quando a porta é fechada com sucesso.
    {$ELSE}
    //: Notifies the OnCommPortClosed event when the communication port was closed.
    {$ENDIF}
    procedure DoPortClose(sender:TObject); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário a respeito de uma falha fechando a porta.
    {$ELSE}
    //: Notifies the OnCommPortCloseError event if a error occurs when closing communication port.
    {$ENDIF}
    procedure DoPortCloseError(sender:TObject); virtual;

    {$IFDEF PORTUGUES}
    //: Notifica o evento do usuário a respeito de uma perca de conexão.
    {$ELSE}
    //: Notifies the OnCommPortDisconnected event when a connection is lost (usefull in TCP/IP)
    {$ENDIF}
    procedure DoPortDisconnected(sender:TObject); virtual;
  protected
    {$IFDEF PORTUGUES}
    //: Variável responsável por armazenar o estado atual do driver
    {$ELSE}
    //: Stores the actual state of the communication port driver (Open or closed);
    {$ENDIF}
    PActive:Boolean;

    {$IFDEF PORTUGUES}
    {: Variável responsável por armazenar se devem ser feitas limpezas após algum erro de comunicação }
    {$ELSE}
    //: Stores if the buffers must be cleared after some communication error.
    {$ENDIF}
    PClearBufOnErr:Boolean;

    {$IFDEF PORTUGUES}
    {:
    Array que armazena os drivers de protocolo dependentes.
    @seealso(TProtocolDriver)
    }
    {$ELSE}
    {:
    Array that stores what's protocols uses this communication port driver.
    @seealso(TProtocolDriver)
    }
    {$ENDIF}
    Protocols:array of TComponent;

    {$IFDEF PORTUGUES}
    {:
    Array que armazena as notificações que deve fornecer aos protocolos.
    @seealso(TProtocolDriver)
    }
    {$ELSE}
    {:
    Array que armazena os drivers de protocolo dependentes.
    @seealso(TProtocolDriver)
    }
    {$ENDIF}
    EventInterfaces:IPortDriverEventNotificationArray;

    {$IFDEF PORTUGUES}
    {:
    Método chamado quando é necessário ler dados da porta. É necessário
    sobrescrever este método para criar novos drivers de porta.
    @param(Packet PIOPacket. Contem as informações necessárias para executar
           a leitura).
    @seealso(TIOPacket)
    }
    {$ELSE}
    {:
    Procedure called when is needed to read something on communication port.
    To create a new communication port, you must overwritten this procedure.
    @param(Packet PIOPacket. Record with informations to execute the read
           command.).
    @seealso(TIOPacket)
    }
    {$ENDIF}
    procedure Read(Packet:PIOPacket); virtual; abstract;

    {$IFDEF PORTUGUES}
    {:
    Método chamado quando é necessário escrever dados na porta. É necessário
    sobrescrever este método para criar novos drivers de porta.
    @param(Packet PIOPacket. Contem as informações necessárias para executar
           a escrita).
    @seealso(TIOPacket)
    }
    {$ELSE}
    {:
    Procedure called when is needed to write something on communication port.
    To create a new communication port, you must overwritten this procedure.
    @param(Packet PIOPacket. Record with informations to execute the write
           command.).
    @seealso(TIOPacket)
    }
    {$ENDIF}
    procedure Write(Packet:PIOPacket); virtual; abstract;

    {$IFDEF PORTUGUES}
    {:
    @name deve ser sobrescrito em portas que desejam oferecer uma espera entre
    os comandos de leitura e escrita.
    }
    {$ELSE}
    {:
    @name must be overwritten on communication ports that want's a delay between
    the read and write commands.
    }
    {$ENDIF}
    procedure NeedSleepBetweenRW; virtual; abstract;

    {$IFDEF PORTUGUES}
    {:
    @name é o metodo chamado para realizar a abertura da porta.
    Para a criação de novos drivers, esse método precisa ser sobrescrito.

    @return(Retorne @true em Ok caso a porta tenha sido aberta com sucesso. @false caso contrário)
    @seealso(TDriverCommand)
    }
    {$ELSE}
    {:
    @name is called to opens the communication port. To create a new communication
    port driver, this procedure must be overwritten.

    @return(Returns @true in Ok param if the communication port was opened sucessfull.)
    @seealso(TDriverCommand)
    }
    {$ENDIF}
    procedure PortStart(var Ok:Boolean); virtual; abstract;

    {$IFDEF PORTUGUES}
    {:
    @name é o metodo chamado para fechar uma porta.
    Para a criação de novos drivers, esse método precisa ser sobrescrito.

    @return(Retorne @true em Ok caso a porta tenha sido fechada com sucesso. @false caso contrário)
    @seealso(TDriverCaller)
    }
    {$ELSE}
    {:
    @name is called to closes the communication port. To create a new communication
    port driver, this procedure must be overwritten.

    @return(Returns @true in Ok param if the communication port was closed sucessfull.)
    @seealso(TDriverCommand)
    }
    {$ENDIF}
    procedure PortStop(var Ok:Boolean); virtual; abstract;

    {$IFDEF PORTUGUES}
    {:
    @name é o metodo chamado para validar o conjunto de configurações de uma porta.
    Para a criação de novos drivers, se essa função não for sobrescrita, todas
    as combinações de configurações serão inválidas e a porta não será aberta.

    @return(Retorne @true caso as configurações da porta estejam Ok. @false caso contrário)
    @seealso(TDriverCaller)
    }
    {$ELSE}
    {:
    @name is called to check if the communication port settings are right. To
    create a new communication port driver, if this function was not overwritten,
    all combinations of settings will be invalidated and the communication port
    will not open.

    @return(Returns @true if the communication port settings are right. @false if not.)
    @seealso(TDriverCaller)
    }
    {$ENDIF}
    function  ComSettingsOK:Boolean; virtual;

    {$IFDEF PORTUGUES}
    {:
    @name é o método responsável por fazer a limpeza dos buffers de leitura/escrita
    da porta.
    É altamente recomendável você escrever esse método caso esteja criando um novo
    driver de porta.
    }
    {$ELSE}
    {:
    @name is called when is needed clear the input/output buffers of the
    communication port.

    Is recommended overwriten this procedure on your communication port driver.
    }
    {$ENDIF}
    procedure ClearALLBuffers; virtual; abstract;
    {: @exclude }
    procedure Loaded; override;
    {: @exclude }
    procedure InternalClearALLBuffers;

    {$IFDEF PORTUGUES}
    {: @name gera uma exceção caso a porta esteja ativa. Use este método para
       evitar a mudança de valores de certas propriedade que não podem ser
       alterados com a porta ativa.
    }
    {$ELSE}
    {: @name raises an exception if the communication port is active. Call this
       procedure to avoid changes in properties that cannot be changed with the
       communication port activated.
    }
    {$ENDIF}
    procedure DoExceptionInActive;

    {$IFDEF PORTUGUES}
    {:
      @name atualiza as propriedades LastOSErrorNumber e LastOSErrorMessage com
      o último erro registrado pelo sistema operacional.
    }
    {$ELSE}
    {:
      @name refresh the properties LastOSErrorNumber and LastOSErrorMessage with
      the last OS error.
    }
    {$ENDIF}
    procedure RefreshLastOSError;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando uma falha de leitura ocorre na porta de comunicação.
    {$ELSE}
    //: Event called when a read error occurs on communication port.
    {$ENDIF}
    property OnCommErrorReading:TCommPortErrorEvent read FOnCommErrorReading write FOnCommErrorReading;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando uma falha de escrita ocorre na porta de comunicação.
    {$ELSE}
    //: Event called when a write error occurs on communication port.
    {$ENDIF}
    property OnCommErrorWriting:TCommPortErrorEvent read FOnCommErrorWriting write FOnCommErrorWriting;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando a porta é aberta
    {$ELSE}
    //: Event called when the communication port was open.
    {$ENDIF}
    property OnCommPortOpened:TNotifyEvent read FOnCommPortOpened write FOnCommPortOpened;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando ocorre uma falha na abetura da porta.
    {$ELSE}
    //: Event called when the communication was not open successfully.
    {$ENDIF}
    property OnCommPortOpenError:TNotifyEvent read FOnCommPortOpenError write FOnCommPortOpenError;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando a porta é fechada.
    {$ELSE}
    //: Event called when the communication port was closed.
    {$ENDIF}
    property OnCommPortClosed:TNotifyEvent read FOnCommPortClosed write FOnCommPortClosed;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando ocorre uma falha na fechando a porta.
    {$ELSE}
    //: Event called when the communication was not closed successfully.
    {$ENDIF}
    property OnCommPortCloseError:TNotifyEvent read FOnCommPortCloseError write FOnCommPortCloseError;

    {$IFDEF PORTUGUES}
    //: Evento chamado quando a porta é desconectada devido a algum erro.
    {$ELSE}
    //: Event called when the communication port has been disconected.
    {$ENDIF}
    property OnCommPortDisconnected:TNotifyEvent read FOnCommPortDisconnected write FOnCommPortDisconnected;
  public

    {$IFDEF PORTUGUES}
    {:
    Cria o driver de porta, inicializando todas as threads e variaveis internas.
    }
    {$ELSE}
    {:
    Creates the communication port, initializing threads and internal variables.
    }
    {$ENDIF}
    constructor Create(AOwner:TComponent); override;

    {$IFDEF PORTUGUES}
    {:
    Destroi o driver de porta, fechando e informando a todos os drivers de
    protocolo dependentes sobre a destruição, consequentemente a eliminação da
    referência com este driver de porta.
    @seealso(TProtocolDriver)
    @seealso(AddProtocol)
    @seealso(DelProtocol)
    }
    {$ELSE}
    {:
    Destroys the communication port, closing and removing all references of protocols to it.
    @seealso(TProtocolDriver)
    @seealso(AddProtocol)
    @seealso(DelProtocol)
    }
    {$ENDIF}
    destructor Destroy; override;

    {$IFDEF PORTUGUES}
    {:
    Adiciona um driver de protocolo a lista de dependentes
    @param(Prot TProtocolDriver. Driver de protocolo a ser adicionado como dependente)
    @raises(Exception caso Prot não seja descendente de TProtocolDriver)
    @seealso(TProtocolDriver)
    }
    {$ELSE}
    {:
    Adds a protocol driver as a dependent of the communicaton port.
    @param(Prot TProtocolDriver. Protocol driver to be added as a dependent.)
    @raises(Exception if the Prot is not a TProtocolDriver.)
    @seealso(TProtocolDriver)
    }
    {$ENDIF}
    procedure AddProtocol(Prot:TComponent);

    {$IFDEF PORTUGUES}
    {:
    Remove um driver de protocolo a lista de dependentes
    @param(Prot TProtocolDriver. Driver de protocolo a ser removido da lista de
           dependentes.)
    @seealso(TProtocolDriver)
    }
    {$ELSE}
    {:
    Removes a protocol driver of the list of dependents.
    @param(Prot TProtocolDriver. Protocol driver to be removed of the dependents
           list.)
    @seealso(TProtocolDriver)
    }
    {$ENDIF}
    procedure DelProtocol(Prot:TComponent);

    {$IFDEF PORTUGUES}
    {:
    Faz um pedido de leitura/escrita sincrono para o driver (sua aplicação espera
    todo o comando terminar para continuar).
    @param(Cmd TIOCommand. Informa a combinação de comandos de leitura/escrita a
           executar)
    @param(ToWrite BYTES. Conteudo que deseja escrever)
    @param(BytesToRead Cardinal. Informa o número de @noAutoLink(bytes) que deverão ser lidos)
    @param(BytesToWrite Cardinal. Informa o número de @noAutoLink(bytes) a serem escritos)
    @param(DelayBetweenCmds Cardinal. Tempo em milisegundos entre comandos de
           leitura e escrita)
    @param(CallBack TDriverCallBack. Procedimento que será chamado para retorno
           dos dados lidos/escritos)
    @param(Res1 TObject. Objeto que será passado como parametro ao callback.)
    @param(Res2 Pointer. Pointeiro que será passado como parametro ao callback.)
    @return(Retorna o ID do pacote caso tenha exito. Retorna 0 (zero) caso o
            componente esteja sendo destruido ou a porta não esteja aberta.)
    @seealso(TIOCommand)
    @seealso(BYTES)
    @seealso(TDriverCallBack)
    @seealso(IOCommandASync)
    }
    {$ELSE}
    {:
    Do a synchronous I/O request to the communication port (blocks your
    application until this action is done).
    @param(Cmd TIOCommand. The sequence of I/O to be executed.)
    @param(ToWrite BYTES. Data to be written on the communication port)
    @param(BytesToRead Cardinal. Number of @noAutoLink(bytes) to be read on communication port.)
    @param(BytesToWrite Cardinal. Number of @noAutoLink(bytes) to be written on communication port.)
    @param(DelayBetweenCmds Cardinal. Delay in milliseconds between the commands of read and write.)
    @param(CallBack TDriverCallBack. Procedure called to return the data of the
           I/O command (with the write result and the bytes received).)
    @param(Res1 TObject. Object to be passed to callback.)
    @param(Res2 Pointer. Pointer to be passed to callback.)
    @return(Returns the I/O command ID. Returns 0 if the communication port has
            been destroied or if the communication port is closed.)
    @seealso(TIOCommand)
    @seealso(BYTES)
    @seealso(TDriverCallBack)
    @seealso(IOCommandASync)
    }
    {$ENDIF}
    function IOCommandSync(Cmd:TIOCommand; ToWrite:BYTES; BytesToRead,
                           BytesToWrite, DriverID, DelayBetweenCmds:Cardinal;
                           CallBack:TDriverCallBack;
                           Res1:TObject; Res2:Pointer):Cardinal;


    {$IFDEF PORTUGUES}
    {:
    Trava a porta para uso exclusivo
    @param(DriverID Cardinal. Identifica quem deseja obter uso exclusivo.)
    @returns(@true caso o função trave o driver para uso exclusivo, @false para o contrário)
    }
    {$ELSE}
    {:
    Locks the communication port for exclusive use.
    @param(DriverID Cardinal. Identifies who wants exclusive access.)
    @returns(@true if the communicaton port was locked, @false if not.)
    }
    {$ENDIF}
    function Lock(DriverID:Cardinal):Boolean;
    

    {$IFDEF PORTUGUES}
    {:
    Remove a exclusividade de uso do driver de porta, deixando a porta para ser usada
    livremente por todos.
    @param(DriverID Cardinal. Identifica quem tem exclusividade sobre o driver.)
    @returns(@true caso consiga remover o uso exclusivo do driver.)
    }
    {$ELSE}
    {:
    Remove the exclusive access on communication port.
    @param(DriverID Cardinal. Identifies who has the exclusive access on communication port.)
    @returns(@true if the communication port was released to be used on non-exclusive access.)
    }
    {$ENDIF}
    function Unlock(DriverID:Cardinal):Boolean;

    {$IFDEF PORTUGUES}
    {:
    Retorna verdadeiro se a porta está realmente aberta.
    }
    {$ELSE}
    {:
    Return true if the communication port is open really.
    }
    {$ENDIF}
    function ReallyActive:Boolean;
  published

    {$IFDEF PORTUGUES}
    //: Abre (caso @true) ou fecha (caso @false) a porta de comunicação.
    {$ELSE}
    //: Opens (@true) or close (@false) the communication port.
    {$ENDIF}
    property Active:Boolean read PActive write SetActive stored true default false;

    {$IFDEF PORTUGUES}
    //:Caso @true, limpa os buffers de leitura e escrita quando houver erros de comunicação.
    {$ELSE}
    //:If @true, clears the input/output buffers of communication port if an I/O error has been found.
    {$ENDIF}
    property ClearBuffersOnCommErrors:Boolean read PClearBufOnErr write PClearBufOnErr default true;

    {$IFDEF PORTUGUES}
    //:Informa o ID (número único) de quem travou para uso exclusivo o driver de porta.
    {$ELSE}
    //:Identification of who have exclusive access on communication port.
    {$ENDIF}
    property LockedBy:Cardinal read PLockedBy;

    {$IFDEF PORTUGUES}
    //:Caso @true, informa que o driver está sendo usado exclusivamente por alguem.
    {$ELSE}
    //:Returns @true if the communication port was locked for exclusive access.
    {$ENDIF}
    property Locked:Boolean read GetLocked;

    {$IFDEF PORTUGUES}
     //: Informa o codigo do último erro registrado pelo sistema operacional.
    {$ELSE}
    //: The last error code registered by the OS.
    {$ENDIF}
    property LastOSErrorNumber:Integer read FLastOSErrorNumber;

    {$IFDEF PORTUGUES}
    //: Informa a mensagem do último erro registrado pelo sistema operacional.
    {$ELSE}
    //: The last error message registered by the OS.
    {$ENDIF}
    property LastOSErrorMessage:String read FLastOSErrorMessage;

    {$IFDEF PORTUGUES}
    //: Informa quantos comandos são processados por segundos. Atualizado a cada 1 segundo.
    {$ELSE}
    //: How many I/O commands are processed by second. Updated every 1 second.
    {$ENDIF}
    property CommandsPerSecond:Integer read FCommandsSecond;

    {$IFDEF PORTUGUES}
    //: Total de @noAutoLink(bytes) transmitidos.
    {$ELSE}
    //: Total of @noAutoLink(bytes) sent (written).
    {$ENDIF}
    property TXBytes:Int64 read FTXBytes;

    {$IFDEF PORTUGUES}
    //: Total de @noAutoLink(bytes) transmitidos no último segundo.
    {$ELSE}
    //: Total of @noAutoLink(bytes) sent on the last second.
    {$ENDIF}
    property TXBytesSecond:Int64 read FTXBytesSecond;

    {$IFDEF PORTUGUES}
    //: Total de @noAutoLink(bytes) recebidos.
    {$ELSE}
    //: Total of @noAutoLink(bytes) received (received).
    {$ENDIF}
    property RXBytes:Int64 read FRXBytes;

    {$IFDEF PORTUGUES}
    //: Total de @noAutoLink(bytes) recebidos no último segundo.
    {$ELSE}
    //: Total of @noAutoLink(bytes) received on the last second.
    {$ENDIF}
    property RXBytesSecond:Int64 read FRXBytesSecond;

    {$IFDEF PORTUGUES}
    //: Habilita/desabilita o log de ações de leitura e escrita do driver
    {$ELSE}
    //: Enable/disables the log of I/O actions of the communication port.
    {$ENDIF}
    property LogIOActions:Boolean read FLogActions write SetLogActions default false;

    {$IFDEF PORTUGUES}
    //: Arquivo onde serão armazenados os logs do driver.
    {$ELSE}
    //: File to store the log of I/O actions of the communication port.
    {$ENDIF}
    property LogFile:String read FLogFile write SetLogFile;
  end;

{$IFNDEF FPC}
const
  LineEnding = #13#10;
{$ENDIF}

implementation

uses SysUtils, ProtocolDriver, hsstrings;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  THREAD DE NOTIFICAÇÃO DE EVENTOS DE COMUNICAÇÃO.
//  THREAD OF NOTIFICATION OF COMMUNICATION EVENTS.
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

constructor TEventNotificationThread.Create(CreateSuspended: Boolean; AOwner:TComponent);
begin
  inherited Create(CreateSuspended);
  FOwner:=AOwner;
  FSpool:=TMessageSpool.Create;
  FDoSomethingEvent:=TCrossEvent.Create(nil,true,false,'DoSomethingEventThread'+IntToStr(UniqueID));
  FInitEvent:=TCrossEvent.Create(nil,true,false,'WasInitialized'+IntToStr(UniqueID));
end;

destructor TEventNotificationThread.Destroy;
begin
  inherited Destroy;
  FDoSomethingEvent.Destroy;
  FSpool.Destroy;
end;

procedure TEventNotificationThread.WaitInit;
begin
  if FInitEvent.WaitFor($FFFFFFFF)<>wrSignaled then
    raise Exception.Create(SUpdateThreadWinit);
end;

procedure TEventNotificationThread.DoSomething;
begin
  FDoSomethingEvent.SetEvent;
end;

procedure TEventNotificationThread.WaitToDoSomething;
begin
  FDoSomethingEvent.WaitFor(1);
  FDoSomethingEvent.ResetEvent;
end;

procedure TEventNotificationThread.Terminate;
begin
  inherited Terminate;
  DoSomething;
end;

procedure TEventNotificationThread.Execute;
begin
  FInitEvent.SetEvent;
  while not Terminated do begin
    try
      WaitToDoSomething;
      while FSpool.PeekMessage(PMsg,PSM_COMMERROR,PSM_PORT_EVENT,true) do begin
        case PMsg.MsgID of
          PSM_COMMERROR:
          begin
            FEvent:=PMsg.wParam;
            FError:=TIOResult(PMsg.lParam);
            Synchronize(SyncCommErrorEvent);
            Dispose(PCommPortErrorEvent(FEvent));
          end;
          PSM_PORT_EVENT:begin
            FEvent:=PMsg.wParam;
            Synchronize(SyncPortEvent);
            Dispose(PNotifyEvent(FEvent));
          end;
        end;
      end;
    except
      on e:Exception do begin
        {$IFDEF FDEBUG}
        DebugLn('Exception in UpdateThread: '+ E.Message);
        DumpStack;
        {$ENDIF}
      end;
    end;
  end;
end;

procedure TEventNotificationThread.DoCommErrorEvent(Event:TCommPortErrorEvent; Error:TIOResult);
var
  p:PCommPortErrorEvent;
begin
  new(p);
  p^:=Event;
  FSpool.PostMessage(PSM_COMMERROR, p, Pointer(Error),false);
  DoSomething;
end;

procedure TEventNotificationThread.DoCommPortEvent(Event:TNotifyEvent);
var
  p:PNotifyEvent;
begin
  new(p);
  p^:=Event;
  FSpool.PostMessage(PSM_PORT_EVENT,p,nil,false);
  DoSomething;
end;

procedure TEventNotificationThread.SyncCommErrorEvent;
var
  ievt:TCommPortErrorEvent;
begin
  if FEvent=nil then exit;
  try
    ievt:=TCommPortErrorEvent(FEvent^);
    ievt(FError);
  finally
  end;
end;

procedure TEventNotificationThread.SyncPortEvent;
var
  ievt:TNotifyEvent;
begin
  if FEvent=nil then exit;
  try
    ievt:=TNotifyEvent(FEvent^);
    ievt(FOwner);
  finally
  end;
end;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  DECLARAÇÃO DO COMPONENTE PORTA DE COMUNICAÇÃO
//  CODE OF THE BASE OF COMMUNICATION PORT DRIVER CLASS.
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

constructor TCommPortDriver.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FOwnerThread:=GetCurrentThreadId;
  FExclusiveDevice:=false;
  FTimer := TTimer.Create(Self);
  FTimer.OnTimer:=TimerStatistics;
  FTimer.Enabled:=false;
  FTimer.Interval:=1000;
  FLastOSErrorMessage:='';
  FLastOSErrorNumber:=0;
  PIOCmdCS := TCriticalSection.Create;
  PLockCS  := TCriticalSection.Create;
  PLockEvent := TCrossEvent.Create(nil,True,True,Name);
  PUnlocked:=0;
  PClearBufOnErr := true;

  PEventUpdater:=TEventNotificationThread.Create(true, Self);
  PEventUpdater.Resume;
  PEventUpdater.WaitInit;
end;

destructor TCommPortDriver.Destroy;
var
  c:Integer;
begin
  for c:=0 to High(Protocols) do
    TProtocolDriver(Protocols[c]).CommunicationPort := nil;
  for c:=0 to High(EventInterfaces) do
    EventInterfaces[c].DoPortRemoved(self);
  PEventUpdater.Terminate;
  PEventUpdater.Destroy;
  Active := false;
  SetLength(Protocols,0);
  PIOCmdCS.Destroy;
  PLockCS.Destroy;
  PLockEvent.Destroy;
  FTimer.Destroy;
  inherited Destroy;
end;

procedure TCommPortDriver.AddProtocol(Prot:TComponent);
var
  c:Integer;
  found, interfaced:Boolean;
begin
  interfaced := Supports(Prot,IPortDriverEventNotification);
  if not interfaced then
    if not (Prot is TProtocolDriver) then
      raise Exception.Create(SCompIsntADriver);

  found := false;
  if interfaced then begin
    for c:=0 to High(EventInterfaces) do
      if EventInterfaces[c]=(Prot as IPortDriverEventNotification) then begin
        found := true;
        break;
      end;
  end else begin
    for c:=0 to High(Protocols) do
      if Protocols[c]=Prot then begin
        found := true;
        break;
      end;
  end;

  if not found then begin
    if interfaced then begin
      c:=length(EventInterfaces);
      SetLength(EventInterfaces,c+1);
      EventInterfaces[c] := (Prot as IPortDriverEventNotification);
    end else begin
      c:=length(Protocols);
      SetLength(Protocols,c+1);
      Protocols[c] := Prot;
    end;
  end;
end;

procedure TCommPortDriver.DelProtocol(Prot:TComponent);
var
  found, interfaced:Boolean;
  c:Integer;
begin
  interfaced := Supports(Prot,IPortDriverEventNotification);
  found := false;
  if interfaced then begin
    for c:=0 to High(EventInterfaces) do
      if EventInterfaces[c]=(Prot as IPortDriverEventNotification) then begin
        found := true;
        break;
      end;
  end else begin
    for c:=0 to High(Protocols) do
      if Protocols[c]=Prot then begin
        found := true;
        break;
      end;
  end;

  if found then begin
    if interfaced then begin
      EventInterfaces[c] := EventInterfaces[High(EventInterfaces)];
      SetLength(EventInterfaces,High(EventInterfaces));
    end else begin
      Protocols[c] := Protocols[High(Protocols)];
      SetLength(Protocols,High(Protocols));
    end;
  end;
end;

function  TCommPortDriver.ComSettingsOK:Boolean;
begin
   Result:=false;
end;

procedure TCommPortDriver.IOCommand(cmd:TIOCommand; Packet:PIOPacket);
begin
  if csDestroying in ComponentState then
     exit;

  FDelayBetweenCmds:=Packet.DelayBetweenCommand;
  case cmd of
    iocRead:
      Read(Packet);
    iocReadWrite:
      begin
        Read(Packet);
        NeedSleepBetweenRW;
        Write(Packet);
      end;
    iocWrite:
      Write(Packet);
    iocWriteRead:
      begin
        Write(Packet);
        NeedSleepBetweenRW;
        Read(Packet);
      end;
  end;
  FRXBytes := FRXBytes + Packet.Received;
  FTXBytes := FTXBytes + Packet.Written;
end;

procedure TCommPortDriver.CommError(WriteCmd:Boolean; Error:TIOResult);
var
  evt:TCommPortErrorEvent;
begin
  if FOwnerThread=GetCurrentThreadId then begin
    try
      if WriteCmd then begin
        DoWriteError(Error);
      end else begin
        DoReadError(Error);
      end;
    finally
    end;
  end else begin
    if WriteCmd then begin
      evt := DoWriteError
    end else begin
      evt := DoReadError;
    end;

    if Assigned(evt) then
      PEventUpdater.DoCommErrorEvent(evt,Error);
  end;
end;

procedure TCommPortDriver.CommPortOpened;
var
  c:Integer;
begin
  if [csDestroying]*ComponentState<>[] then exit;

  if GetCurrentThreadId=FOwnerThread then begin
    try
      DoPortOpened(Self);
    finally
    end;
    for c:=0 to High(EventInterfaces) do
      if ntePortOpen in EventInterfaces[c].NotifyThisEvents then
        EventInterfaces[c].DoPortOpened(Self);
  end else begin
    PEventUpdater.DoCommPortEvent(DoPortOpened);
    for c:=0 to High(EventInterfaces) do
      if ntePortOpen in EventInterfaces[c].NotifyThisEvents then
        PEventUpdater.DoCommPortEvent(EventInterfaces[c].GetPortOpenedEvent);
  end;
end;

procedure TCommPortDriver.CommPortOpenError;
begin
  if [csDestroying]*ComponentState<>[] then exit;

  if GetCurrentThreadId=FOwnerThread then
    try
      DoPortOpenError(Self);
    finally
    end
  else
    PEventUpdater.DoCommPortEvent(DoPortOpenError);
end;

procedure TCommPortDriver.CommPortClose;
var
  c:Integer;
begin
  if [csDestroying]*ComponentState<>[] then exit;

  if GetCurrentThreadId=FOwnerThread then begin
    try
      DoPortClose(Self);
    finally
    end;
    for c:=0 to High(EventInterfaces) do
      if ntePortClosed in EventInterfaces[c].NotifyThisEvents then
        EventInterfaces[c].DoPortClosed(Self);
  end else begin
    PEventUpdater.DoCommPortEvent(DoPortClose);
    for c:=0 to High(EventInterfaces) do
      if ntePortClosed in EventInterfaces[c].NotifyThisEvents then
        PEventUpdater.DoCommPortEvent(EventInterfaces[c].GetPortClosedEvent);
  end;
end;

procedure TCommPortDriver.CommPortCloseError;
begin
  if [csDestroying]*ComponentState<>[] then exit;

  if GetCurrentThreadId=FOwnerThread then
    try
      DoPortCloseError(Self);
    finally
    end
  else
    PEventUpdater.DoCommPortEvent(DoPortCloseError);
end;

procedure TCommPortDriver.CommPortDisconected;
var
  c:Integer;
begin
  if [csDestroying]*ComponentState<>[] then exit;

  if GetCurrentThreadId=FOwnerThread then begin
    try
      DoPortDisconnected(Self);
    finally
    end;
    for c:=0 to High(EventInterfaces) do
      if ntePortDisconnected in EventInterfaces[c].NotifyThisEvents then
        EventInterfaces[c].DoPortDisconnected(Self);
  end else begin
    PEventUpdater.DoCommPortEvent(DoPortDisconnected);
    for c:=0 to High(EventInterfaces) do
      if ntePortDisconnected in EventInterfaces[c].NotifyThisEvents then
        PEventUpdater.DoCommPortEvent(EventInterfaces[c].GetPortDisconnectedEvent);
  end;
end;

procedure TCommPortDriver.DoReadError(Error:TIOResult);
begin
  if Assigned(FOnCommErrorReading) then
    FOnCommErrorReading(Error);
end;

procedure TCommPortDriver.DoWriteError(Error:TIOResult);
begin
  if Assigned(FOnCommErrorWriting) then
    FOnCommErrorWriting(Error);
end;

procedure TCommPortDriver.DoPortOpened(sender:TObject);
begin
  if Assigned(FOnCommPortOpened) then
    FOnCommPortOpened(sender);
end;

procedure TCommPortDriver.DoPortOpenError(sender:TObject);
begin
  if Assigned(FOnCommPortOpenError) then
    FOnCommPortOpenError(sender);
end;

procedure TCommPortDriver.DoPortClose(sender:TObject);
begin
  if Assigned(FOnCommPortClosed) then
    FOnCommPortClosed(sender);
end;

procedure TCommPortDriver.DoPortCloseError(sender:TObject);
begin
  if Assigned(FOnCommPortCloseError) then
    FOnCommPortCloseError(sender);
end;

procedure TCommPortDriver.DoPortDisconnected(sender:TObject);
begin
  if Assigned(FOnCommPortDisconnected) then
    FOnCommPortDisconnected(sender);
end;

procedure TCommPortDriver.Loaded;
begin
  inherited Loaded;
  SetActive(FReadActive);
  SetLogActions(FReadedLogActions);
end;

procedure TCommPortDriver.TimerStatistics(Sender:TObject);
begin
  FCommandsSecond:= PPacketID - FLastPkgId;
  FTXBytesSecond := FTXBytes  - FTXBytesLast;
  FRXBytesSecond := FRXBytes  - FRXBytesLast;

  FRXBytesLast := FRXBytes;
  FTXBytesLast := FTXBytes;
  FLastPkgId  := PPacketID;
end;

function TCommPortDriver.GetLocked:Boolean;
begin
  Result := (PLockedBy<>0);
end;

function TCommPortDriver.Lock(DriverID:Cardinal):Boolean;
begin
  try
    PLockCS.Enter;
    if PLockedBy=0 then begin
      PLockedBy := DriverID;
      PLockEvent.ResetEvent;
      Result := true;
    end else
      Result := false;
  finally
    PLockCS.Leave;
  end;

  //espera todos acabarem seus comandos.
  //waits everyone finish their commands.
  while PUnlocked>0 do
    {$IFDEF FPC}
    ThreadSwitch;
    {$ELSE}
    SwitchToThread;
    {$ENDIF}

end;

function TCommPortDriver.Unlock(DriverID:Cardinal):Boolean;
begin
  try
    PLockCS.Enter;
    if (PLockedBy=0) or (DriverID=PLockedBy) then begin
      PLockedBy := 0;
      PLockEvent.SetEvent;
      Result := true;
    end else
      Result := false;
  finally
    PLockCS.Leave;
  end;
end;

function TCommPortDriver.ReallyActive:Boolean;
begin
  if [csDesigning]*ComponentState<>[] then begin
    if FExclusiveDevice then begin
      Result:=false;
    end else begin
      Result:=PActive;
    end;
  end else
    Result:=PActive;
end;

procedure TCommPortDriver.SetActive(v:Boolean);
var
   x:boolean;
begin
  //se esta carregando as propriedades
  //if it is being loading.
  if csReading in ComponentState then begin
    FReadActive := v;
    exit;
  end;

  //evita a abertura/fechamento da porta em edição, quando um dispositivo
  //e de uso exclusivo (porta serial).
  //
  //avoid the open/close of communication port in design-time if the communication
  //port is exclusive (like a serial port)
  if FExclusiveDevice and (csDesigning in ComponentState) then begin
    if v then begin
      if ComSettingsOK then begin
        PActive := true;
      end;
    end else begin
      PActive := false;
    end;
    exit;
  end;

  if v and (not PActive) then begin
     InternalPortStart(x);
  end;
  
  if (not v) and PActive then begin
     InternalPortStop(x);
  end;
  FTimer.Enabled := PActive;
end;

procedure TCommPortDriver.OpenInEditMode(v:Boolean);
begin

end;

function TCommPortDriver.IOCommandSync(Cmd:TIOCommand; ToWrite:BYTES; BytesToRead,
                                 BytesToWrite, DriverID, DelayBetweenCmds:Cardinal;
                                 CallBack:TDriverCallBack;
                                 Res1:TObject; Res2:Pointer):Cardinal;
var
  PPacket:TIOPacket;
  InLockCS, InIOCmdCS:Boolean;
begin
  try
    InLockCS:=false;
    InIOCmdCS:=false;

    Result := 0;

    if (csDestroying in ComponentState) or (FExclusiveDevice and (csDesigning in ComponentState)) then
       exit;

    //verify if another driver is the owner of the comm port...
    PLockCS.Enter;
    InLockCS:=true;
    while (PLockedBy<>0) and (PLockedBy<>DriverID) do begin
       PLockCS.Leave;
       InLockCS:=false;
       PLockEvent.WaitFor($FFFFFFFF);
       PLockCS.Enter;
       InLockCS:=true;
    end;
    InterLockedIncrement(PUnlocked);
    PLockCS.Leave;
    InLockCS:=false;

    PIOCmdCS.Enter;
    InIOCmdCS:=true;
    if (not PActive) then
       exit;

    inc(PPacketID);

    //cria o pacote
    //creates de command packet.
    PPacket.PacketID := PPacketID;
    PPacket.WriteIOResult := iorNone;
    PPacket.ToWrite := BytesToWrite;
    PPacket.Written := 0;
    PPacket.WriteRetries := 3;

    PPacket.BufferToWrite := ToWrite;

    PPacket.DelayBetweenCommand := DelayBetweenCmds;
    PPacket.ReadIOResult := iorNone;
    PPacket.ToRead := BytesToRead;
    PPacket.Received := 0;
    PPacket.ReadRetries := 3;
    PPacket.Res1 := Res1;
    PPacket.Res2 := Res2;
    SetLength(PPacket.BufferToRead,BytesToRead);

    //executes the I/O command.
    InternalIOCommand(Cmd,@PPacket);
    if Assigned(CallBack) then
      CallBack(PPacket);

    //free the buffers
    SetLength(PPacket.BufferToWrite,0);
    SetLength(PPacket.BufferToRead, 0);

    //return the command ID.
    Result := PPacketID;
  finally
    if InIOCmdCS then
      PIOCmdCS.Leave;
    if InLockCS then
      PLockCS.Leave;
    InterLockedDecrement(PUnlocked);
  end;
end;

procedure TCommPortDriver.InternalIOCommand(cmd:TIOCommand; Packet:PIOPacket);
begin
  try
     PIOCmdCS.Enter;
     //verify if the communication port is active.
     if PActive then begin
       try
         //executes the I/O command.
         IOCommand(cmd,Packet);
       except
         if cmd in [iocRead, iocReadWrite, iocWriteRead] then
           Packet^.ReadIOResult := iorPortError;
         if cmd in [iocWrite, iocReadWrite, iocWriteRead] then
           Packet^.WriteIOResult := iorPortError;
       end;
     end else begin
       if cmd in [iocRead, iocReadWrite, iocWriteRead] then
         Packet^.ReadIOResult := iorNotReady;
       if cmd in [iocWrite, iocReadWrite, iocWriteRead] then
         Packet^.WriteIOResult := iorNotReady;
     end;
     if FLogActions then
       LogAction(cmd, Packet^);
  finally
     PIOCmdCS.Leave;
  end;
end;

procedure TCommPortDriver.InternalPortStart(var Ok:Boolean);
begin
  try
     PIOCmdCS.Enter;
     PortStart(ok);
     RefreshLastOSError;
     if Ok then
       CommPortOpened
     else
       CommPortOpenError;
  finally
     PIOCmdCS.Leave;
  end;
end;

procedure TCommPortDriver.InternalPortStop(var Ok:Boolean);
begin
  try
     PIOCmdCS.Enter;
     PortStop(ok);
     RefreshLastOSError;
     if Ok then
       CommPortClose
     else
       CommPortCloseError;
  finally
     PIOCmdCS.Leave;
  end;
end;

procedure TCommPortDriver.InternalClearALLBuffers;
begin
  try
     PIOCmdCS.Enter;
     ClearALLBuffers;
  finally
     PIOCmdCS.Leave;
  end;
end;

procedure TCommPortDriver.DoExceptionInActive;
begin
  if PActive then begin
    if (ComponentState*[csDesigning]=[]) or ((ComponentState*[csDesigning]<>[]) and FExclusiveDevice=false) then
      raise Exception.Create(SimpossibleToChangeWhenActive);
  end;
end;

procedure TCommPortDriver.RefreshLastOSError;
{$IFNDEF FPC}
{$IF defined(WIN32) or defined(WIN64)}
var
  buffer:PAnsiChar;
{$IFEND}
{$ENDIF}
begin
{$IFDEF FPC}
  FLastOSErrorNumber:=GetLastOSError;
  FLastOSErrorMessage:=SysErrorMessage(FLastOSErrorNumber);
{$ELSE}
{$IF defined(WIN32) or defined(WIN64)}
  FLastOSErrorNumber:=GetLastError;
  GetMem(buffer, 512);
  if FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM,nil,FLastOSErrorNumber,LANG_NEUTRAL,Buffer,512,nil)<>0 then begin
    FLastOSErrorMessage:=Buffer;
    FreeMem(buffer);
  end else
    FLastOSErrorMessage:=SFaultGettingLastOSError;
{$IFEND}
{$ENDIF}
end;

procedure  TCommPortDriver.SetLogActions(Log:Boolean);
var
  canopen:Boolean;
begin
  PIOCmdCS.Enter;
  try
    canopen:=false;
    if Log=FLogActions then exit;

    if [csReading]*ComponentState<>[] then begin
      FReadedLogActions:=Log;
      exit;
    end;

    if [csDesigning]*ComponentState<>[] then begin
      canopen:=(Trim(FLogFile)<>'');
      exit;
    end;

    if log then begin
      FLogFileStream:=TFileStream.Create(FLogFile,fmCreate);
    end else
      FLogFileStream.Destroy;
    canopen:=true;
  finally
    FLogActions:=Log and canopen;
    PIOCmdCS.Leave;
  end;
end;

procedure  TCommPortDriver.SetLogFile(nFile:String);
var
  islogging:Boolean;
begin
  PIOCmdCS.Enter;
  try
    if nFile=FLogFile then exit;
    islogging:=FLogActions;
    LogIOActions:=false;
    FLogFile:=nFile;
    LogIOActions:=islogging;
  finally
    PIOCmdCS.Leave;
  end;
end;

procedure  TCommPortDriver.LogAction(cmd:TIOCommand; Packet:TIOPacket);
  function bufferToHex(Buf:BYTES):String;
  var
    c:integer;
  begin
    Result:='';
    for c:=0 to High(Buf) do
      Result:=Result+IntToHex(Buf[c],2)+' ';
  end;

  function TranslateCmdName(cmd:TIOCommand):String;
  begin
    case cmd of
      iocNone:
        Result := 'iocNone     ';
      iocRead:
        Result := 'iocRead     ';
      iocReadWrite:
        Result := 'iocReadWrite';
      iocWrite:
        Result := 'iocWrite    ';
      iocWriteRead:
        Result := 'iocWriteRead';
    end;
  end;

  function TranslateResultName(res:TIOResult):String;
  const
    EnumMap: array[TIOResult] of String = ('iorOK       ',
                                           'iorTimeOut  ',
                                           'iorNotReady ',
                                           'iorNone     ',
                                           'iorPortError');
  begin
    Result := EnumMap[res];
  end;

  var
    FS:TStringStream;
    timestamp:String;
begin
  if not FLogActions then exit;

  if [csDesigning]*ComponentState<>[] then exit;

  try
    FS:=TStringStream.Create('');
    timestamp := FormatDateTime('mmm-dd hh:nn:ss.zzz',Now);
    if cmd=iocRead then begin
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.ReadIOResult) +', Received: '+bufferToHex(Packet.BufferToRead)+LineEnding);
    end;
    if cmd=iocReadWrite then begin
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.ReadIOResult) +', Received: '+bufferToHex(Packet.BufferToRead)+LineEnding);
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.WriteIOResult)+', Written:    '+bufferToHex(Packet.BufferToWrite)+LineEnding);
    end;

    if cmd=iocWriteRead then begin
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.WriteIOResult)+', Written:    '+bufferToHex(Packet.BufferToWrite)+LineEnding);
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.ReadIOResult) +', Received: '+bufferToHex(Packet.BufferToRead)+LineEnding);
    end;

    if cmd=iocWrite then begin
      fs.WriteString(timestamp+', '+TranslateCmdName(cmd)+', Result='+TranslateResultName(Packet.WriteIOResult)+', Written:    '+bufferToHex(Packet.BufferToWrite)+LineEnding);
    end;
    FS.Position:=0;
    FLogFileStream.CopyFrom(FS,FS.Size);
  finally
    FS.Free;
  end;
end;

end.
