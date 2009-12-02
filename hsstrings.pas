{:
  @abstract(Unit de tradu��o do PascalSCADA.)
  @author(Fabio Luis Girardi <papelhigienico@gmail.com>)
}
unit hsstrings;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

resourcestring
  //////////////////////////////////////////////////////////////////////////////
  // PALHETAS DE COMPONENTES
  //////////////////////////////////////////////////////////////////////////////
  
  strPortsPallete       = 'PascalSCADA Ports';
  strProtocolsPallete   = 'PascalSCADA Protocols';
  strTagsPallete        = 'PascalSCADA Tags';
  strUtilsPallete       = 'PascalSCADA Utils';
  strControlsPallete    = 'PascalSCADA HCl';
  
  //////////////////////////////////////////////////////////////////////////////
  // Mensagens de exceptions.
  //////////////////////////////////////////////////////////////////////////////
  
  strUpdateThreadWinit  = 'A thread n�o respondeu ao commando INIT';
  strCompIsntADriver    = 'O componente n�o � um driver de protocolo v�lido';
  strThreadSuspended    = 'A thread est� suspensa?';

implementation

end.
 
