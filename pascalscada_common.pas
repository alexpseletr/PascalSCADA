{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pascalscada_common;

interface

uses
  crossdatetime, CrossEvent, hsstrings, hsutils, lazlclversion, MessageSpool, 
  pascalScadaMTPCPU, pscada_common, pscommontypes, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('pascalscada_common', @Register);
end.
