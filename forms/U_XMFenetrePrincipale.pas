{$DEFINE CLR}

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
{$ENDIF}

interface

uses
{$IFDEF ZEOS}
  ZConnection,
{$ENDIF}
{$IFDEF EADO}
  ADODB,
{$ENDIF}
{$IFDEF FPC}
   LCLIntf, LCLType, SQLDB, PCheck,
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
  u_multidonnees,
  Controls, Graphics, Classes, SysUtils, StrUtils,
  ExtCtrls, ActnList, Menus,
  JvXPContainer, ComCtrls, JvXPButtons,
  IniFiles, Dialogs, Printers,
  JvXPBar, Forms,  U_FormMainIni, fonctions_init,
  fonctions_Objets_Dynamiques, fonctions_ObjetsXML,
  u_buttons_appli, fonctions_string,
  U_OnFormInfoIni, DBCtrls ;

{$IFDEF VERSIONS}
const
    gVer_F_XMLFenetrePrincipale : T_Version = ( Component : 'Fenêtre principale XML' ;
       			                 FileUnit : 'U_XMLFenetrePrincipale' ;
       			                 Owner : 'Matthieu Giroux' ;
       			                 Comment : 'Fenêtre principale utilisée pour la gestion automatisée à partir du fichier INI, avec des menus composés à partir des données.' + #13#10 + 'Elle dépend du composant Fenêtre principale qui lui n''est pas lié à l''application.' ;
      			                 BugsStory : 'Version 0.1.0.0 : Création à partir de U_FenetrePrincipale' ;
			                 UnitType : CST_TYPE_UNITE_FICHE ;
			                 Major : 0 ; Minor : 1 ; Release : 0 ; Build : 0 );
{$ENDIF}

type
  TF_FenetrePrincipale = class(TF_FormMainIni)

    mu_MainMenu: {$IFDEF TNT}TTntMainMenu{$ELSE}TMainMenu{$ENDIF};
    mu_file: TMenuItem;
    mu_langue: TMenuItem;
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
    pa_main: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    sb_forms: TSCrollBox;
    dbt_ident: TJVXPButton;
    dbt_quitter: TFWQuit;
    dbt_aide: TJVXPButton;

    br_statusbar: TStatusBar;

    im_led: {$IFDEF FPC}TPCheck{$ELSE}TJvLED{$ENDIF};
    mu_identifier: TMenuItem;
    pa_5: {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF};
    tbar_volet: TExtToolbar;
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

    procedure F_FormMainIniActivate(Sender: TObject);
    procedure F_FormMainIniResize(Sender: TObject);
    procedure DoClose ( var AAction: TCloseAction ); override ;

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

    procedure pa_5Resize(Sender: TObject);
    procedure tbar_voletDockChanged(Sender: TObject);
    procedure tbar_voletCloseQuery(Sender: TObject; var CanClose: Boolean);
    function CloseQuery: Boolean; override ;
    procedure mu_ReinitiliserpresentationClick(Sender: TObject);

  private

    { Déclarations privées }
    lb_MsgDeconnexion : Boolean ;

{$IFDEF CLR}
    procedure InitializeControls;
{$ENDIF}
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
    procedure   p_WriteDescendantIni(const amif_Init: TMemIniFile); override ;
    procedure   p_ReadDescendantIni (const amif_Init: TMemIniFile); override ;
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
  unite_variables, unite_messages,
  fonctions_proprietes ;

{$IFNDEF CLR}
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
  if not ( csDesigning in ComponentState ) Then
    Try
      // On arrive pour la première fois sur la forme
      gb_FirstAcces := True;

      // Recherche du nom de l'application
      lb_MsgDeconnexion := False ;
      GlobalNameSpace.BeginWrite;
      {$IFDEF FPC}
      CreateNew(AOwner,0 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      {$IFDEF CLR}
        InitializeControls;
      {$ENDIF}
      DoCreate;
      AutoIniDB   := False ;
      AutoIni     := True ;
      p_CreeFormMainIni (AOwner);
      f_IniGetSessionFile ;
      F_FenetrePrincipale := Self ;

    Finally
      GlobalNameSpace.EndWrite;
    End
  Else
   inherited ;

  {$IFDEF TNT}
  p_RegisterLanguages ( mu_langue );
  {$ENDIF}

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
  pa_5.Width := 0;
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
      pa_5.Width := 0;
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
  pa_5.Width := 0;
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

procedure TF_FenetrePrincipale.pa_5Resize(Sender: TObject);
begin
  if Assigned(tbar_volet.DockedTo) and tbar_volet.Visible then
    begin
      tbar_volet.Width := (Sender as TControl).Width;
      spl_volet.Left := pa_5.Width;
    end;
end;

procedure TF_FenetrePrincipale.tbar_voletDockChanged(Sender: TObject);
begin
  if Assigned(tbar_volet.DockedTo)
  and tbar_volet.Visible then
    Begin
      pa_5.Width := tbar_volet.Width ;
      spl_volet.Show;
    End
  else
    Begin
      pa_5.Width := 0;
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

{$IFDEF CLR}
procedure TF_FenetrePrincipale.InitializeControls;
begin
  pa_main := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  sb_forms := TSCrollBox.Create(Self);
  // Initalizing all controls...
  im_led := {$IFDEF FPC}TPCheck{$ELSE}TJvLED{$ENDIF}.Create(Self);
  spl_volet :={$IFDEF FPC}TSplitter{$ELSE}TJvSplitter{$ENDIF}.Create(Self);
//  gxdo_FichierXML.Encoding := gs_Encoding;
  im_appli := TImage.Create(Self);
  im_acces := TImage.Create(Self);
  im_about := TImage.Create(Self);
  dock_outils := TDock.Create(Self);
  dock_volet := TDock.Create(Self);
  tbar_outils := TExtToolbar.Create(Self);
  tbsep_3 := TExtToolbarSep.Create(Self);
  tbsep_1 := TExtToolbarSep.Create(Self);
  tbsep_2 := TExtToolbarSep.Create(Self);
  pa_4 := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  dbt_quitter := TFWQuit.Create(Self);
  pa_1 := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  dbt_ident := TJVXPButton.Create(Self);
  pa_2 := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  pa_3 := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  dbt_aide := TJVXPButton.Create(Self);
  br_statusbar := TStatusBar.Create(Self);
  pa_5 := {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}.Create(Self);
  tbar_volet := TExtToolBar.Create(Self);
  scb_Volet := {$IFDEF FPC}TScrollBox{$ELSE}TExtScrollBox{$ENDIF}.Create(Self);
  im_Liste := TImageList.Create(Self);
  mu_MainMenu := {$IFDEF TNT}TTntMainMenu{$ELSE}TMainMenu{$ENDIF}.Create(Self);
  mu_langue := TMenuItem.Create(Self);
  mu_file := TMenuItem.Create(Self);
  mu_identifier := TMenuItem.Create(Self);
  mu_ouvrir := TMenuItem.Create(Self);
  mu_sep1 := TMenuItem.Create(Self);
  mu_quitter := TMenuItem.Create(Self);
  mu_fenetre := TMenuItem.Create(Self);
  mu_Reinitiliserpresentation := TMenuItem.Create(Self);
  mu_Sep3 := TMenuItem.Create(Self);
  mu_reduire := TMenuItem.Create(Self);
  mu_affichage := TMenuItem.Create(Self);
  mu_barreoutils := TMenuItem.Create(Self);
  mu_voletexplore := TMenuItem.Create(Self);
  mu_aide := TMenuItem.Create(Self);
  mu_ouvriraide := TMenuItem.Create(Self);
  mu_sep2 := TMenuItem.Create(Self);
  {$IFDEF VERSIONS}
  mu_apropos := TMenuItem.Create(Self);
  {$ENDIF}
  ActionList := {$IFDEF TNT}TTntActionList{$ELSE}TActionList{$ENDIF}.Create(Self);
  {$IFNDEF FPC}
  mu_organiser := TMenuItem.Create(Self);
  mu_cascade := TMenuItem.Create(Self);
  mu_mosaiqueh := TMenuItem.Create(Self);
  mu_mosaiquev := TMenuItem.Create(Self);
  WindowCascade := TWindowCascade.Create(Self);
  WindowTileHorizontal := TWindowTileHorizontal.Create(Self);
  WindowTileVertical := TWindowTileVertical.Create(Self);
  WindowMinimizeAll := TWindowMinimizeAll.Create(Self);
  WindowArrangeAll := TWindowArrange.Create(Self);
  {$ENDIF}
  Timer := TTimer.Create(Self);
  SvgFormInfoIni := TOnFormInfoIni.Create(Self);
  im_icones := TImageList.Create(Self);

  with pa_main do
    Begin
      Name := 'pa_main';
      Parent := Self;
      Align := alClient;
      BevelOuter := bvNone;
    end;
  dock_outils.Parent := Self;
  dock_volet .Parent := Self;

  pa_1.Parent := tbar_outils ;
  tbsep_1.Parent := tbar_outils ;
  pa_2.Parent := tbar_outils ;
  tbsep_2.Parent := tbar_outils ;
  pa_3.Parent := tbar_outils ;
  tbsep_3.Parent := tbar_outils ;
  pa_4.Parent := tbar_outils ;


  with im_led do
  begin
    Name := 'im_led';
    Parent := Self;
    SetOrdProp(im_led, 'Left', 120);
    SetOrdProp(im_led, 'Top', 408);
    AutoSize := True;
    HelpContext := 1460 ;
    Color := clRed;
    Visible := False;
  end;

  with spl_volet do
  begin
    Name := 'spl_volet';
    Parent := pa_main;
    Align := alLeft;
    Left := 197;
    SetOrdProp(spl_volet, 'Top', 45);
    SetOrdProp(spl_volet, 'Width', 5);
    SetOrdProp(spl_volet, 'Height', 431);
  end;

  with im_appli do
  begin
    Name := 'im_appli';
    Parent := Self;
    Left := 248;
    Top := 104;
    Width := 49;
    Height := 49;
    AutoSize := True;
    Visible := False;
  end;

  with im_acces do
  begin
    Name := 'im_acces';
    Parent := Self;
    Left := 312;
    Top := 104;
    Width := 49;
    Height := 49;
    AutoSize := True;
    Visible := False;
  end;

  with im_about do
  begin
    Name := 'im_about';
    Parent := Self;
    Left := 376;
    Top := 104;
    Width := 49;
    Height := 49;
    AutoSize := True;
    Visible := False;
  end;

  with dock_outils do
  begin
    Name := 'dock_outils';
    Left := 0 ;
    Top := 0;
    Width := 765;
    Height := 45;
    Position := dpTop;
  end;

  with tbar_outils do
  begin
    Name := 'tbar_outils';
    Left := 0 ;
    Top := 0;
    Caption := 'Barre d'#39'acc'#232's';
    DockableTo := [dpTop];
    Hint := 'Cliquez sur un bouton pour accéder à une fonction' ;
    ParentShowHint := False ;
    ShowHint := True ;
    HelpContext := 1430 ;
    DockPos := 0;
    FullSize := True;
    TabOrder := 0;
    DefaultDock:= dock_outils;
    DockMode := dmCanFloat;
    Parent:= dock_outils;
    UseLastDock := True;
    OnClose := tbar_outilsClose;
    OnDockChanged := F_FormMainIniResize;
  end;

  with tbsep_3 do
  begin
    Name := 'tbsep_3';
    SetOrdProp(tbsep_3, 'Left', 656);
    SetOrdProp(tbsep_3, 'Top', 0);
  end;

  with tbsep_1 do
  begin
    Name := 'tbsep_1';
    SetOrdProp(tbsep_1, 'Left', 57);
    SetOrdProp(tbsep_1, 'Top', 0);
  end;

  with tbsep_2 do
  begin
    Name := 'tbsep_2';
    SetOrdProp(tbsep_2, 'Left', 593);
    SetOrdProp(tbsep_2, 'Top', 0);
  end;

  with pa_4 do
  begin
    Name := 'pa_4';
    Left := 662;
    Top := 0;
    Width := 57;
    Height := 41;
    Align := alRight;
    BevelOuter := bvNone;
    TabOrder := 0;
  end;

  with dbt_quitter do
  begin
    Name := 'dbt_quitter';
    Parent := pa_4;
    Caption := '' ;
    Left := 9;
    Top := 0;
    Width := 41;
    Height := 41;
    Hint := 'Quitter';
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    ParentFont := False;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := dbt_quitterClick;
    TabOrder := 0;
  end;

  with pa_1 do
  begin
    Name := 'pa_1';
    HelpContext := 1430 ;
    Left := 0;
    Top := 0;
    Width := 57;
    Height := 41;
    BevelOuter := bvNone;
    TabOrder := 1;
  end;

  with dbt_ident do
  begin
    Name := 'dbt_ident' ;
    Caption := '' ;
    Parent  := pa_1 ;
    Left := 9;
    Top := 0;
    Width := 41;
    Height := 41;
    Hint := 'S'#39'identifier/d'#233'connecter|Ouvrir la fen'#234'tre d'#39'identification';
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    HelpContext := 1430 ;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    ParentFont := False;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := dbt_identClick;
    TabOrder := 0;
    Layout := blGlyphRight;
    Name := 'dbt_ident';
  end;

  with pa_2 do
  begin
    Name := 'pa_2';
    Left := 63;
    Top := 0;
    HelpContext := 1430 ;
    Width := 530;
    Height := 41;
    BevelOuter := bvNone;
    TabOrder := 2;
  end;

  with pa_3 do
  begin
    Name := 'pa_3';
    Left := 599;
    Top := 0;
    HelpContext := 1430 ;
    Width := 57;
    Height := 41;
    Align := alRight;
    BevelOuter := bvNone;
    TabOrder := 3;
  end;

  with dbt_aide do
  begin
    Name := 'dbt_aide' ;
    Caption := '' ;
    Parent  := pa_3 ;
    Left := 9;
    Top := 0;
    Width := 41;
    Height := 41;
    Hint := 'Ouvrir l'#39'aide|Rubrique d'#39'aide';
    Align := alCustom;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    HelpContext := 1430 ;
    ParentFont := False;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := dbt_aideClick;
    TabOrder := 0;
    Layout := blGlyphRight;
    Spacing := 0;
    Name := 'dbt_aide';
  end;

  with br_statusbar do
  begin
    Name := 'br_statusbar';
    Parent := Self;
    Left := 0;
    Top := 476;
    Width := 765;
    Height := 19;
    HelpContext := 1460 ;
    AutoHint := True;
    BiDiMode := bdRightToLeft;
    Panels.Add;
    Panels[0].Width := 300;
    Panels.Add;
    Panels[1].Width := 20;
    Panels.Add;
    Panels[2].Alignment := taCenter;
    Panels[2].Width := 100;
    Panels.Add;
    Panels[3].Alignment := taCenter;
    Panels[3].Width := 70;
    Panels.Add;
    Panels[4].Alignment := taCenter;
    Panels[4].Text := '88:88';
    Panels[4].Width := 40;
    Panels.Add;
    Panels[5].Alignment := taCenter;
    Panels[5].Text := 'MAJ';
    Panels[5].Width := 35;
    Panels.Add;
    Panels[6].Alignment := taCenter;
    Panels[6].Text := 'Num';
    Panels[6].Width := 35;
    Panels.Add;
    Panels[7].Alignment := taCenter;
    Panels[7].Bevel := pbNone;
    Panels[7].Width := 5;
    ParentBiDiMode := False;
    {$IFNDEF FPC}
    OnDrawPanel := br_statusbarDrawPanel;
    {$ENDIF}
  end;


  with pa_5 do
  begin
    Name := 'pa_5';
    Parent := Self;
    Left := 0;
    Top := 45;
    Width := 197;
    Height := 431;
    Align := alLeft;
    BevelOuter := bvNone;
    TabOrder := 2;
    OnResize := pa_5Resize;
  end;

  with dock_volet do
  begin
    Name := 'dock_volet';
    Parent := pa_5 ;
    HelpContext := 1440 ;
    Position := dpLeft;
    Left := 0 ;
    Top := 0;
    Width := 197;
    Height:= 431;
    Hint := 'Visionnez ici votre barre d''outils';
    ParentShowHint := False;
    ShowHint := True;
  end;

  with tbar_volet do
  begin
    Name := 'tbar_volet';
    Parent := dock_volet ;
    Left := 0 ;
    Top := 0;
    Width := 197;
    Caption := 'Volet d'#39'acc'#232's';
    HelpContext := 1440 ;
    DockableTo := [dpLeft];
    DefaultDock:= dock_volet;
    DockPos := 0;
//    FloatingMode := fmOnTopOfAllForms;
    FullSize := True;
    FullSize := True;
    OnCloseQuery := tbar_voletCloseQuery ;
    OnClose := tbar_voletClose;
    OnDockChanged := tbar_voletDockChanged;
    Hint := 'Visionnez ici votre barre d''outils';
    ParentShowHint := False;
    ShowHint := True;
  end;

  with scb_Volet do
  begin
    AutoScroll := True ;
    Name := 'scb_Volet';
    Parent := tbar_volet;
    Left := 0;
    Top := 0;
    Width := 193;
    Height := 413;
    HelpContext := 1440 ;
    Hint := 'Cliquer pour accéder aux fonctions';
    HorzScrollBar.Smooth := True;
    {$IFDEF DELHPI}
    HorzScrollBar.Style := ssFlat;
    HorzScrollBar.Tracking := False;
    VertScrollBar.Style := ssFlat;
    VertScrollBar.Tracking := False;
    HotTrack := False;
    {$ENDIF}
    VertScrollBar.Smooth := True;
    Align := alClient;
    BorderStyle := bsNone;
    Constraints.MinHeight := 10;
    Constraints.MinWidth := 10;
    DockSite := True;
    Color := clGradientInactiveCaption;
    ParentColor := False;
    ParentShowHint := False;
    ShowHint := True;
    TabOrder := 0;
  end;

  with im_Liste do
  begin
    Name := 'im_Liste';
  end;

  with mu_MainMenu do
  begin
    Name := 'mu_MainMenu';
    HelpContext := 1420 ;
    Images := im_Liste;
  end;

  with mu_file do
  begin
    Name := 'mu_file';
    HelpContext := 1420 ;
    mu_MainMenu.Items.Add(mu_file);
    Caption := '&Application';
    Hint := 'Fermeture des fen'#234'tres ou de l'#39'application';
  end;

  with mu_langue do
  begin
    Name := 'mu_langue';
    HelpContext := 1421 ;
    mu_MainMenu.Items.Add(mu_langue);
    Caption := '&Langue';
    Hint := 'Language';
  end;

  with mu_identifier do
  begin
    Name := 'mu_identifier';
    HelpContext := 1420 ;
    mu_file.Add(mu_identifier);
    Caption := 'S'#39'&identifier';
    Hint := 'Ouvrir la fen'#234'tre d'#39'identification';
    OnClick := dbt_identClick;
  end;

  with mu_ouvrir do
  begin
    Name := 'mu_ouvrir';
    mu_file.Add(mu_ouvrir);
    Caption := '&Ouvrir';
    HelpContext := 1420 ;
    Hint := 'Ouvrir une fonction';
    Visible := False;
  end;

  with mu_sep1 do
  begin
    Name := 'mu_sep1';
    HelpContext := 1420 ;
    mu_file.Add(mu_sep1);
    Caption := '-';
  end;

  with mu_quitter do
  begin
    Name := 'mu_quitter';
    mu_file.Add(mu_quitter);
    Caption := '&Quitter';
    HelpContext := 1420 ;
    Hint := 'Quitter|Quitter l'#39'application';
    ShortCut := 32883;
    OnClick := dbt_quitterClick;
  end;

  with mu_fenetre do
  begin
    Name := 'mu_fenetre';
    mu_MainMenu.Items.Add(mu_fenetre);
    HelpContext := 1420 ;
    Caption := 'Fe&n'#234'tre';
    Hint := 'Commandes relatives aux fen'#234'tres';
  end;

  with mu_Reinitiliserpresentation do
  begin
    Name := 'mu_Reinitiliserpresentation';
    mu_Reinitiliserpresentation.Caption := 'Réinitialiser la présentation' ;
    HelpContext := 1420 ;
    mu_fenetre.Add(mu_Reinitiliserpresentation);
    OnClick := mu_ReinitiliserpresentationClick;
  end;

  with mu_Sep3 do
  begin
    Name := 'mu_Sep3';
    mu_Sep3.Caption := '-' ;
    HelpContext := 1420 ;
    mu_fenetre.Add(mu_Sep3);
  end;

  {$IFDEF MDI}
  with mu_cascade do
  begin
    Name := 'mu_cascade';
    mu_fenetre.Add(mu_cascade);
    HelpContext := 1420 ;
    Action := WindowCascade;
  end;

  with mu_mosaiqueh do
  begin
    Name := 'mu_mosaiqueh';
    mu_fenetre.Add(mu_mosaiqueh);
    HelpContext := 1420 ;
    Action := WindowTileHorizontal;
  end;

  with mu_mosaiquev do
  begin
    Name := 'mu_mosaiquev';
    mu_fenetre.Add(mu_mosaiquev);
    HelpContext := 1420 ;
    Action := WindowTileVertical;
  end;

  with mu_organiser do
  begin
    Name := 'mu_organiser';
    mu_fenetre.Add(mu_organiser);
    HelpContext := 1420 ;
    Action := WindowArrangeAll;
  end;

  with WindowCascade do
  begin
    Name := 'WindowCascade';
    Category := 'Fen'#234'tre';
    HelpContext := 1420 ;
    Caption := '&Cascade';
    Hint := 'Cascade';
    ImageIndex := 17;
  end;

  with WindowTileHorizontal do
  begin
    Name := 'WindowTileHorizontal';
    Category := 'Fen'#234'tre';
    HelpContext := 1420 ;
    Caption := 'Mosa'#239'que &horizontale';
    Hint := 'Mosa'#239'que horizontale';
    ImageIndex := 15;
  end;

  with WindowTileVertical do
  begin
    Name := 'WindowTileVertical';
    HelpContext := 1420 ;
    Category := 'Fen'#234'tre';
    Caption := 'Mosa'#239'que &verticale';
    Hint := 'Mosa'#239'que verticale';
    ImageIndex := 16;
  end;

  with WindowMinimizeAll do
  begin
    Name := 'WindowMinimizeAll';
    HelpContext := 1420 ;
    Category := 'Fen'#234'tre';
    Caption := '&Tout r'#233'duire';
    Hint := 'Tout r'#233'duire';
  end;

  with WindowArrangeAll do
  begin
    Name := 'WindowArrangeAll';
    HelpContext := 1420 ;
    Category := 'Fen'#234'tre';
    Caption := 'Tout r'#233'&organiser';
    Hint := 'Tout r'#233'organiser';
  end;

 {$ENDIF}

  with mu_reduire do
  begin
    Name := 'mu_reduire';
    mu_fenetre.Add(mu_reduire);
    HelpContext := 1420 ;
    {$IFDEF FPC} OnClick := {$ELSE} Action := {$ENDIF}WindowMinimizeAll;
  end;

  with mu_affichage do
  begin
    Name := 'mu_affichage';
    mu_MainMenu.Items.Add(mu_affichage);
    HelpContext := 1420 ;
    Caption := 'Affichage';
  end;

  with mu_barreoutils do
  begin
    Name := 'mu_barreoutils';
    mu_affichage.Add(mu_barreoutils);
    Caption := 'Barre d'#39'acc'#232's';
    HelpContext := 1420 ;
    OnClick := mu_barreoutilsClick;
  end;

  with mu_voletexplore do
  begin
    Name := 'mu_voletexplore';
    mu_affichage.Add(mu_voletexplore);
    Caption := 'Volet d'#39'acc'#232's';
    HelpContext := 1420 ;
    OnClick := mu_voletexploreClick;
  end;

  with mu_aide do
  begin
    Name := 'mu_aide';
    mu_MainMenu.Items.Add(mu_aide);
    Caption := '&Aide';
    HelpContext := 1420 ;
    Hint := 'Rubriques d'#39'aide';
  end;

  with mu_ouvriraide do
  begin
    Name := 'mu_ouvriraide';
    mu_aide.Add(mu_ouvriraide);
    Caption := '&Ouvrir l'#39'aide';
    HelpContext := 1420 ;
    Hint := 'Rubriques d'#39'aide';
    OnClick := dbt_aideClick;
  end;

  with mu_sep2 do
  begin
    Name := 'mu_sep2';
    HelpContext := 1420 ;
    mu_aide.Add(mu_sep2);
    Caption := '-';
  end;
  {$IFDEF VERSIONS}
  with mu_apropos do
  begin
    Name := 'mu_apropos';
    HelpContext := 1420 ;
    mu_aide.Add(mu_apropos);
    Caption := '&A propos...';
    Hint := 'A propos|Afficher des informations sur le programme, le num'#233'ro d' +
      'e version et le copyright';
    OnClick := mu_aproposClick;
  end;
  {$ENDIF}
  with ActionList do
  begin
    Name := 'ActionList';
    HelpContext := 1420 ;
    Images := im_Liste;
  end;

  with Timer do
  begin
    Name := 'Timer';
    Interval := 60000;
    OnTimer := TimerTimer;
  end;

  with SvgFormInfoIni do
  begin
    Name := 'SvgFormInfoIni';
    SauvePosObjects := True;
    SauveEditObjets := [];
    SauvePosForm := True;
    if IsPublishedProp(SvgFormInfoIni, 'Left') then SetOrdProp(SvgFormInfoIni, 'Left', 256);
    if IsPublishedProp(SvgFormInfoIni, 'Top') then SetOrdProp(SvgFormInfoIni, 'Top', 168);
  end;

  with im_icones do
  begin
    Name := 'im_icones';
  end;

  with sb_forms do
    Begin
      Name := 'sb_forms';
      Parent := pa_main;
      Align := alClient;
    end;

  PanelChilds := sb_forms;
  pa_1.Caption := '' ;
  pa_2.Caption := '' ;
  pa_3.Caption := '' ;
  pa_4.Caption := '' ;
  pa_5.Caption := '' ;

  // Form's PMEs'
  Left := 232;
  Top := 167;
  Width := 773;
  Height := 549;
  Caption := 'Exemple';
  {$IFDEF SFORM}
  pa_main.Color := clGray;
  {$ELSE}
  pa_main.Color := 13565951;
  {$ENDIF}
  Font.Charset := DEFAULT_CHARSET;
  Font.Color := clWindowText;
  Font.Height := -11;
  Font.Name := 'MS Sans Serif';
  Font.Style := [];
  KeyPreview := True;
  Menu := mu_MainMenu;
  Position := poDesktopCenter;
  {$IFNDEF FPC}
  WindowMenu := mu_fenetre;
  {$ENDIF}
  {$IFNDEF CSV}
  Connection := M_Donnees.Connection;
  Connector  := M_Donnees.Acces;
  {$ENDIF}
  HelpContext := 1400 ;

  FormStyle := fsMDIForm;

  OnActivate := F_FormMainIniActivate;
  OnResize := F_FormMainIniResize;
//  Showmessage ( IntToStr ( MAKELCID(MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US))));
end;
{$ENDIF}

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
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_F_XMLFenetrePrincipale );
{$ENDIF}
end.

