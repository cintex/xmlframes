program hotel;

{$MODE Delphi}


uses
  Forms, Interfaces, U_FormMainIni, U_XMLFenetrePrincipale, U_Splash,
  LCLType, lazextcomponents, lazfonctions,
  u_multidonnees, U_CustomFrameWork,lazmanframes, lazmansoft, lazxmlframes,
  fonctions_ObjetsXML, Dialogs, LResources, JvXPBarLaz;

{$IFNDEF FPC}
{$R *.res}
{$R WindowsXP.res}
{$ENDIF}


var
	gc_classname: Array[0..255] of char;
	gi_result: integer;

{$IFDEF WINDOWS}{$R hotel.rc}{$ENDIF}

begin
  {$I hotel.lrs}
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
		Application.CreateForm(TM_Donnees, M_Donnees);
                if not fb_ReadIni ( gmif_MainFormIniInit ) Then
                  ShowMessage ( 'XML file not initalized.' );
		Application.CreateForm(TF_FenetrePrincipale, F_FenetrePrincipale);
        finally
	end;
Application.Run;
end.
