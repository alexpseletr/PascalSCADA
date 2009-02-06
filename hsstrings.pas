//: @exclude
unit hsstrings;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

resourcestring
  //////////////////////////////////////////////////////////////////////////////
  // PALHETAS DE COMPONENTES
  //////////////////////////////////////////////////////////////////////////////
  
  strPortsPallete       = 'FLG SCADA Ports';
  strProtocolsPallete   = 'FLG SCADA Protocols';
  strTagsPallete        = 'FLG SCADA Tags';
  strUtilsPallete       = 'FLG SCADA Utils';
  strControlsPallete    = 'HCl - Acid Controls';
  
  //////////////////////////////////////////////////////////////////////////////
  // Mensagens de exceptions.
  //////////////////////////////////////////////////////////////////////////////
  
  strUpdateThreadWinit  = 'A thread n�o respondeu ao commando INIT';
  strCompIsntADriver    = 'O componente n�o � um driver de protocolo v�lido';
  strThreadSuspended    = 'A thread est� suspensa?';

implementation

end.
 
