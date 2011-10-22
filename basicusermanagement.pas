unit BasicUserManagement;

interface

uses
  SysUtils, Classes, ExtCtrls, usrmgnt_login;

type
  TVKType = (vktNone, vktAlphaNumeric, vktNumeric);

  TBasicUserManagement = class(TComponent)
  private
{}  FLoggedUser:Boolean;
{}  FCurrentUserName,
{}  FCurrentUserLogin:String;
{}  FLoggedSince:TDateTime;
{}  FInactiveTimeOut:Cardinal;
{}  FLoginRetries:Cardinal;
    FFrozenTime:Cardinal;
    FVirtualKeyboardType:TVKType;

    FSuccessfulLogin:TNotifyEvent;
    FFailureLogin:TNotifyEvent;

    frmLogin:TfrmUserAuthentication;

    function GetLoginTime:TDateTime;
    procedure SetInactiveTimeOut(t:Cardinal);
    procedure UnfreezeLogin(Sender:TObject);
  protected

    procedure DoSuccessfulLogin; virtual;
    procedure DoFailureLogin; virtual;

    function CheckUserAndPassword(User, Pass:String):Boolean; virtual;

    //read only properties.

    property UserLogged:Boolean read FLoggedUser;
    property CurrentUserName:String read FCurrentUserName;
    property CurrentUserLogin:String read FCurrentUserLogin;
    property LoggedSince:TDateTime read GetLoginTime;

    //read-write properties.
    //property VirtualKeyboardType:TVKType read FVirtualKeyboardType write FVirtualKeyboardType;
    property InactiveTimeout:Cardinal read FInactiveTimeOut write SetInactiveTimeOut;
    property LoginRetries:Cardinal read FLoginRetries write FLoginRetries;
    property LoginFrozenTime:Cardinal read  FFrozenTime write FFrozenTime;

    property SuccessfulLogin:TNotifyEvent read FSuccessfulLogin write FSuccessfulLogin;
    property FailureLogin:TNotifyEvent read FFailureLogin write FFailureLogin;
  public
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    function    Login:Boolean; virtual;
    procedure   Logout; virtual;

    procedure   ValidateSecurityCode(sc:String); virtual;
    function    CanAccess(sc:String):Boolean; virtual;
  end;

implementation

uses Controls;

constructor TBasicUserManagement.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor  TBasicUserManagement.Destroy;
begin
  inherited Destroy;
end;

function    TBasicUserManagement.Login:Boolean;
var
  frozenTimer:TTimer;
  retries:Integer;
  aborted, loggedin:Boolean;
begin
  frozenTimer:=TTimer.Create(nil);
  frozenTimer.OnTimer:=UnfreezeLogin;
  frmLogin:=TfrmUserAuthentication.Create(nil);
  retries:=0;
  aborted:=false;
  loggedin:=False;
  Result:=false;
  try
    while (not loggedin) or aborted do begin
      frmLogin.edtusername.Text:='';
      frmLogin.edtPassword.Text:='';
      frmLogin.edtusername.SetFocus;
      if frmLogin.ShowModal=mrOk then begin
        if CheckUserAndPassword(frmLogin.edtusername.Text, frmLogin.edtPassword.Text) then begin
          FLoggedUser:=true;
          loggedin:=true;
          FCurrentUserLogin:=frmLogin.edtusername.Text;
          FLoggedSince:=Now;
          DoSuccessfulLogin;
          Result:=true;
        end else begin
          DoFailureLogin;
          inc(retries);
          if retries=FLoginRetries then begin
            frmLogin.Enabled:=false;
            frozenTimer.Enabled:=true;
          end;
        end;
      end else
        aborted:=true;
    end;
  finally
    frmLogin.Destroy;
    frozenTimer.Destroy;
  end;
end;

procedure   TBasicUserManagement.Logout;
begin
  FLoggedUser:=false;
  FCurrentUserName:='';
  FCurrentUserLogin:='';
  FLoggedSince:=Now;
end;

procedure   TBasicUserManagement.ValidateSecurityCode(sc:String);
begin
  //does nothing.
end;

function    TBasicUserManagement.CanAccess(sc:String):Boolean;
begin
  Result:=false;
end;

function    TBasicUserManagement.GetLoginTime:TDateTime;
begin
  if FLoggedUser then
    Result:=FLoggedSince
  else
    Result:=Now;
end;

procedure   TBasicUserManagement.SetInactiveTimeOut(t:Cardinal);
begin
  //
end;

function    TBasicUserManagement.CheckUserAndPassword(User, Pass:String):Boolean;
begin
  Result:=false;
end;

procedure TBasicUserManagement.DoSuccessfulLogin;
begin
  if Assigned(FSuccessfulLogin) then
    FSuccessfulLogin(Self);
end;

procedure TBasicUserManagement.DoFailureLogin;
begin
  if Assigned(FFailureLogin) then
    FFailureLogin(Self);
end;

procedure TBasicUserManagement.UnfreezeLogin(Sender:TObject);
begin
  if sender is TTimer then
    TTimer(sender).Enabled:=false;
  if frmLogin<>nil then
    frmLogin.Enabled:=true;
end;

end.
 
