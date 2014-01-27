program weo;

{$MODE Delphi}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces, Dialogs,
  SysUtils, fonctions_dbnetserver,
  fonctions_service,
  fonctions_init,
  u_multidonnees;

{$IFNDEF FPC}
{$R *.res}
{$R WindowsXP.res}
var
  gc_classname: Array[0..255] of char;
  gi_result: integer;

{$ENDIF}


{$IFNDEF FPC}{$R weo.rc}{$ENDIF}

begin
  Application.Initialize;
  if not fb_ReadServerIni ( FIniMain, Application ) Then
   Begin
    ShowMessage ( 'XML file not initalized.' );
   end;
  Application.Run;

//  SetHeapTraceOutput (ExtractFilePath (ParamStr (0)) + 'heaptrclog.trc');
end.
