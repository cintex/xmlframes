program weo;

{$MODE Delphi}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces, Dialogs,
  SysUtils, fonctions_mandbnetserver,
  fonctions_dbservice,
  fonctions_xml,
  fonctions_init,
  fonctions_dialogs,
  fonctions_system,
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
  gs_LeonardiSubDir := '..'+DirectorySeparator+'Leon' +DirectorySeparator;
  GS_SUBDIR_IMAGES_SOFT := '../../images'+DirectorySeparator;
  if not fb_ReadServerIni ( FIniMain, Application ) Then
   Begin
    MyShowMessage ( 'XML file not initalized.' );
   end;
  Application.Run;

//  SetHeapTraceOutput (ExtractFilePath (ParamStr (0)) + 'heaptrclog.trc');
end.
