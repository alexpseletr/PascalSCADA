{$i language.inc}
{$IFDEF PORTUGUES}
{:
  @abstract(Unit de registro de componentes do PascalSCADA. Para Lazarus e Delphi.)
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
}
{$ELSE}
{:
  @abstract(Unit of register of PascalSCADA components. For Lazarus and Delphi.)
  @author(Fabio Luis Girardi <fabio@pascalscada.com>)
}
{$ENDIF}
unit scadareg;

interface

procedure Register;

implementation

uses
  Classes, SerialPort, ModBusSerial, LinearScaleProcessor, PLCTagNumber,
  PLCBlock, PLCBlockElement, PLCString, UserScale, ValueProcessor,
  scadapropeditor, HMIEdit, HMILabel, HMICheckBox, HMIRadioButton, HMITrackBar,
  HMIProgressBar, HMIRadioGroup, HMIUpDown, HMIScrollBar, HMIAnimation,
  HMIText, HMIZones, hmipropeditor, hsstrings, TagBit, ProtocolDriver,
  WestASCIIDriver, IBoxDriver, tcp_udpport, ModBusTCP, PLCStruct, PLCNumber,
  PLCStructElement, ISOTCPDriver, HMIControlDislocatorAnimation, HMIDBConnection,
  {$IF defined(WINDOWS) or defined(WIN32) or defined(WIN64)}
  WinCCUserManagement,
  {$IFEND}
  {$IFDEF FPC}
    LResources, PropEdits, ComponentEditors;
  {$ELSE}
    Types, MemDs,
    //se for delphi 4 ou 5
    //if is delphi 5 or below.
    {$IF defined(VER130) or defined(VER120)}
      DsgnIntf;
    {$ELSE}
      //demais versoes do delphi
      //others versions of delphi.
      DesignIntf, DesignEditors;
    {$IFEND}
  {$ENDIF}
procedure Register;
begin
  RegisterComponents(strPortsPallete,     [TSerialPortDriver]);
  RegisterComponents(strPortsPallete,     [TTCP_UDPPort]);
  RegisterComponents(strProtocolsPallete, [TModBusRTUDriver]);
  RegisterComponents(strProtocolsPallete, [TModBusTCPDriver]);
  RegisterComponents(strProtocolsPallete, [TWestASCIIDriver]);
  RegisterComponents(strProtocolsPallete, [TIBoxDriver]);
  RegisterComponents(strProtocolsPallete, [TISOTCPDriver]);
  RegisterComponents(strUtilsPallete,     [TScalesQueue]);
  RegisterComponents(strUtilsPallete,     [TLinearScaleProcessor]);
  RegisterComponents(strUtilsPallete,     [TUserScale]);
  RegisterComponents(strTagsPallete,      [TPLCTagNumber]);
  RegisterComponents(strTagsPallete,      [TPLCBlock]);
  RegisterComponents(strTagsPallete,      [TPLCBlockElement]);
  RegisterComponents(strTagsPallete,      [TPLCString]);
  RegisterComponents(strTagsPallete,      [TTagBit]);
  RegisterComponents(strTagsPallete,      [TPLCStruct]);
  RegisterComponents(strTagsPallete,      [TPLCStructItem]);

  RegisterComponents(strControlsPallete,  [THMIEdit]);
  RegisterComponents(strControlsPallete,  [THMILabel]);
  RegisterComponents(strControlsPallete,  [THMICheckBox]);
  RegisterComponents(strControlsPallete,  [THMIRadioButton]);
  RegisterComponents(strControlsPallete,  [THMITrackBar]);
  RegisterComponents(strControlsPallete,  [THMIProgressBar]);
  RegisterComponents(strControlsPallete,  [THMIRadioGroup]);
  RegisterComponents(strControlsPallete,  [THMIUpDown]);
  RegisterComponents(strControlsPallete,  [THMIScrollBar]);
  RegisterComponents(strControlsPallete,  [THMIAnimation]);
  RegisterComponents(strControlsPallete,  [THMIText]);
  RegisterComponents(strControlsPallete,  [THMIControlDislocatorAnimation]);
  //RegisterComponents(strControlsPallete,  [THMIButton]);
  RegisterComponents(strDatabasePallete,  [THMIDBConnection]);
  {$IFNDEF FPC}
  RegisterComponents(strFPCPallete,       [TMemDataset]);
  {$ENDIF}

  {$IF defined(WINDOWS) or defined(WIN32) or defined(WIN64)}
  RegisterComponents(strUserManagement,   [TWinCCUserManagement]);
  {$IFEND}

  RegisterPropertyEditor(TypeInfo(string), TSerialPortDriver,              'COMPort'  ,        TPortPropertyEditor);
  RegisterPropertyEditor(TypeInfo(integer),TPLCBlockElement,               'Index'    ,        TElementIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), TGraphicZone,                   'FileName' ,        TZoneFileNamePropertyEditor);
  RegisterPropertyEditor(TypeInfo(integer),TZone,                          'BlinkWith',        TZoneBlinkWithPropertyEditor);

  {$IFDEF FPC}
  {$if defined(lcl_fullversion) and (lcl_fullversion>=093000)}
  RegisterPropertyEditor(TypeInfo(integer),TGraphicZone,                   'ImageIndex',        TGraphiZoneImageIndexPropertyEditor);
  {$IFEND}
  {$ENDIF}

  RegisterPropertyEditor(TypeInfo(string), THMIControlDislocatorAnimation, 'Gets_P0_Position', TPositionPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIControlDislocatorAnimation, 'Gets_P1_Position', TPositionPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIControlDislocatorAnimation, 'GoTo_P0_Position', TPositionPropertyEditor);

  //securitycode property editor.
  RegisterPropertyEditor(TypeInfo(string), THMIEdit, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMILabel, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMICheckBox, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIRadioButton, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMITrackBar, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIProgressBar, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIRadioGroup, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIUpDown, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIScrollBar, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIAnimation, 'SecurityCode', TSecurityCodePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIText, 'SecurityCode', TSecurityCodePropertyEditor);
  //end securitycode property editor.

  RegisterPropertyEditor(TypeInfo(string), THMIDBConnection,               'Protocol', THMIDBProtocolPropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIDBConnection,               'Database', THMIDBDatabasePropertyEditor);
  RegisterPropertyEditor(TypeInfo(string), THMIDBConnection,               'Catalog',  THMIDBCatalogPropertyEditor);

  RegisterComponentEditor(TProtocolDriver, TTagBuilderComponentEditor);
  RegisterComponentEditor(TPLCNumber,      TTagBitMapperComponentEditor);
  RegisterComponentEditor(TPLCBlock,       TBlockElementMapperComponentEditor);

  {$IFDEF FPC}
  {$IF defined(FPC) AND (FPC_FULLVERSION < 20501) }
  RegisterClassAlias(TScalesQueue, 'TPIPE');
  {$ELSE}
  RegisterClassAlias(TPIPE, 'TScalesQueue');
  {$IFEND}
  {$ELSE}
  RegisterClassAlias(TPIPE,        'TScalesQueue');
  {$ENDIF}
end;

{$IFDEF FPC}
initialization
  {$I pascalscada.lrs}
{$ENDIF}
end.

