program weo;

{$MODE Delphi}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces, U_FormMainIni, U_XMLFenetrePrincipale, U_Splash,
  LCLType, lazextcomponents,
  SysUtils, fonctions_dbnet, fonctions_init,
  u_multidonnees, U_CustomFrameWork, lazmanframes, lazmansoft, lazxmlframes,
  fonctions_ObjetsXML, Dialogs, LResources, JvXPBarLaz;

{$IFNDEF FPC}
{$R *.res}
{$R WindowsXP.res}
var
  gc_classname: Array[0..255] of char;
  gi_result: integer;

{$ENDIF}


{$IFNDEF FPC}{$R weo.rc}{$ENDIF}

begin
  {$I weo.lrs}
  Application.Initialize;
  {$IFNDEF FPC}
  Application.Title := 'Test';

  // Met dans gc_classname le nom de la class de l'application
  GetClassName(Application.handle, gc_classname, 254);

  // Renvoie le Handle de la première fenêtre de Class (type) gc_classname
  // et de titre TitreApplication (0 s'il n'y en a pas)
  gi_result := FindWindow(gc_classname, 'GENERIQUE');

  if gi_result <> 0 then   // Une instance existante trouvée
	  begin
		  ShowWindow(gi_result, SW_RESTORE);
		  SetForegroundWindow(gi_result);
		  Application.Terminate;
		  Exit;
	  end
  else  // Première création
  {$ENDIF}
	  begin

	  end;
  F_SplashForm := TF_SplashForm.Create(nil);
  F_SplashForm.Label1.Caption := 'GENERIC' ;
  F_SplashForm.Label1.Width   := F_SplashForm.Width ;
  F_SplashForm.Show;   // Affichage de la fiche
  F_SplashForm.Update; // Force la fiche à se dessiner complètement

  try
    gb_DicoKeyFormPresent  := True ;
    gb_DicoUseFormField    := True ;
    gb_DicoGroupementMontreCaption := False ;
    if not fb_ReadIni ( FIniMain ) Then
     Begin
      ShowMessage ( 'XML file not initalized.' );
      Application.Terminate;
     end;
    Application.CreateForm(TF_FenetrePrincipale, F_FenetrePrincipale);
  finally
  end;
  Application.Run;
//  SetHeapTraceOutput (ExtractFilePath (ParamStr (0)) + 'heaptrclog.trc');
end.
