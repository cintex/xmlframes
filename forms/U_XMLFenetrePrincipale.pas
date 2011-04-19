
// ************************************************************************ //
// Dfm2Pas: WARNING!
// -----------------
// Part of the code declared in this file was generated from data read from
// a *.DFM file or a Delphi project source using Dfm2Pas 1.0.
// For a list of known issues check the README file.
// Send Feedback, bug reports, or feature requests to:
// e-mail: fvicaria@borland.com or check our Community website.
// ************************************************************************ //

unit U_XMLFenetrePrincipale;

{$I ..\Compilers.inc}
{$I ..\extends.inc}


{$IFDEF FPC}
{$mode Delphi}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

interface

uses
{$IFDEF ZEOS}
  ZConnection,
{$ENDIF}
{$IFDEF FPC}
   LCLIntf, LCLType, SQLDB, PCheck,
{$ELSE}
  Windows, OleDB, JvComponent, StoHtmlHelp, JvScrollBox,
  extdock, ExtTBTlbr, ImgList,
  JvExExtCtrls, JvSplitter, JvLED, U_ExtScrollBox,
  StdActns, JvExForms, JvExControls, JvXPCore, Messages,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
  TntDBCtrls, TntStdCtrls, DKLang,
  TntDialogs, TntGraphics, TntForms,
  TntMenus, TntExtCtrls, TntStdActns,
  TntActnList,
{$ENDIF}
  u_multidonnees,
  Controls, Graphics, Classes, SysUtils, StrUtils,
  ExtCtrls, ActnList, Menus,
  JvXPContainer, ComCtrls, JvXPButtons,
  IniFiles, Dialogs, Printers,
  JvXPBar, Forms,  U_FormMainIni, fonctions_init,
  fonctions_Objets_Dynamiques, fonctions_ObjetsXML,
  u_buttons_appli, fonctions_string,
  U_OnFormInfoIni, DBCtrls;

{$IFDEF VERSIONS}
const
    gVer_F_FenetrePrincipale : T_Version = ( Component : 'Fenêtre principale XML' ;
       			                 FileUnit : 'U_XMLFenetrePrincipale' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre principale utilisée pour la gestion automatisée à partir du fichier INI, avec des menus composés à partir des données.' + #13#10 + 'Elle dépend du composant Fenêtre principale qui lui n''est pas lié à l''application.' ;
      			                 BugsStory : 'Version 0.1.0.1 : No ExtToolbar on LAZARUS.' + #13#10
                                                   + 'Version 0.1.0.0 : Création à partir de U_FenetrePrincipale' ;
			                 UnitType : CST_TYPE_UNITE_FICHE ;
			                 Major : 0 ; Minor : 1 ; Release : 0 ; Build : 1 );
{$ENDIF}

type

  { TF_FenetrePrincipale }

  TF_FenetrePrincipale = class(TF_FormMainIni)
    mu_apropos: TMenuItem;
    mu_cascade: TMenuItem;
    mu_MainMenu: {$IFDEF TNT}TTntMainMenu{$ELSE}TMainMenu{$ENDIF};
    mu_file: TMenuItem;
    mu_mosaiqueh: TMenuItem;
    mu_mosaiquev: TMenuItem;
    mu_organiser: TMenuItem;
    mu_ouvrir: TMenuItem;
    mu_sep1: TMenuItem;
    mu_quitter: TMenuItem;
    mu_fenetre: TMenuItem;
    mu_reduire: TMenuItem;
    mu_affichage: TMenuItem;
    mu_barreoutils: TMenuItem;
    mu_voletexplore: TMenuItem;
    mu_aide: TMenuItem;
    mu_ouvriraide: TMenuItem;
    mu_sep2: TMenuItem;
    mu_Reinitiliserpresentation: TMenuItem;
    mu_sep3: TMenuItem;

    ActionList: {$IFDEF TNT}TTntActionList{$ELSE}TActionList{$ENDIF};
    pa_2: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    tbsep_4: TPanel;
    {$IFDEF MDI}
    WindowCascade: {$IFDEF TNT}TTntWindowCascade{$ELSE}TWindowCascade{$ENDIF};
    WindowTileHorizontal: {$IFDEF TNT}TTntWindowTileHorizontal{$ELSE}TWindowTileHorizontal{$ENDIF};
    WindowTileVertical: {$IFDEF TNT}TTntWindowTileVertical{$ELSE}TWindowTileVertical{$ENDIF};
    WindowMinimizeAll: {$IFDEF TNT}TTntWindowMinimizeAll{$ELSE}TWindowMinimizeAll{$ENDIF};
    WindowArrangeAll: {$IFDEF TNT}TTntWindowArrange{$ELSE}TWindowArrange{$ENDIF};
    {$ENDIF}

    Timer: TTimer;
    SvgFormInfoIni: TOnFormInfoIni;
    im_Liste: TImageList;

    {$IFDEF FPC}
    spl_volet: TSplitter;
    {$ELSE}
    dock_outils: TDock;
    dock_volet: TDock;
    {$ENDIF}
    tbsep_1: {$IFDEF FPC}TPanel{$ELSE}TExtToolbarSep{$ENDIF};
    tbsep_3: {$IFDEF FPC}TPanel{$ELSE}TExtToolbarSep{$ENDIF};
    tbsep_2: {$IFDEF FPC}TPanel{$ELSE}TExtToolbarSep{$ENDIF};
    tbar_outils: {$IFDEF FPC}TToolbar{$ELSE}TExtToolbar{$ENDIF};
    tbar_volet: {$IFDEF FPC}TToolbar{$ELSE}TExtToolbar{$ENDIF};

    pa_1: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    pa_3: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    pa_4: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    dbt_ident: TJVXPButton;
    dbt_quitter: TJvXPButton;
    dbt_aide: TJVXPButton;

    br_statusbar: TStatusBar;

    im_led: {$IFDEF FPC}TPCheck{$ELSE}TJvLED{$ENDIF};
    mu_identifier: TMenuItem;
    im_appli: TImage;
    im_acces: TImage;
    im_about: TImage;
    mu_langue: TMenuItem;
    scb_Volet: TScrollBox;

    procedure pa_5Resize(Sender: TObject);
    procedure p_ChargeAide;
    procedure p_OnClickFonction(Sender: TObject);
    procedure p_OnClickMenuLang(Sender:TObject);
    procedure p_SetLengthSB(ao_SP: TStatusPanel);
    procedure F_FormMainIniActivate(Sender: TObject);
    procedure F_FormMainIniResize(Sender: TObject);
    procedure DoClose ( var AAction: TCloseAction ); override;

    procedure dbt_identClick(Sender: TObject);
    procedure dbt_aideClick(Sender: TObject);
    procedure dbt_quitterClick(Sender: TObject);

    procedure mu_barreoutilsClick(Sender: TObject);
    procedure mu_voletexploreClick(Sender: TObject);
    procedure mu_aproposClick(Sender: TObject);
    procedure SvgFormInfoIniIniLoad( const AInifile: TCustomInifile;
      var Continue: Boolean);
    procedure SvgFormInfoIniIniWrite(const AInifile: TCustomInifile;
      var Continue: Boolean);

    procedure TimerTimer(Sender: TObject);
    procedure br_statusbarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
                        			      const Rect: TRect);

    procedure tbar_voletClose(Sender: TObject);
    procedure tbar_outilsClose(Sender: TObject);

    procedure tbar_voletDockChanged(Sender: TObject);
    function CloseQuery: Boolean; override;
    procedure mu_ReinitiliserpresentationClick(Sender: TObject);

  private

    { Déclarations privées }
    lb_MsgDeconnexion : Boolean ;

    procedure mu_voletchange(const ab_visible: Boolean);
    procedure p_SetLedColor(const ab_Status: Boolean );
{$IFNDEF FPC}
    procedure WMHelp (var Message: TWMHelp); message WM_HELP;
{$ENDIF}

  public
    procedure p_AccesstoSoft; virtual;
    procedure DoShow ; override;
    function f_IniGetConfigFile( {$IFNDEF CSV}acco_Conn: TComponent;{$ENDIF} as_NomConnexion: string): TIniFile; override;
    { Déclarations publiques }
    // Procédures qui sont appelées automatiquement pour l'initialisation et la sauvegarde
    Constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure   p_PbConnexion; override;
    procedure   p_Connectee; override;
    procedure   p_WriteDescendantIni(const amif_Init: TIniFile); override;
    procedure   p_ReadDescendantIni (const amif_Init: TIniFile); override;
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
  fonctions_xml,
  fonctions_FenetrePrincipale,
  unite_variables, unite_messages,
  fonctions_proprietes ;


////////////////////////////////////////////////////////////////////////////////
//  Fonctions et procédures générales
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  Recherche du nom de l'executable pour aller
//  chercher la bonne fonction d'initialisation
////////////////////////////////////////////////////////////////////////////////
Constructor TF_FenetrePrincipale.Create(AOwner: TComponent);
{$IFNDEF TNT}
var li_Language : Longint;
{$ENDIF}
begin
  inherited ;
  AutoIni   := True;
  AutoIniDB := False;
  if ( csDesigning in ComponentState ) Then
    Exit ;
{$IFDEF TNT}
  p_RegisterLanguages ( mu_langue );
{$ELSE}
  p_RegisterALanguage ( 'en', 'English' );
  p_RegisterALanguage ( 'fr', 'Français' );
  p_RegisterALanguage ( 'en', 'Español' );
  CreateLanguagesController ( mu_langue );
{$ENDIF}
  {$IFDEF TNT}
  {$ELSE}
  li_Language := fi_findLanguage(gs_Language);
  ChangeLanguage( li_Language );
  {$ENDIF}

  gs_DefaultUser := gmif_MainFormIniInit.Readstring ( INISEC_PAR, INISEC_UTI, '' );

  SvgFormInfoIni.LaFormCreate ( Self );
  // Lecture des infos des composants du fichier INI
  SvgFormInfoIni.ExecuteLecture(True);

    // Initialisation de l'aide et des libellés de la barre de status
  p_ChargeAide;
  p_LibStb ( br_statusbar );

  // Initialisation des variables
  gs_computer      := f_IniFWReadComputerName;
  gs_sessionuser   := f_IniFWReadUtilisateurSession;

  // Initialisation du composant de fabrication dynamique de fonctions
  p_initialisationBoutons(Self, mu_langue, scb_volet, mu_voletexplore,
                          nil, tbar_outils, tbsep_1, pa_2, CST_LARGEUR_PANEL,
                          nil, mu_ouvrir, im_Liste, im_Liste.Count);

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
      try
          p_DetruitTout ( False );

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
//  Gestion du splitter
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.pa_5Resize(Sender: TObject);
begin
{$IFNDEF FPC}
//  p_pa_5Resize( Sender, pa_5, tbar_volet, tbar_outils, dock_volet, spl_volet);
{$ENDIF}

end;

////////////////////////////////////////////////////////////////////////////////
//  Gestion du splitter
////////////////////////////////////////////////////////////////////////////////

procedure TF_FenetrePrincipale.tbar_voletDockChanged(Sender: TObject);
begin

//  p_tbar_voletDockChanged( pa_5, tbar_volet, tbar_outils, spl_volet);

end;


////////////////////////////////////////////////////////////////////////////////
//  Gestion des procédures virtuelles
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//  En cas de problème sur la base de données
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_PbConnexion;
begin
  p_formPbConnexion ( im_led, br_statusbar);
  p_SetLengthSB(br_statusbar.Panels[2]);
end;

procedure TF_FenetrePrincipale.p_Connectee;
begin
  p_FormConnectee ( im_led, br_statusbar);
  p_SetLengthSB(br_statusbar.Panels[2]);
end;

////////////////////////////////////////////////////////////////////////////////
//  Gestion des appuis sur les touches MAJ et Num
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_SortieMajNumScroll(const ab_MajEnfoncee,
                        			                	    ab_NumEnfoncee,
                        			                	    ab_ScrollEnfoncee: boolean);
begin
  p_FormSortieMajNumScroll (br_statusbar, ab_MajEnfoncee, ab_NumEnfoncee, ab_scrollEnfoncee );
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

////////////////////////////////////////////////////////////////////////////////
//  Méthodes liées à la forme
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.F_FormMainIniActivate(Sender: TObject);
begin
  // Identification par la fenêtre de Login uniquement au démarrage de l'application
  if gb_FirstAcces then
    begin
      // Initialisation de la toolbar mauvaise si dans le create et si maximised
{$IFNDEF FPC}
      if gs_ModeConnexion = CST_MACHINE then
        IniLoadToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_computer  + '.INI', '')
      else
        IniLoadToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_sessionuser  + '.INI', '');
{$ENDIF}

      // Init. du menu barre de fonction checked ou pas
      mu_barreoutils.Checked := tbar_outils.Visible;

      dbt_identClick(Sender);
    end;
end;

procedure TF_FenetrePrincipale.F_FormMainIniResize(Sender: TObject);
begin
//  F_FormResize ( Self, tbar_outils,pa_2, tbsep_2, br_statusbar, im_led);
end;

procedure TF_FenetrePrincipale.DoClose ( var AAction: TCloseAction );
begin
   DoCloseFenetrePrincipale ( Self );
   inherited ;
end;



////////////////////////////////////////////////////////////////////////////////
//  Gestion des boutons de la barre d'outils
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.dbt_identClick(Sender: TObject);
begin
  if lb_MsgDeconnexion
  and ( MessageDlg ( GS_DECONNECTER, mtConfirmation, [ mbYes, mbNo ], 0 ) = mrNo ) Then
    Exit ;
  // (Ré)initialisation de l'application
  Screen.Cursor := crSQLWait;
  p_FreeChildForms;
  p_DetruitTout ( True );
  if not gb_FirstAcces then p_SauveIni; // On libère le fichier INI sauf à la 1ère ouverture
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
//  mu_voletchange ( False );

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

  p_connectToData;

end;

// Connexion aux données de l'application
procedure TF_FenetrePrincipale.p_ConnectToData ();
begin
  F_splashForm.Free;
  F_splashForm := nil ;
  Screen.Cursor := crSQLWait;

  fb_ReadXMLEntitites ();

End;

procedure  TF_FenetrePrincipale.p_AccesstoSoft;
Begin
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
  gb_FirstAcces := False;
  tbar_voletDockChanged ( tbar_volet );
End;
procedure TF_FenetrePrincipale.p_SetLedColor( const ab_Status : Boolean );
begin
  try
    im_led.{$IFDEF FPC}Checked{$ELSE}Status{$ENDIF} := ab_Status ;
  Except
  End ;
end;

procedure TF_FenetrePrincipale.DoShow;
begin
  inherited DoShow;
  p_ConnectToData ;
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
  mu_voletchange( not mu_voletexplore.Checked );
end;

procedure TF_FenetrePrincipale.mu_voletchange(const ab_visible : Boolean);
begin
  mu_voletexplore.Checked := ab_visible;
{$IFNDEF FPC}
  tbar_volet.Visible := ab_visible;
  dock_volet.Visible := ab_visible;
//  pa_5      .Visible := ab_visible;
//  spl_volet .Visible := ab_visible;
  if tbar_volet.Visible then
    tbar_voletDockChanged(Self);
{$ENDIF}
//  spl_volet.Left := pa_5.Width;
end;

////////////////////////////////////////////////////////////////////////////////
//  Boîte de dialogue à propos
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.mu_aproposClick(Sender: TObject);
begin
{$IFDEF VERSIONS}
  gb_Reinit := fb_AfficheApropos ( False, gs_NomAppli, gs_Version );
{$ENDIF}
end;




procedure TF_FenetrePrincipale.SvgFormInfoIniIniLoad( const
   AInifile: TCustomInifile; var Continue: Boolean);
begin
  AInifile.ReadBool ( 'F_FenetrePrincipale', 'tbar_outils.Visible', tbar_outils.Visible );
  tbar_outils    .Visible := AInifile.ReadBool ( 'F_FenetrePrincipale', 'tbar_outils.Visible', tbar_outils.Visible );
  mu_voletchange ( AInifile.ReadBool ( 'F_FenetrePrincipale',  'tbar_volet.Visible', mu_voletexplore.Checked ));
end;

procedure TF_FenetrePrincipale.SvgFormInfoIniIniWrite(
  const AInifile: TCustomInifile; var Continue: Boolean);
begin
  AInifile.WriteBool ( 'F_FenetrePrincipale', 'tbar_volet.Visible' , tbar_volet.Visible );
  AInifile.WriteBool ( 'F_FenetrePrincipale', 'tbar_outils.Visible', tbar_outils.Visible );

end;

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
  Panel: TStatusPanel; const Rect: TRect);
begin
  p_statusbarDrawPanel( StatusBar, Panel, Rect );
end;

////////////////////////////////////////////////////////////////////////////////
//  Gestion de la femeture des barres de fonctions par la petite croix
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.tbar_voletClose(Sender: TObject);
begin
  mu_voletchange( False );
end;

procedure TF_FenetrePrincipale.tbar_outilsClose(Sender: TObject);
begin
  mu_barreoutils.Checked := False;
end;

////////////////////////////////////////////////////////////////////////////////
//  Sauvegarde des positions de la barre d'outils et du volet d'exploration
////////////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_ApresSauvegardeParamIni;
begin
  {$IFNDEF FPC}
  if gb_AccesAuto then
    if gs_ModeConnexion = CST_MACHINE then
      IniSaveToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_computer  + '.INI', '')
    else
      IniSaveToolbarPositions(Self, ExtractFilePath(Application.ExeName) + CST_Avant_Fichier + gs_sessionuser  + '.INI', '');

  {$ENDIF}
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
    Result := fb_Fermeture ( Self ) and Result
end;

//////////////////////////////////////////////////////////////////////////
// fonction virtuelle : f_IniGetConfigFile
// Description : lecture du fichier INI et des fichiers XML
//////////////////////////////////////////////////////////////////////////
function TF_FenetrePrincipale.f_IniGetConfigFile({$IFNDEF CSV}acco_Conn: TComponent;{$ENDIF} as_NomConnexion: string): TIniFile;
Begin
  Result := inherited f_IniGetConfigFile({$IFNDEF CSV}acco_Conn,{$ENDIF} as_NomConnexion);
End;
//////////////////////////////////////////////////////////////////////////
// Procédure virtuelle : p_WriteDescendantIni
// Description : écriture de l'ini dans U_FenetrePrincipale à partir de U_FormMainIni
//////////////////////////////////////////////////////////////////////////
procedure TF_FenetrePrincipale.p_WriteDescendantIni(
  const amif_Init: TIniFile);
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
  const amif_Init: TIniFile);
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

procedure TF_FenetrePrincipale.p_OnClickMenuLang(Sender:TObject);
  var iIndex: Integer;
begin
    iIndex := ( Sender as TMenuItem ).Tag;
    ChangeLanguage( iIndex );
    fb_ReadLanguage ( {$IFDEF TNT}GetLanguageCode ( LangManager.LanguageID ){$ELSE}ga_SoftwareLanguages [ iIndex ].LittleLang{$ENDIF});
end;
initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_F_FenetrePrincipale );
{$ENDIF}
end.
