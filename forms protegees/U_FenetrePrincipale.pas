
// ************************************************************************ //
// Dfm2Pas: WARNING!
// -----------------
// Part of the code declared in this file was generated from data read from
// a *.DFM file or a Delphi project source using Dfm2Pas 1.0.
// For a list of known issues check the README file.
// Send Feedback, bug reports, or feature requests to:
// e-mail: fvicaria@borland.com or check our Community website.
// ************************************************************************ //

unit U_FenetrePrincipale;

{$I ..\Compilers.inc}
{$I ..\extends.inc}


{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
{$IFDEF ZEOS}
  ZConnection,
{$ENDIF}
{$IFNDEF CSV}
  DB,
{$IFDEF EADO}
  ADODB,
{$ENDIF}
{$ENDIF}
{$IFDEF FPC}
   LCLIntf, LCLType, SQLDB, PCheck, lresources,
{$ELSE}
  Windows, OleDB, JvComponent, StoHtmlHelp, JvScrollBox,
  JvExExtCtrls, JvSplitter, JvLED, U_ExtScrollBox,
  StdActns, JvExForms, JvExControls,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
  TntDBCtrls, TntMenus,TntStdCtrls, TntExtCtrls, DKLang, TntActnList,
  TntDialogs, TntGraphics, TntForms,
{$ENDIF}
  U_Donnees, ExtTBTls, extdock, ExtTBTlwn, ExtTBTlbr,
  Controls, Graphics, Classes, SysUtils, StrUtils,
  ExtCtrls, ActnList, Menus, Messages,
  JvXPContainer, ComCtrls, JvXPButtons,
  IniFiles, Dialogs, Printers, ALXmlDoc,
  JvXPBar, Forms,  U_FormMainIni, fonctions_init,
  fonctions_Objets_Dynamiques, fonctions_ObjetsXML, fonctions_images,
  u_buttons_appli, fonctions_string,
  U_OnFormInfoIni, DBCtrls ;

{$IFDEF VERSIONS}
const
    gVer_F_FenetrePrincipale : T_Version = ( Component : 'Fenêtre principale XML' ;
       			                 FileUnit : 'U_XMLFenetrePrincipale' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre principale utilisée pour la gestion automatisée à partir du fichier INI, avec des menus composés à partir des données.' + #13#10 + 'Elle dépend du composant Fenêtre principale qui lui n''est pas lié à l''application.' ;
      			                 BugsStory : 'Version 0.1.0.0 : Création à partir de U_FenetrePrincipale' ;
			                 UnitType : CST_TYPE_UNITE_FICHE ;
			                 Major : 0 ; Minor : 1 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

  { TF_FenetrePrincipale }

  TF_FenetrePrincipale = class(TF_FormMainIni)
    im_icones: TImageList;
    mu_apropos: TMenuItem;
    mu_cascade: TMenuItem;

    mu_MainMenu: {$IFDEF TNT}TTntMainMenu{$ELSE}TMainMenu{$ENDIF};
    mu_file: TMenuItem;
    mu_langue: TMenuItem;
    mu_mosaiqueh: TMenuItem;
    mu_mosaiquev: TMenuItem;
    mu_organiser: TMenuItem;
    mu_ouvrir: TMenuItem;
    mu_sep1: TMenuItem;
    mu_quitter: TMenuItem;
    mu_fenetre: TMenuItem;
    {$IFNDEF FPC}
    mu_cascade: TMenuItem;
    mu_mosaiqueh: TMenuItem;
    mu_mosaiquev: TMenuItem;
    mu_organiser: TMenuItem;
    {$ENDIF}
    mu_reduire: TMenuItem;
    mu_affichage: TMenuItem;
    mu_barreoutils: TMenuItem;
    mu_voletexplore: TMenuItem;
    mu_aide: TMenuItem;
    mu_ouvriraide: TMenuItem;
    mu_sep2: TMenuItem;
    {$IFDEF VERSIONS}
    mu_apropos: TMenuItem;
    {$ENDIF}
    mu_Reinitiliserpresentation: TMenuItem;
    mu_sep3: TMenuItem;

    ActionList: {$IFDEF TNT}TTntActionList{$ELSE}TActionList{$ENDIF};
    pa_5: TPanel;
    {$IFDEF MDI}
    WindowCascade: TWindowCascade;
    WindowTileHorizontal: TWindowTileHorizontal;
    WindowTileVertical: TWindowTileVertical;
    WindowMinimizeAll: TWindowMinimizeAll;
    WindowArrangeAll: TWindowArrange;
    {$ENDIF}

    Timer: TTimer;
    SvgFormInfoIni: TOnFormInfoIni;
    im_Liste: TImageList;

    dock_outils: TDock;
    dock_volet: TDock;
    tbsep_1: TExtToolbarSep;
    tbsep_2: TExtToolbarSep;
    tbsep_3: TExtToolbarSep;
    tbar_outils: TExtToolbar;

    pa_1: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    pa_2: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    pa_3: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    pa_4: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    dbt_ident: TJVXPButton;
    dbt_quitter: TFWQuit;
    dbt_aide: TJVXPButton;

    br_statusbar: TStatusBar;

    im_led: {$IFDEF FPC}TPCheck{$ELSE}TJvLED{$ENDIF};
    mu_identifier: TMenuItem;
//    pa_5: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    tbar_volet: TExtToolWindow;
    spl_volet: {$IFDEF FPC}TSplitter{$ELSE}TJvSplitter{$ENDIF};
    im_appli: TImage;
    im_acces: TImage;
    im_about: TImage;
    scb_Volet: {$IFDEF FPC}TScrollBox{$ELSE}TExtScrollBox{$ENDIF};

    procedure p_ChargeAide;
    procedure p_CloseMDI(as_NomMDI: String);
    procedure p_LibStb;
    procedure p_OnClickFonction(Sender: TObject);
{$IFDEF TNT}
    procedure p_OnClickMenuLang(Sender:TObject);
{$ENDIF}
    procedure p_SetLengthSB(ao_SP: TStatusPanel);
    function  fb_Fermeture : Boolean ;

    procedure DoShow; override; ;
    procedure F_FormMainIniActivate(Sender: TObject);
    procedure F_FormMainIniResize(Sender: TObject);
    procedure DoClose ( var AAction: TCloseAction ); override; ;

    procedure dbt_identClick(Sender: TObject);
    procedure dbt_aideClick(Sender: TObject);
    procedure dbt_quitterClick(Sender: TObject);

    procedure mu_barreoutilsClick(Sender: TObject);
    procedure mu_voletexploreClick(Sender: TObject);
    {$IFDEF VERSIONS}
    procedure mu_aproposClick(Sender: TObject);
    {$ENDIF}

    procedure TimerTimer(Sender: TObject);
    procedure br_statusbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
                        			      const Rect: TRect);

    procedure tbar_voletClose(Sender: TObject);
    procedure tbar_outilsClose(Sender: TObject);

//    procedure pa_5Resize(Sender: TObject);
    procedure tbar_voletDockChanged(Sender: TObject);
    procedure tbar_voletCloseQuery(Sender: TObject; var CanClose: Boolean);
    function CloseQuery: Boolean; override; ;
    procedure mu_ReinitiliserpresentationClick(Sender: TObject);

  private

    { Déclarations privées }
    lb_MsgDeconnexion : Boolean ;

    procedure p_SetLedColor(const ab_Status: Boolean );
{$IFNDEF FPC}
    procedure WMHelp (var Message: TWMHelp); message WM_HELP;
{$ENDIF}

  public
    function f_IniGetConfigFile({$IFNDEF CSV}acco_Conn: TComponent;{$ENDIF} as_NomConnexion: string): TMemIniFile; override;
    { Déclarations publiques }
    // Procédures qui sont appelées automatiquement pour l'initialisation et la sauvegarde
    Constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure   p_PbConnexion; override;
    procedure   p_Connectee; override;
    procedure   p_WriteDescendantIni(const amif_Init: TMemIniFile); override; ;
    procedure   p_ReadDescendantIni (const amif_Init: TMemIniFile); override; ;
    procedure   p_SortieMajNumScroll(const ab_MajEnfoncee, ab_NumEnfoncee,
                        			             ab_ScrollEnfoncee: boolean); override;
    procedure   p_ApresSauvegardeParamIni; override;
    procedure   p_editionTransfertVariable(as_nom,as_titre,as_chemin:String;ats_edition_nom_params,ats_edition_params,ats_edition_params_values: TStrings);
  published
    procedure p_ConnectToData ();
  end;

var
  F_FenetrePrincipale: TF_FenetrePrincipale;

implementation

uses
  U_Splash,
  TypInfo,
{$IFDEF DBEXPRESS}
  SQLExpr,
{$ENDIF}
{$IFNDEF FPC}
  fonctions_aide,
{$ENDIF}
{$IFDEF TNT}
  TntWindows,
{$ENDIF}
  fonctions_xml, fonctions_dbcomponents,
  unite_variables, unite_messages,
  fonctions_proprietes ;

{$IFNDEF FPC}
{$R *.dfm}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//  Fonctions et procédures générales
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  Recherche du nom de l'executable pour aller
//  chercher la bonne fonction d'initialisation
////////////////////////////////////////////////////////////////////////////////
Constructor TF_FenetrePrincipale.Create(AOwner: TComponent);
var
  lbmp_Bitmap : TBitmap ;
begin
  inherited ;
  if ( csDesigning in ComponentState ) Then
    Exit ;

  gs_DefaultUser := f_IniReadSectionStr ( INISEC_PAR, INISEC_UTI, '' );

  SvgFormInfoIni.LaFormCreate ( Self );
  // Lecture des infos des composants du fichier INI
  SvgFormInfoIni.ExecuteLecture(True);

    // Initialisation de l'aide et des libellés de la barre de status
  p_ChargeAide;
  p_LibStb;

  // Initialisation des variables
  gs_computer      := f_IniFWReadComputerName;
  gs_sessionuser   := f_IniFWReadUtilisateurSession;
  lbmp_Bitmap := TBitmap.Create ;
  lbmp_Bitmap.Handle := 0 ;
  gdat_QueryCopy := M_Donnees.q_TreeUser;


  // Initialisation du composant de fabrication dynamique de fonctions
  p_initialisationBoutons(Self, mu_langue, scb_volet, mu_voletexplore,
                          nil, tbar_outils, tbsep_1, pa_2, CST_LARGEUR_PANEL,
                          nil, mu_ouvrir, im_Liste, im_Liste.Count);
  p_ConnectToData ;

{  // Initialisation de l'icone de l'application ainsi que de son titre
  Self.Caption := gs_NomApli + ' - ' + gs_NomLog;

  im_icones.AddIcon(im_appli.Picture.Icon);
  im_icones.AddIcon(im_acces.Picture.Icon);
  im_icones.AddIcon(im_about.Picture.Icon);
  if Self.Icon.Handle <> 0 Then
    Begin
      Self.Icon.ReleaseHandle ;
      Self.Icon.Handle := 0 ;
    End ;
  Self.Icon.Assign(im_appli.Picture.Icon);
  try
    if lbmp_Bitmap.Handle <> 0 Then
      Begin
        {$IFNDEF FPC}
{        lbmp_Bitmap.Dormant ;
        {$ENDIF}
{        lbmp_Bitmap.FreeImage ;
        lbmp_Bitmap.Handle := 0 ;
      End ;
    lbmp_Bitmap.Free ;
  Finally
  End ;
  // Transformation des icones 32*32 en 16*16 pour le menu
  {$IFNDEF FPC}
{  im_icones.GetIcon(2, gic_F_AboutIcon);
  {$ENDIF}

  // Initialisation de la LED de connexion à la base...
//  im_led.
  im_led.Parent := br_statusbar;
  im_led.Show;
end;

////////////////////////////////////////////////////////////////////////////////
//  Destruction de la Led de connexion car mal géré dans l'objet !!!
////////////////////////////////////////////////////////////////////////////////
Destructor TF_FenetrePrincipale.Destroy;
begin
  if not ( csDesigning in ComponentState ) Then
    Begin
      Timer.Enabled := False ;
      p_IniWriteSectionBol ( 'F_FenetrePrincipale', 'tbar_volet.Visible' , tbar_volet.Visible );
      p_IniWriteSectionBol ( 'F_FenetrePrincipale', 'tbar_outils.Visible', tbar_outils.Visible );
      try
          p_DetruitTout ( False );
          im_icones.DestroyComponents ;

      finally
      end;
      F_FenetrePrincipale := nil ;
      gs_edition_nom_params.Free;
      gs_edition_params.Free;
      gs_edition_params_values.Free;

      gs_edition_nom_params := nil ;
      gs_edition_params      := nil ;
      gs_edition_params_values := nil ;
    End ;

  inherited;
  if ( csDesigning in ComponentState ) Then
    Exit ;
  F_SplashForm.Free; // Libération de la mémoire
  F_SplashForm := nil;
end;

////////////////////////////////////////////////////////////////////////////////
// Chargement de l'aide par appuie sur la touche F1
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_ChargeAide;
begin
  // Recherche du chemin du fichier d'aide
  {$IFNDEF FPC}
  Application.HelpFile := ExtractFilePath(ParamStr(0)) + gs_aide;
  Application.HelpFile := ExpandFileName(Application.HelpFile);
  Self.HelpContext := CST_NUM_AIDE;

  // Si le fichier d'aide est introuvable
  if not FileExists(Application.HelpFile) then ShowMessage('Le fichier d''aide est introuvable !');
  {$ENDIF}
end;

////////////////////////////////////////////////////////////////////////////////
//  Fermeture de la forme fille demandée (voir si utile)
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_CloseMDI(as_NomMDI: String);
var li_i: integer;
begin
  if fb_stringVide(as_NomMDI) then
    Begin
      for li_i := 0 to Application.ComponentCount - 1 do
        if ( Application.Components [ li_i ] is TCustomForm ) Then
          ( Application.Components [ li_i ] as TCustomForm ).Close ;
    End
  else
    for li_i := 0 to Application.ComponentCount - 1 do
      if Application.Components [ li_i ].Name = as_NomMDI then
        begin
          ( Application.Components [ li_i ] as TCustomForm ).Close ;
          Exit;
        end;
end;

////////////////////////////////////////////////////////////////////////////////
//  Pour afficher dans la barre de status les informations souhaitées
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_LibStb;
begin
  // Date et heure
  br_statusbar.Panels[3].Text := DateToStr(Date);
  br_statusbar.Panels[4].Text := LeftStr(TimeToStr(Time), 5);
end;

////////////////////////////////////////////////////////////////////////////////
//  Pour gérer les click sur les boutons de fonctions créés dynamiquement
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_OnClickFonction(Sender: TObject);
begin
  p_ExecuteFonction(Sender);
end;

{$IFNDEF FPC}
procedure TF_FenetrePrincipale.WMHelp(var Message: TWMHelp);
begin
  if not fb_AppelAideSupplementaire ( Message ) Then
    inherited;

end;
{$ENDIF}
////////////////////////////////////////////////////////////////////////////////
//  Pour retailler les StatusPanel en fonction de leur longueur de texte
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_SetLengthSB(ao_SP: TStatusPanel);
begin
  if Length(ao_SP.Text) = 0 then
    ao_SP.Width := 5
  else
    ao_SP.Width := Length(ao_SP.Text) * 7 ;

  F_FormMainIniResize(Self);
end;

function TF_FenetrePrincipale.fb_Fermeture : Boolean ;
begin
  Result := False ;
  if MessageDlg ( GS_FERMER_APPLICATION, mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes Then
    Begin
      Result := True ;
      // Sauvegarde de la position des fenêtres filles
      SvgFormInfoIni.AutoUpdate := False ;
      SvgFormInfoIni.ExecuteEcriture ( False );
      p_FreeChildForms ;
      Application.Terminate;
    End ;
end;


////////////////////////////////////////////////////////////////////////////////
//  Méthodes liées à la forme
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.DoShow;
begin
  inherited ;
end;

procedure TF_FenetrePrincipale.F_FormMainIniActivate(Sender: TObject);
begin
  // Identification par la fenêtre de Login uniquement au démarrage de l'application
  if gb_FirstAcces then
    begin
      // Initialisation de la toolbar mauvaise si dans le create et si maximised
      if gs_ModeConnexion = CST_MACHINE then
        IniLoadToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_computer  + '.INI', '')
      else
        IniLoadToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_sessionuser  + '.INI', '');

      // Init. du menu barre de fonction checked ou pas
      mu_barreoutils.Checked := tbar_outils.Visible;

      dbt_identClick(Sender);
    end;
end;

procedure TF_FenetrePrincipale.F_FormMainIniResize(Sender: TObject);
begin
  // On retaille la toolbar
  if tbar_outils.Docked then
    begin
      pa_2.Width := Self.Width
                    - gi_NbSeparateurs * (CST_LARGEUR_PANEL + CST_LARGEUR_SEP)
                    - CST_LARGEUR_DOCK;
      pa_2.Show;
      tbsep_2.Show;
    end
  else
    begin
      pa_2.Width := CST_LARGEUR_PANEL;
      pa_2.Hide;
      tbsep_2.Hide;
    end;

  pa_2.Refresh;

  // Puis la statusbarre
  br_statusbar.Panels[0].Width := Self.Width - (br_statusbar.Panels[1].Width +
                        			    br_statusbar.Panels[2].Width +
                        			    br_statusbar.Panels[3].Width +
                        			    br_statusbar.Panels[4].Width +
                        			    br_statusbar.Panels[5].Width +
                        			    br_statusbar.Panels[6].Width + 30);
  if Assigned(im_led) then
    im_led.SetBounds(br_statusbar.Panels[0].Width, 1, 17, 17);
end;

procedure TF_FenetrePrincipale.DoClose ( var AAction: TCloseAction );
begin
  if not ( csDesigning in ComponentState ) Then
    Begin
      p_IniWriteSectionStr ( INISEC_PAR, INISEC_UTI, gs_DefaultUser );
      if not assigned ( F_SplashForm ) Then
        Begin
          F_SplashForm := TF_SplashForm.Create(Application);
        End ;
      F_SplashForm.Show;   // Affichage de la fiche
   End ;
   inherited ;
end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion des boutons de la barre d'outils
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.dbt_identClick(Sender: TObject);
begin
{$IFNDEF CSV}
  //gConnection := Connection ;
  //gConnector  := Connector  ;
{$ENDIF}
  if lb_MsgDeconnexion
  and ( MessageDlg ( GS_DECONNECTER, mtConfirmation, [ mbYes, mbNo ], 0 ) = mrNo ) Then
    Exit ;
  // (Ré)initialisation de l'application
  Screen.Cursor := crSQLWait;
  p_FreeChildForms;
  p_DetruitTout ( True );
  if not gb_FirstAcces then p_LibereSauveIni; // On libère le fichier INI sauf à la 1ère ouverture
  gi_NbSeparateurs := 3; // Le nombre initial de séparateur dans la barre d'outils
  F_FormMainIniResize(Self);
  pa_2.Refresh;

  // Fermeture de la connexion principale, init. de la Led et de la barre de status
{$IFNDEF CSV}
  if assigned ( Connection ) then
    p_setComponentBoolProperty ( Connection, 'Connected', False );
{$ENDIF}
  p_SetLedColor ( False );
  br_statusbar.Panels[1].Text := '';
  p_SetLengthSB(br_statusbar.Panels[1]);
  br_statusbar.Panels[2].Text := GS_LBL_PB;
  p_SetLengthSB(br_statusbar.Panels[2]);

  // Le volet d'exploration est fermé et inaccessible
  DisableAlign ;
  tbar_volet.Hide;
  mu_voletexplore.Checked := False;
  mu_voletexplore.Enabled := False;
//  pa_5.Width := 0;
  spl_volet.Hide;
  EnableAlign ;

  // Connexion à la base d'accès aux utilisateurs et sommaires
{$IFNDEF CSV}
  try
//    Connector.Connected := True;

  except
    Screen.Cursor := Self.Cursor;
    MessageDlg( GS_PB_CONNEXION, mtWarning, [mbOk], 0);
    p_SetLedColor ( False );
    br_statusbar.Panels[2].Text := GS_LBL_PB;
    p_SetLengthSB(br_statusbar.Panels[2]);
  end;
{$ENDIF}

  Screen.Cursor := Self.Cursor;

  // On fait apparaître la fenêtre de login
  {
  Application.CreateForm(TF_Acces, F_Acces);
   }
  if Assigned(F_SplashForm) then F_splashForm.Free;
  F_splashForm := nil ;

end;

// Connexion aux données de l'application
procedure TF_FenetrePrincipale.p_ConnectToData ();
begin
  if Assigned(F_SplashForm) then F_splashForm.Free;
  F_splashForm := nil ;
  Screen.Cursor := crSQLWait;
//  F_Acces.Free;

  fb_ReadXMLEntitites ();

  if ( gs_User <> ''  ) Then
    gs_DefaultUser := gs_User ;

  // On recharge le fichier INI sauf si c'est déjà fait (lors de la création de l'appli)
  if not gb_FirstAcces then f_GetIniFile;

  Self.Caption := gs_NomAppli + ' - ' + gs_User + ' - ' + gs_Resto ;

  if gb_AccesAuto then // Si on a validé un utilisateur dans la fenêtre de login
    try
      lb_MsgDeconnexion := True ;

    except
      if gi_niveau_priv < CST_ADMIN Then
        MessageDlg( GS_PB_CONNEXION, mtError, [mbOk], 0)
      Else
        MessageDlg( GS_PB_CONNEXION + #13#10 + #13#10 + GS_ADMINISTRATION_SEULEMENT, mtError, [mbOk], 0);

      p_SetLedColor ( False );
      br_statusbar.Panels[2].Text  := GS_LBL_PB;
      p_SetLengthSB(br_statusbar.Panels[2]);
      if gi_niveau_priv < CST_ADMIN Then
        Begin
          lb_MsgDeconnexion := False ;
          Screen.Cursor := Self.Cursor;
          dbt_identClick ( Self );
        End ;
    end
  Else
     lb_MsgDeconnexion := False ;
{$IFNDEF CSV}
  if assigned ( Connector ) then
    p_setComponentBoolProperty ( Connector, 'Connected', False );
{$ENDIF}
  Screen.Cursor := Self.Cursor;
  gb_FirstAcces := False;
End;

procedure TF_FenetrePrincipale.p_SetLedColor( const ab_Status : Boolean );
begin
  try
    im_led.{$IFDEF FPC}Checked{$ELSE}Status{$ENDIF} := ab_Status ;
  Except
  End ;
end;
procedure TF_FenetrePrincipale.dbt_aideClick(Sender: TObject);
begin
  {$IFNDEF FPC}
  Application.HelpSystem.ShowTableOfContents;
  {$ENDIF}
end;

procedure TF_FenetrePrincipale.dbt_quitterClick(Sender: TObject);
begin
  CloseQuery ;
end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion de la visibilité des accès aux fonctions
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.mu_barreoutilsClick(Sender: TObject);
begin
  mu_barreoutils.Checked := not mu_barreoutils.Checked;
  tbar_outils.Visible := mu_barreoutils.Checked;
end;

procedure TF_FenetrePrincipale.mu_voletexploreClick(Sender: TObject);
begin
  DisableAlign ;
  mu_voletexplore.Checked := not mu_voletexplore.Checked;
  tbar_volet.Visible := mu_voletexplore.Checked;
  if tbar_volet.Visible then
    tbar_voletDockChanged(Self)
  else
    begin
//      pa_5.Width := 0;
      spl_volet.Hide;
    end;
  EnableAlign ;
end;

////////////////////////////////////////////////////////////////////////////////
//  Boîte de dialogue à propos
////////////////////////////////////////////////////////////////////////////////
{$IFDEF VERSIONS}
procedure TF_FenetrePrincipale.mu_aproposClick(Sender: TObject);
begin
  gb_Reinit := fb_AfficheApropos ( False, gs_NomAppli, gs_Version );
end;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//  Rafraîchissement de la date et de l'heure sur la barre de statut
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.TimerTimer(Sender: TObject);
begin
  br_statusbar.Panels[3].Text := DateToStr(Date);
  br_statusbar.Panels[4].Text := LeftStr(TimeToStr(Time), 5);
end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion de MAJ & Num si inactifs (ie. que l'on utilise le canevas)
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.br_statusbarDrawPanel(StatusBar: TStatusBar;
                        			                	     Panel: TStatusPanel;
                        			                	     const Rect: TRect);
var li_CoordX, li_CoordY: integer;
begin
  StatusBar.Canvas.Font.Color := CST_TEXT_INACTIF;
  li_CoordX := ((Rect.Right + Rect.Left) div 2) - (Statusbar.Canvas.TextWidth(Panel.Text) div 2);
  li_CoordY := ((Rect.Top  + Rect.Bottom) div 2) - (StatusBar.Canvas.TextHeight(Panel.Text) div 2);
  StatusBar.Canvas.TextRect(Rect, li_CoordX, li_CoordY, Panel.Text);
end;

procedure TF_FenetrePrincipale.tbar_voletCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  DisableAlign ;

end;

////////////////////////////////////////////////////////////////////////////////
//  Gestion de la femeture des barres de fonctions par la petite croix
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.tbar_voletClose(Sender: TObject);
begin
  mu_voletexplore.Checked := False;
//  pa_5.Width := 0;
  spl_volet.Hide;
  EnableAlign ;
end;

procedure TF_FenetrePrincipale.tbar_outilsClose(Sender: TObject);
begin
  mu_barreoutils.Checked := False;
end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion du splitter
////////////////////////////////////////////////////////////////////////////////
{
procedure TF_FenetrePrincipale.pa_5Resize(Sender: TObject);
begin
  if Assigned(tbar_volet.DockedTo) and tbar_volet.Visible then
    begin
      tbar_volet.Width := (Sender as TControl).Width;
      spl_volet.Left := pa_5.Width;
    end;
end;
}
procedure TF_FenetrePrincipale.tbar_voletDockChanged(Sender: TObject);
begin
  if Assigned(tbar_volet.DockedTo)
  and tbar_volet.Visible then
    Begin
//      pa_5.Width := tbar_volet.Width ;
      spl_volet.Show;
    End
  else
    Begin
//      pa_5.Width := 0;
      spl_volet.Hide;
    End ;

end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion des procédures virtuelles
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  En cas de problème sur la base de données
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_PbConnexion;
begin
  p_SetLedColor ( False );
  br_statusbar.Panels[2].Text := GS_LBL_PB;
  p_SetLengthSB(br_statusbar.Panels[2]);
end;

procedure TF_FenetrePrincipale.p_Connectee;
begin
  p_SetLedColor ( True );
  br_statusbar.Panels[2].Text := gs_User ;
  p_SetLengthSB(br_statusbar.Panels[2]);
end;

////////////////////////////////////////////////////////////////////////////////
//  Gestion des appuis sur les touches MAJ et Num
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_SortieMajNumScroll(const ab_MajEnfoncee,
                        			                	    ab_NumEnfoncee,
                        			                	    ab_ScrollEnfoncee: boolean);
begin
  br_statusbar.Panels.BeginUpdate ;
  if ab_MajEnfoncee then
    br_statusbar.Panels[5].Style := psText
  else
    br_statusbar.Panels[5].Style := psOwnerDraw;

  if ab_NumEnfoncee then
    br_statusbar.Panels[6].Style := psText
  else
    br_statusbar.Panels[6].Style := psOwnerDraw;

  br_statusbar.Panels.EndUpdate ;

  br_statusbar.Update;
  br_statusbar.Invalidate;
end;

////////////////////////////////////////////////////////////////////////////////
//  Sauvegarde des positions de la barre d'outils et du volet d'exploration
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_ApresSauvegardeParamIni;
begin
  if gb_AccesAuto then
    if gs_ModeConnexion = CST_MACHINE then
      IniSaveToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_computer  + '.INI', '')
    else
      IniSaveToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_sessionuser  + '.INI', '');

  if gb_Reinit then
    if gs_ModeConnexion = CST_MACHINE then
      DeleteFile(ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_computer  + '.INI')
    else
      DeleteFile(ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_sessionuser  + '.INI');
end;


////////////////////////////////////////////////////////////////////////////////
// procédure qui transfert les données local de l'édition
// vers les données globales utilisées par le preview
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_editionTransfertVariable(as_nom, as_titre,
  as_chemin: String; ats_edition_nom_params, ats_edition_params,
  ats_edition_params_values: TStrings);

var li_i:integer;
begin

  gs_edition_nom   := as_nom;
  gs_edition_titre  := as_titre;
  gs_edition_chemin := as_chemin;

  // si les paramètres sont vides on quitte la procédure
  if ats_edition_params_values = nil then exit;

  gs_edition_nom_params.Free;
  gs_edition_params.Free;
  gs_edition_params_values.Free;

  gs_edition_nom_params := nil ;
  gs_edition_params      := nil ;
  gs_edition_params_values := nil ;


  gs_edition_nom_params := TStringList.create();
  gs_edition_params := TStringList.create();
  gs_edition_params_values := TStringList.create();

  for li_i :=0 to ats_edition_params.count-1  do
  begin
    gs_edition_nom_params.Add('');
    gs_edition_params.add(ats_edition_params[li_i]);
    gs_edition_params_values.add(ats_edition_params_values[li_i]);
  end;


end;


function TF_FenetrePrincipale.CloseQuery: Boolean;
begin
  Result := inherited CloseQuery;
  if not ( csDesigning in ComponentState ) Then
    Result := fb_Fermeture and Result
end;

//////////////////////////////////////////////////////////////////////////
// fonction virtuelle : f_IniGetConfigFile
// Description : lecture du fichier INI et des fichiers XML
//////////////////////////////////////////////////////////////////////////
function TF_FenetrePrincipale.f_IniGetConfigFile({$IFNDEF CSV}acco_Conn: TComponent;{$ENDIF} as_NomConnexion: string): TMemIniFile;
Begin
  Result := inherited f_IniGetConfigFile({$IFNDEF CSV}acco_Conn,{$ENDIF} as_NomConnexion);
End;
//////////////////////////////////////////////////////////////////////////
// Procédure virtuelle : p_WriteDescendantIni
// Description : écriture de l'ini dans U_FenetrePrincipale à partir de U_FormMainIni
//////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_WriteDescendantIni(
  const amif_Init: TMemIniFile);
begin
  amif_Init.WriteString ( INISEC_PAR, GS_INI_NAME_FUSION1, GS_INI_PATH_FUSION1 );
  amif_Init.WriteString ( INISEC_PAR, GS_INI_NAME_FUSION2, GS_INI_PATH_FUSION2 );
  amif_Init.WriteString ( INISEC_PAR, GS_INI_NAME_FUSION , GS_INI_FILE_FUSION  );
  gs_FilePath_Fusion1 := GS_INI_PATH_FUSION1 ;
  gs_FilePath_Fusion2 := GS_INI_PATH_FUSION2 ;
  gs_File_TempFusion  := GS_INI_FILE_FUSION  ;
end;

//////////////////////////////////////////////////////////////////////////
// Procédure virtuelle : p_WriteDescendantIni
// Description : écriture de l'ini dans U_FenetrePrincipale à partir de U_FormMainIni
//////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_ReadDescendantIni(
  const amif_Init: TMemIniFile);
begin
  gs_FilePath_Fusion1 := amif_Init.ReadString ( INISEC_PAR, GS_INI_NAME_FUSION1, GS_INI_PATH_FUSION1 );
  gs_FilePath_Fusion2 := amif_Init.ReadString ( INISEC_PAR, GS_INI_NAME_FUSION2, GS_INI_PATH_FUSION2 );
  gs_File_TempFusion  := amif_Init.ReadString ( INISEC_PAR, GS_INI_NAME_FUSION , GS_INI_FILE_FUSION  );
end;

////////////////////////////////////////////////////////////////////////////////
// Evènement : mu_ReinitiliserpresentationClick
// Description :  Réinitialise la présentation de la fiche active à partir du menu fenêtre
// Paramètres  : Sender : Le MenuItem mei_Reinitiliserpresentation
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.mu_ReinitiliserpresentationClick(
  Sender: TObject);
var lfor_ActiveForm : TCustomForm ;
Begin
  lfor_ActiveForm := Self.ActiveMDIChild ;
  fb_ReinitWindow ( lfor_ActiveForm );
end;

{$IFDEF TNT}
procedure TF_FenetrePrincipale.p_OnClickMenuLang(Sender:TObject);
  var iIndex: Integer;
  begin
    iIndex := ( Sender as TMenuItem ).Tag;
    ChangeLanguage( iIndex );
    fb_ReadLanguage ( GetLanguageCode ( LangManager.LanguageID ));
  end;
{$ENDIF}
initialization
{$I U_FenetrePrincipale.lrs}
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_F_FenetrePrincipale );
{$ENDIF}
end.

