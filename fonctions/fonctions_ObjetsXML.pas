unit fonctions_ObjetsXML;

interface

{$I ..\extends.inc}
{$I ..\Compilers.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{

Créée par Matthieu Giroux le 01-2004

Fonctionnalités :

Création de la barre d'accès
Création du menu d'accès
Création du volet d'accès

Utilisation des fonctions
Administration

}

uses Forms, JvXPBar, JvXPContainer,
{$IFDEF FPC}
   LCLIntf, LCLType, ComCtrls,
{$ELSE}
   Windows,
{$ENDIF}
//  ExtTBTls, extdock, ExtTBTlwn, ExtTBTlbr,
  Controls, Classes, JvXPButtons, ExtCtrls,
  Menus, DB,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF DELPHI_9_UP}
  WideStrings ,
{$ENDIF}
{$IFDEF TNT}
  TntForms,TntStdCtrls, TntExtCtrls,
{$ENDIF}
  DBCtrls, ALXmlDoc, IniFiles, Graphics,
  u_multidonnees, fonctions_string ;

const // Champs utilisés
      CST_INI_PROJECT_FILE = 'LY_PROJECT_FILE';
      CST_INI_LANGUAGE = 'LY_LANGUAGE';
{$IFDEF VERSIONS}
  gver_fonctions_Objets_XML : T_Version = ( Component : 'Gestion des objets dynamiques XML' ;
                                     FileUnit : 'fonctions_ObjetsXML' ;
              			                 Owner : 'Matthieu Giroux' ;
              			                 Comment : 'Gestion des données des objets dynamiques de la Fenêtre principale.' + #13#10 + 'Il comprend une création de menus' ;
              			                 BugsStory : 'Version 1.0.0.2 : Better Ini.' + #13#10 +
                                                             'Version 1.0.0.1 : No ExtToolbar on LAZARUS.' + #13#10 +
                                                             'Version 1.0.0.0 : Création de l''unité à partir de fonctions_objets_dynamiques.';
              			                 UnitType : 1 ;
              			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build : 2 );

{$ENDIF}
type
      TActionTemplate          = (atmultiPageTable,atLogin);
      TBuildOrder              = (boConnect,boMenus);
      TLeonFunctionID          = String ;
      TLeonFunctions           = Array of TLeonFunctionID;
      TLeonFunction            = Record
                                        Clep     : String ;
                                        Groupe   : String ;
                                        AFile    : String ;
                                        Value    : String ;
                                        Name     : String ;
                                        Prefix   : String;
                                        Template : TActionTemplate ;
                                        Mode     : TFormStyle ;
                                        Functions : TLeonFunctions;
                                   end;
      TLeonField                  = Record
                                        FieldName : String ;
                                        Name      : String ;
                                   end;
      TLeonFields = Array of TLeonField;
var
      gNod_DashBoard : TALXMLNode = nil;
      gs_SommaireEnCours      : string       ;   // Sommaire en cours MAJ régulièrement
      gF_FormParent           : {$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}        ;   // Form parent initialisée au create
      gxdo_FichierXML         : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
      gxdo_MenuXML            : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
      gxdo_ActionsXML         : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
      gBmp_DefaultPicture     : TBitmap        = nil;   // Bmp apparaissant si il n'y a pas d'image
      gWin_ParentContainer    : TScrollingWinControl  ;   // Volet d'accès
      gIco_DefaultPicture     : TIcon        ;   // Ico apparaissant si il n'y a pas d'image
      gi_TailleUnPanel        ,                  // Taille d'un panel de dxbutton
      gi_FinCompteurImages    : Integer      ;   // Un seul imagelist des menus donc efface après la dernière image
      gBar_ToolBarParent      : TCustomControl  = nil;   // Barre d'accès
      gSep_ToolBarSepareDebut : TControl= nil;   // Séparateur de début délimitant les boutons à effacer
      gPan_PanelSepareFin     : {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}       = nil;   // Panel      de fin   délimitant les boutons à effacer
      gb_UtiliseSMenu         : Boolean      ;            // Utilise-t-on les sous-menus
      gMen_MenuLangue         : TMenuItem    = nil;
      gMen_MenuVolet          : TMenuItem    = nil;
      gMen_MenuParent         : TMenuItem    = nil;
      gIma_ImagesXPBars       : TImageList   = nil;
      gIma_ImagesMenus        : TImageList   = nil;
      gf_Users                : TCustomForm=nil;
      ResInstance             : THandle      ;
      gchar_DecimalSeparator  : Char ;
      ga_Functions : Array of TLeonFunction;
      gs_Language : String;

procedure p_CreeAppliFromNode ( const as_EntityFile : String );
function ffd_CreateFieldDef ( const anod_Field : TALXMLNode ; const ab_isLarge : Boolean ; const afd_FieldsDefs : TFieldDefs ):TFieldDef;
function fs_GetStringFields  ( const alis_NodeFields : TList ; const as_Empty : String ):String;
function fds_CreateDataSourceAndOpenedQuery ( const as_Table, as_Fields, as_NameEnd : String  ; const ar_Connection : TAConnection; const alis_NodeFields : TList ; const acom_Owner : TComponent): TDatasource;
function fdoc_GetCrossLinkFunction( const as_FunctionClep :String;
                                    var as_Table, as_connection : String; var aanod_idRelation : TList ;
                                    var anod_NodeCrossLink : TALXMLNode ): TALXMLDocument ;
procedure p_getImageToBitmap ( const as_Prefix : String; const abmp_Bitmap : TBitmap ) ;
procedure p_CreateRootEntititiesForm;
procedure p_ModifieXPBar  ( const aF_FormParent       : TCustomForm        ;
                            const adx_WinXpBar        : TJvXpBar ;
                            const as_Fonction         ,
                                  as_FonctionLibelle  ,
                                  as_FonctionType     ,
                                  as_FonctionMode     ,
                                  as_FonctionNom      : String      ;
                            const aIma_ListeImages    : TImageList  ;
                            const abmp_Picture        ,
                                  abmp_DefaultPicture : TBitmap     ;
                            const ab_AjouteEvenement   : Boolean   );
function fb_NavigationTree ( const as_EntityFile : String ):Boolean;
function fb_ReadLanguage (const as_little_lang : String ) : Boolean;
function fi_FindAction ( const aClep : String ):Longint ;
function fb_ReadIni ( var amif_Init : TIniFile ) : Boolean;
procedure p_CopyLeonFunction ( const ar_Source : TLeonFunction ; var ar_Destination : TLeonFunction );
procedure p_initialisationSommaire ( const as_SommaireEnCours      : String       );
procedure p_initialisationBoutons ( const aF_FormParent           : {$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}        ;
                                    const aMen_MenuLanguage       : TMenuItem       ;
                        			      const aWin_PanelVolet         : TScrollingWinControl  ;
//                                    const aWin_BarreVolet         : TWinControl  ;
                                    const aMen_MenuVolet          : TMenuItem    ;
                                    const aIco_DefaultPicture     : TIcon        ;
                                    const aBar_ToolBarParent      : TCustomControl ;
                                    const aSep_ToolBarSepareDebut : TControl;
                                    const aPan_PanelSepareFin     : {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}       ;
                                    const ai_TailleUnPanel        : Integer      ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const aMen_MenuParent         : TMenuItem    ;
                                    const aIma_ImagesMenus        : TImageList   ;
                                    const ai_FinCompteurImages    : Integer      );


procedure  p_DetruitLeSommaire ;

function fb_ReadXMLEntitites () : Boolean;

procedure  p_DetruitTout ( const ab_DetruitMenu : Boolean ) ;

{
function  fi_CreeSommaire (         const aF_FormMain             : TCustomForm  ;
                        			      const aF_FormParent           : TCustomForm  ;
                                    const as_SommaireEnCours      : String       ;
                                    const axdo_FichierXML         : TALXMLDocument;
                                    const aIco_DefaultPicture     : TIcon        ;
                                    const aBar_ToolBarParent      : TExtToolbar   ;
                                    const aSep_ToolBarSepareDebut : TExtToolbarSep;
                                    const aPan_PanelSepareFin     : TWinControl  ;
                                    const ai_TailleUnPanel        : Integer      ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const ab_GestionGlobale       : Boolean      ) : Integer ;
function  fi_CreeSommaireBlank : Integer ;}

function fb_CreeXPButtons ( const as_SommaireEnCours      ,
                        			    as_LeMenu               : String      ;
                        		const aF_FormParent           ,
                        			    af_FormEnfant           : TCustomForm       ;
                        		const aCon_ParentContainer    : TScrollingWinControl ;
//                            const aWin_BarreVolet         : TWinControl ;
                            const aMen_MenuVolet          : TMenuItem   ;
                            const aBmp_DefaultPicture     : TBitmap     ;
                            const ab_AjouteEvenement      : Boolean     ;
                            const aIma_ImagesXPBars       : TImageList  ): Boolean;
procedure p_DetruitMenu (           const aMen_MenuParent          : TMenuItem    );

function fb_CreeMenu (              const aF_FormParent           : TForm        ;
                                    const as_SommaireEnCours      : String       ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const aMen_MenuParent         : TMenuItem    ;
                                    const aMen_MenuVolet          : TMenuItem    ;
                                    const aIma_ImagesMenus        : TImageList   ;
                                    const ai_FinCompteurImages    : Integer      ;
                                    var   ab_UtiliseSousMenu      : Boolean      ): Boolean ;
function fb_CreeLeMenu : Boolean ;

procedure p_ExecuteNoFonction ( const ai_Fonction                  : LongInt    ; const ab_Ajuster : Boolean        );
procedure p_ExecuteFonction ( const as_Fonction                  : String    ;  const ab_Ajuster : Boolean        ); overload;
procedure p_ExecuteFonction ( aobj_Sender                  : TObject            ); overload;

implementation

uses U_FormMainIni, SysUtils, TypInfo, Dialogs, fonctions_xml,
     fonctions_images , fonctions_init, 
     Variants, fonctions_proprietes, fonctions_Objets_Dynamiques,
     fonctions_autocomponents, fonctions_dbcomponents,
     unite_variables, u_xmlform, u_languagevars, Imaging ;


/////////////////////////////////////////////////////////////////////////
// function fi_FindAction
// Find a function with a key
// aClep : Key of function
/////////////////////////////////////////////////////////////////////////
function fi_FindAction ( const aClep : String ):Longint ;
var li_i : Longint ;
Begin
  Result := -1 ;
  for li_i := 0 to high ( ga_Functions ) do
    if ga_Functions [ li_i ].Clep = aClep then
      Begin
        Result := li_i;
        Exit;
      End;

End;

/////////////////////////////////////////////////////////////////////////
// procedure p_getNomImageToBitmap
// setting a bitmap with XML name
// as_Nom : XML Name
// abmp_Bitmap : Bitmap to set
/////////////////////////////////////////////////////////////////////////
procedure p_getNomImageToBitmap ( const as_Nom : String; const abmp_Bitmap : TBitmap ) ;
var ls_ImagesDir : String;
    SR: TSearchRec;
    IsFound : Boolean;
Begin
  if as_Nom = '' Then
    Exit;
  ls_ImagesDir := fs_getImagesDir;
  try
    IsFound := FindFirst(ls_ImagesDir + as_Nom + '.*', faAnyFile, SR) = 0 ;
  Except
    isFound := False;
  End ;
  while IsFound do
   begin
    if  FileExists ( ls_ImagesDir + SR.Name )
    and ( DetermineFileFormat ( ls_ImagesDir + SR.Name ) <> '' )
     then
      Begin
        p_SetFileToBitmap (ls_ImagesDir + SR.Name, abmp_Bitmap, True );
      End ;
    try
      IsFound := FindNext(SR) = 0;
    Except
      isFound := False;
    End ;
  end;
  FindClose(SR);
end;


/////////////////////////////////////////////////////////////////////////
// procedure p_getImageToBitmap
// Erasing bitmap and setting from prefix
// Calling p_getNomImageToBitmap
// as_Prefix : XML Prefix of image
// abmp_Bitmap : Bitmap to set
/////////////////////////////////////////////////////////////////////////
procedure p_getImageToBitmap ( const as_Prefix : String; const abmp_Bitmap : TBitmap ) ;
Begin
  {$IFDEF DELPHI}
  abmp_Bitmap.Dormant ;
  {$ENDIF}
  abmp_Bitmap.FreeImage ;
  abmp_Bitmap.Handle := 0 ;
  p_getNomImageToBitmap ( as_Prefix, abmp_Bitmap );
  p_RecuperePetitBitmap ( abmp_Bitmap );
end;

/////////////////////////////////////////////////////////////////////////
// procedure p_ExecuteFonction
// procedure to put on Event p_OnClickFonction on main form
// procedure à mettre dans l'évènement p_OnClickFonction de la form principale
// aobj_Sender : L'objet cliqué pour exécuter sa fonction
// aobj_Sender : Form event
/////////////////////////////////////////////////////////////////////////
procedure p_ExecuteFonction ( aobj_Sender                  : TObject            );
var ls_FonctionClep: String ;
    ls_NomObjet        : String ;
begin
  ls_NomObjet := '' ;
  // Si la propriété nom est valable et existe
  if      IsPublishedProp ( aObj_Sender   , 'Name' )
   Then
    ls_NomObjet := getPropValue ( aobj_Sender, 'Name' ) ;

  if ( ls_NomObjet <> '' ) then
    Begin
      ls_FonctionClep := copy (ls_NomObjet, 1, length ( ls_NomObjet ) - 1 );
      p_ExecuteFonction ( ls_FonctionClep, True );
    End;
  // Se place sur la fonction
End ;

/////////////////////////////////////////////////////////////////////////
// procedure p_ExecuteFonction
// Execute a funtion with key as_Fonction
// Fonction qui exécute une fonction à partir d'une clé de fonction
// as_Fonction : la clé de la fonction
// as_Fonction : the key of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
procedure p_ExecuteFonction ( const as_Fonction                  : String    ; const ab_Ajuster : Boolean        );
var lf_Formulaire    : TF_XMLForm ;
    lb_Unload        : Boolean ;
    li_i             : Longint ;
    lfs_newFormStyle : TFormStyle ;
    llf_Function      : TLeonFunction;
    lico_icon : TIcon ;
    lbmp_Bitmap : TBitmap ;
begin
  // Recherche dans ce qui a été chargé par les fichiers XML
  p_ExecuteNoFonction ( fi_findAction ( as_Fonction ), ab_ajuster);
End ;

/////////////////////////////////////////////////////////////////////////
// procedure p_ExecuteNoFonction
// Execute a function number
// Fonction qui exécute une fonction à partir d'une clé de fonction
// as_Fonction : The number of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
procedure p_ExecuteNoFonction ( const ai_Fonction                  : LongInt    ; const ab_Ajuster : Boolean        );
var lf_Formulaire    : TF_XMLForm ;
    lb_Unload        : Boolean ;
    li_i : Longint;
    lfs_newFormStyle : TFormStyle ;
    llf_Function      : TLeonFunction;
    lico_icon : TIcon ;
    lbmp_Bitmap : TBitmap ;
begin
  // Recherche dans ce qui a été chargé par les fichiers XML
  if ai_Fonction < 0 then
    Exit;
  //Trouvé
  lf_Formulaire := nil;
  // Fichier XML de la fonction
  llf_Function := ga_functions [ ai_Fonction ];
  // La fiche peut être déjà créée
  for li_i := 0 to Application.ComponentCount -1 do
    if ( Application.Components [ li_i ] is TF_XMLForm )
    and (( Application.Components [ li_i ] as TF_XMLForm ).Fonction.Clep = llf_Function.Clep ) Then
      lf_Formulaire := Application.Components [ li_i ] as TF_XMLForm ;
  // Se place sur la bonne fonction
  if not assigned ( lf_Formulaire ) Then
    Begin
      lf_Formulaire := TF_XMLForm.create ( Application );
      lf_Formulaire.Fonction := llf_Function;
    End;

  lbmp_Bitmap := TBitmap.Create;
  p_getImageToBitmap(llf_Function.Prefix,lbmp_Bitmap);
  lico_Icon := TIcon.Create;
  p_BitmapVersIco(lbmp_Bitmap,lico_Icon);
// Assigne l'icône si existe
  If not lico_Icon.Empty
   Then
    try
      lf_Formulaire.Icon.Modified := False ;
      lf_Formulaire.Icon.PaletteModified := False ;
      if lf_Formulaire.Icon.Handle <> 0 Then
        Begin
          lf_Formulaire.Icon.ReleaseHandle ;
          lf_Formulaire.Icon.CleanupInstance ;
        End ;
      lf_Formulaire.Icon.Handle := 0 ;
      lf_Formulaire.Icon.width  := 16 ;
      lf_Formulaire.Icon.Height := 16 ;
      lf_Formulaire.Icon.Assign ( lico_Icon );
      lf_Formulaire.Icon.Modified := True ;
      lf_Formulaire.Icon.PaletteModified := True ;

      lf_Formulaire.Invalidate ;
    Except
    End ;
  {$IFDEF FPC}
   lico_Icon.FreeImage;
  {$ENDIF}
   lico_Icon.Free;
  {$IFDEF DELPHI}
   lbmp_Bitmap.Dormant ;
  {$ENDIF}
   lbmp_Bitmap.FreeImage;
   lbmp_Bitmap.Free;
    // Paramètres d'affichage
  if  ab_Ajuster then
    Begin
      lb_Unload := fb_getComponentBoolProperty ( lf_Formulaire, 'DataUnload' );
     // Initialisation de l'ouverture de fiche
      lfs_newFormStyle := llf_Function.Mode ;
      if not lb_Unload Then
        Begin
          if  ( Application.MainForm is TF_FormMainIni )
            Then
              ( Application.MainForm as TF_FormMainIni ).fb_setNewFormStyle( lf_Formulaire, lfs_newFormStyle, ab_Ajuster)
        End
      else
        lf_Formulaire.Free ;
    End ;
End ;

/////////////////////////////////////////////////////////////////////////
// procedure p_DetruitMenu
// Destroying Menu Items
// Destruction des menus
// aMen_MenuParent : Le menu contenant les menus à détruire
// aMen_MenuParent : The menu item containing The menus to destroy
/////////////////////////////////////////////////////////////////////////
procedure p_DetruitMenu (           const aMen_MenuParent          : TMenuItem    );

var li_i : Integer ;
Begin
// DEstruction des menus
  if not assigned ( aMen_MenuParent )
   Then
    Exit ;
// DEstruction des items de menu
  For li_i := aMen_MenuParent.Count - 1 downto 0 do
    Begin
      p_DetruitMenus ( aMen_MenuParent, aMen_MenuParent.Items [ li_i ], True );
//      aMen_MenuParent.Items [ li_i ].Handle := 0 ;
//      aMen_MenuParent.Remove ( aMen_MenuParent.Items [ li_i ])  ;
    End ;
End ;



/////////////////////////////////////////////////////////////////////////
// procedure p_InitialisationMenu
// Init of menu building
// Initialisation du nombre d'images de conception pour les items de menu
// ai_FinCompteurImages : Le nombre d'images dans l'imagelist
// ai_FinCompteurImages : Image count in image list
/////////////////////////////////////////////////////////////////////////
procedure p_InitialisationMenu ( const ai_FinCompteurImages : Integer       );

Begin
  gi_FinCompteurImages := ai_FinCompteurImages ;
End ;


/////////////////////////////////////////////////////////////////////////
// procedure p_initialisationSommaire
// Init of toolbar building
// Initialisations des composants en fonction :
// as_SommaireEnCours      : Le Sommaire en cours
// as_SommaireEnCours      : The toolbar menu
/////////////////////////////////////////////////////////////////////////
procedure p_initialisationSommaire ( const as_SommaireEnCours      : String       );
Begin
  gs_SommaireEnCours   := as_SommaireEnCours   ;
End ;

/////////////////////////////////////////////////////////////////////////
// procedure p_initialisationBoutons
// Setting the global variables of menu
// aF_FormParent : Main form
// aMen_MenuLanguage : Language menu containing languages traduction
// aWin_PanelVolet   : Left XP Bar menu
// aMen_MenuVolet    : XP Bar setting to show
// aIco_DefaultPicture : Default picture icon
// aBar_ToolBarParent  : Toolbar
// aSep_ToolBarSepareDebut : Begining Toolbar separation. There are buttons
// aPan_PanelSepareFin     : End Toolbar separation. There are buttons
// ai_TailleUnPanel        : Toolbar width of panel
// aBmp_DefaultPicture     : Default bitmap
// aMen_MenuParent         : Main form menu items
// aIma_ImagesMenus        : Images list of menus
// ai_FinCompteurImages    : Counter of images list
/////////////////////////////////////////////////////////////////////////
procedure p_initialisationBoutons ( const aF_FormParent           : {$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}        ;
                                    const aMen_MenuLanguage       : TMenuItem       ;
              			    const aWin_PanelVolet         : TScrollingWinControl  ;
                                    const aMen_MenuVolet          : TMenuItem    ;
                                    const aIco_DefaultPicture     : TIcon        ;
                                    const aBar_ToolBarParent      : TCustomControl   ;
                                    const aSep_ToolBarSepareDebut : TControl;
                                    const aPan_PanelSepareFin     : {$IFDEF TNT}TTntPanel{$ELSE}TPanel{$ENDIF}       ;
                                    const ai_TailleUnPanel        : Integer      ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const aMen_MenuParent         : TMenuItem    ;
                                    const aIma_ImagesMenus        : TImageList   ;
                                    const ai_FinCompteurImages    : Integer      );

Begin
  gF_FormParent           := aF_FormParent           ;
  gWin_ParentContainer    := aWin_PanelVolet         ;
  gIco_DefaultPicture     := aIco_DefaultPicture     ;
  gBar_ToolBarParent      := aBar_ToolBarParent      ;
  gSep_ToolBarSepareDebut := aSep_ToolBarSepareDebut ;
  gPan_PanelSepareFin     := aPan_PanelSepareFin     ;
  gi_TailleUnPanel        := ai_TailleUnPanel        ;
  gBmp_DefaultPicture     := aBmp_DefaultPicture     ;
  gMen_MenuParent         := aMen_MenuParent         ;
  gMen_MenuVolet          := aMen_MenuVolet          ;
  gMen_MenuLangue         := aMen_MenuLanguage       ;
  gIma_ImagesMenus        := aIma_ImagesMenus        ;
  gi_FinCompteurImages    := ai_FinCompteurImages    ;
  gIma_ImagesXPBars       := TImageList.Create ( aF_FormParent );

End ;
/////////////////////////////////////////////////////////////////////////
// function fb_CreeXPButtons
// building XP Bar menu
// Création des composant XPBar en fonction :
// as_SommaireEnCours      : Le Sommaire en cours
// as_LeMenu               : Le menu
// aF_FormParent           : De la form Propriétaire
// aCon_ParentContainer    : du Container XP de la form Propriétaire
// aWin_BarreVolet         : La barre d'outils du volet d'exploration
// aMen_MenuVolet          : LE Menu du volet à rendre visible ou non
// aadoq_QueryFonctions    : Requête ADO des fonctions par menus et sous menus des utilisateurs
// aIco_DefaultPicture     : De l'image par défaut si pas d'image
// ab_AjouteEvement        : Ajoute-t-on les évènements
// Sortie                  : a-t-on créé au moins une xp bar
// English
// as_SommaireEnCours      : Data Xp Bar Menu
// as_LeMenu : Specific menu action showing
// aF_FormParent : Main form
// af_FormEnfant : Main form but can be child
// aCon_ParentContainer : Scrolling box containing xp menu
// aMen_MenuVolet    : XP Bar setting to show
// aBmp_DefaultPicture     : Default bitmap
// ab_AjouteEvenement      : Adding event to xp menus
// ai_FinCompteurImages    : Counter of images list
/////////////////////////////////////////////////////////////////////////

function fb_CreeXPButtons ( const as_SommaireEnCours      ,
                        			    as_LeMenu               : String      ;
                        		const aF_FormParent           ,
                       			    af_FormEnfant           : TCustomForm       ;
                        		const aCon_ParentContainer    : TScrollingWinControl ;
                        		const aMen_MenuVolet          : TMenuItem   ;
                        		const aBmp_DefaultPicture     : TBitmap     ;
                        		const ab_AjouteEvenement      : Boolean     ;
                        		const aIma_ImagesXPBars       : TImageList  ): Boolean;
var ldx_WinXpBar        : TJvXpBar ;  // Nouvelle barre xp
    li_i, li_j,
    li_Action           : LongInt;
    li_Compteur         ,
    li_CompteurFonctions: Integer ; // Compteur fonctions
    ls_Menu             , // Menu en cours
    ls_SMenu,
    ls_MenuAction       ,
    ls_MenuClep         ,
    ls_MenuPrefix       ,
    ls_MenuGroup        ,
    ls_MenuValue        ,
    ls_MenuName         : string ;
    ls_MenuLabel        : WideString ;// Sous Menu en cours
//    lbmp_BitmapOrigine  : TBitmap ;  // bitmap en cours
    lNode, lNodeChild   : TALXMLNode ;
    lbmp_FonctionImage  : TBitmap ;  // Icône de la Fonction en cours
    li_TopXPBar         : Integer ;
    aIma_ImagesTempo    : TImageList ;
Begin
// un noeud et la main form doivent exister
  Result := False ;
  if not assigned ( aF_FormParent                   )
  or not assigned ( aCon_ParentContainer            )
  or not gNod_DashBoard.HasChildNodes
   Then
    Exit ;
   // destruction des composants du container
  p_DetruitXPBar ( aCon_ParentContainer );
  aIma_ImagesXPBars.Clear ;
// Initialisation
  ldx_WinXpBar       := nil ;
{  if lb_UtiliseSMenu
   Then li_CompteurMenus     := fi_ChercheMenu ( as_LeMenu )
   Else li_CompteurMenus     := 0 ;}
  ls_Menu              := '' ;
  ls_MenuGroup         := '' ;
  ls_SMenu             := '' ;
  li_CompteurFonctions := 0 ;
  li_Compteur          := 0 ;
  li_TopXPBar          := 1 ;
//  lico_IconMenu        := nil ;
  lbmp_FonctionImage   := TBitmap.Create ; // A libérer à la fin
  lbmp_FonctionImage.Handle := 0 ;
  aIma_ImagesTempo     := TImageList.Create ( af_FormParent );
  aIma_ImagesTempo     .Width  := 32 ;
  aIma_ImagesTempo     .Height := 32 ;

  // Premier enregistrement
  // Création des XPBars
  // Rien alors pas de menu
//  ShowMessage ( gnod_DashBoard.XML );

  for li_i := 0 to gNod_DashBoard.ChildNodes.Count - 1 do
    Begin
      lNode := gNod_DashBoard.ChildNodes [ li_i ];
      if ( lNode.NodeName = CST_LEON_ACTIONS ) then
        for li_j := 0 to lNode.ChildNodes.Count - 1 do
          Begin
                  // SI les sous-menus ou menus sont différents ou pas de sous menu alors création d''une xpbar
                  // SI les sous-menus ou menus sont différents ou pas de sous menu alors création d''une xpbar
                  if  ( ls_MenuGroup <> '' ) Then
                    Begin
                      if ( ls_MenuGroup <> ls_Menu )
          {                     or (     lb_UtiliseSMenu
                                   and (    ( gT_TableauMenus [ li_CompteurMenus ].SousMenu <> ls_SMenu )
                                         or ( gT_TableauMenus [ li_CompteurMenus ].SousMenu = ''        )))))}
                        Then
                         Begin
                         // Si une fonction dans l'enregistrement précédent affectation dans l'ancienne xpbar
                           if ( li_CompteurFonctions = 1 )
                            Then
                             Begin
                               p_getImageToBitmap ( ls_MenuPrefix,  lbmp_FonctionImage );
                               p_ModifieXPBar  ( aF_FormParent       ,
                                                 ldx_WinXpBar        ,
                                                 ls_MenuClep         ,
                                                 ls_MenuLabel        ,
                                                 ls_MenuValue        ,
                                                 ''                  ,
                                                 ls_MenuName         ,
                                                 aIma_ImagesTempo    ,
                                                 lbmp_FonctionImage    ,
                                                 abmp_DefaultPicture ,
          //                                       li_Compteur         ,
                                                 ab_AjouteEvenement  );
                             End ;
                    // Affectation des valeurs
                         ls_Menu  := ls_MenuGroup ;

                           // création d''une xpbar
                           if assigned ( ldx_WinXpBar )
                            Then
                             Begin
                               ldx_WinXpBar.Refresh ;
                               li_TopXPBar := ldx_WinXpBar.Top + ldx_WinXpBar.Height + 1 ;
                             End ;
                           ldx_WinXpBar := TJvXpBar.Create ( af_FormEnfant );//aF_FormParent );

                           //Gestion des raccourcis d'aide
                           ldx_WinXpBar.HelpType    := aCon_ParentContainer.HelpType ;
                           ldx_WinXpBar.HelpKeyword := aCon_ParentContainer.HelpKeyword ;
                           ldx_WinXpBar.HelpContext := aCon_ParentContainer.HelpContext ;

                           // Aligne en haut
                           ldx_WinXpBar.Top   := li_TopXPBar ;
                           ldx_WinXpBar.ImageList := aIma_ImagesXPBars ;
                           ldx_WinXpBar.Align := alTop ;

                           // Couleurs originelles
                           ldx_WinXpBar.Colors.BodyColor := $00F7DFD6 ;
                           ldx_WinXpBar.Colors.CheckedColor := $00D9C1BB;
                           ldx_WinXpBar.Colors.CheckedFrameColor := clHighlight ;
                           ldx_WinXpBar.Colors.FocusedColor := $00D8ACB0 ;
                           ldx_WinXpBar.Colors.FocusedFrameColor := clHotLight ;
                           ldx_WinXpBar.Colors.GradientFrom := clWhite ;
                           ldx_WinXpBar.Colors.GradientTo := $00F7D7C6 ;
                           ldx_WinXpBar.Colors.SeparatorColor := $00F7D7C6 ;

                           // Fontes
                           ldx_WinXpBar.Font.Size := 10 ;
                           ldx_WinXpBar.HeaderFont.Size := 10 ;

                            // affectation du compteur de nom
//                           p_setComponentName ( ldx_WinXpBar, ls_MenuGroup );
                           // Parent


                           ldx_WinXpBar.Parent := aCon_ParentContainer ;
                           p_getImageToBitmap ( ls_MenuPrefix, lbmp_FonctionImage );
                                 // affectation du libellé du menu
                            // Gestion sans base de données
                           p_ModifieXPBar  ( aF_FormParent       ,
                                                 ldx_WinXpBar        ,
                                                 ls_MenuGroup        ,
                                                 fs_GetLabelCaption ( ls_MenuGroup )        ,
                                                 ''                  ,
                                                 ''                  ,
                                                 ls_MenuGroup        ,
                                                 aIma_ImagesTempo    ,
                                                 lbmp_FonctionImage    ,
                                                 abmp_DefaultPicture ,
          //                                       li_Compteur         ,
                                                 False  );

                            // On remet le compteur des fonctions à 0
                           li_CompteurFonctions := 0 ;

                         End
                        else
                         if ( li_CompteurFonctions = 1 )
                          Then
                            Begin
                              p_getImageToBitmap ( ls_MenuPrefix,  lbmp_FonctionImage );
                            // fonction dans la file d'attente
                              fdxi_AddItemXPBar ( aF_FormParent       ,
                                                  ldx_WinXpBar        ,
                                                  ls_MenuClep         ,
                                                  ls_MenuLabel        ,
                                                  ls_MenuValue        ,
                                                  ''                  ,
                                                  ls_MenuName         ,
                                                  aIma_ImagesXPBars   ,
                                                  lbmp_FonctionImage  ,
                                                  aBmp_DefaultPicture ,
                                                  li_Compteur - 1     );

                            end;
                    End;
             lNodeChild := lNode.ChildNodes [ li_j ];
      //      ShowMessage (  axdo_FichierXML.ChildNodes[li_i].LocalName + ' local '+ axdo_FichierXML.ChildNodes[li_i].NodeName + ' local '+ axdo_FichierXML.ChildNodes[li_i].Prefix + ' local '+ axdo_FichierXML.ChildNodes[li_i].Text + ' local '+ axdo_FichierXML.ChildNodes[li_i].XML );
            // Les sous-menus et menus doivent avoir des noms
            if  (  not ( lNodeChild.HasAttribute ( CST_LEON_ID )) // Ou alors pas de sous menu on crée la fonction
               and not ( lNodeChild.HasAttribute ( CST_LEON_ACTION_IDREF ))) // Ou alors pas de sous menu on crée la fonction
            or  (     ( lNodeChild.NodeName <> CST_LEON_ACTION )
                 and  ( lNodeChild.NodeName <> CST_LEON_ACTION_REF ))
              Then
               Begin
               // Enregistrement sans donnée valide on va au suivant
                 Continue ;
               End ;
              Result := True ;
            if lNodeChild.HasAttribute(CST_LEON_ACTION_IDREF) then
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ACTION_IDREF ]
             Else
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ID ];
            ls_MenuAction := '' ;
            ls_MenuName   := '' ;
            ls_MenuGroup  := '' ;
            ls_MenuValue  := '' ;
            // SI le menu existe et si il est différent création d'un menu
              if  ( ls_MenuClep   <> '' )
               Then
                Begin
                  li_Action := fi_FindAction ( ls_MenuClep );
                  if li_Action = -1 then
                    Continue;
                  ls_MenuAction := ga_Functions [ li_Action ].Groupe ;
                  ls_MenuPrefix := ga_Functions [ li_Action ].Prefix ;
                  ls_MenuName   := ga_Functions [ li_Action ].Name   ;
                  ls_MenuValue  := ga_Functions [ li_Action ].Value  ;
                  ls_MenuGroup  := ga_Functions [ li_Action ].Groupe ;
                  if ( ls_MenuName = '' ) then
                     Continue;
                 ls_MenuLabel  := fs_GetLabelCaption ( ls_MenuName );
                  Result := True ;

                  // A chaque fonction création d'une action dans la bar XP
                  if    assigned ( ldx_WinXpBar )
                  and (    ( ls_Menuclep <> '' ))
      //            or  (       not assigned ( axdo_FichierXML )
      //                  and ( gT_TableauMenus [ li_CompteurMenus ].Fonction <> '' ))
                   Then
                    Begin
                      inc ( li_CompteurFonctions );
                      inc ( li_Compteur          );
                      if ( li_CompteurFonctions > 1 ) // Ajoute si plus d'une fonction
                       Then
                        Begin
                          // fonction dans la file d'attente
                          p_getImageToBitmap ( ls_MenuPrefix,  lbmp_FonctionImage );
                          fdxi_AddItemXPBar  ( aF_FormParent       ,
                                              ldx_WinXpBar        ,
                                              ls_MenuClep         ,
                                              ls_MenuLabel        ,
                                              ls_MenuValue        ,
                                              ''                  ,
                                              ls_MenuName         ,
                                              aIma_ImagesXPBars   ,
                                              lbmp_FonctionImage  ,
                                              aBmp_DefaultPicture ,
                                              li_Compteur - 1     );
                        End ;
                    End ;
                    // Au suivant !
              End ;
              // Si une fonction dans le dernier enregistrement affectation dans l'ancienne xpbar
             if ( li_CompteurFonctions = 1 )
              Then
               Begin
                 p_getImageToBitmap ( ls_MenuPrefix,  lbmp_FonctionImage );
                 p_ModifieXPBar( aF_FormParent         ,
                                 ldx_WinXpBar        ,
                                 ls_MenuClep         ,
                                 ls_MenuLabel        ,
                                 ls_MenuValue        ,
                                 ''                  ,
                                 ls_MenuName         ,
                                 aIma_ImagesTempo    ,
                                 lbmp_FonctionImage  ,
                                 aBmp_DefaultPicture ,
          //                       li_Compteur         ,
                                 ab_AjouteEvenement  );
               end;
            End ;
          End;
   if assigned ( aMen_MenuVolet )
    Then
     if Result
     Then
      Begin
        aMen_MenuVolet.Enabled := True ;
        if gb_FirstAcces Then
          aMen_MenuVolet.Checked := True
        Else
          if not aMen_MenuVolet.Checked
           Then aMen_MenuVolet.OnClick ( aMen_MenuVolet );
      End
     Else
      Begin
        if gb_FirstAcces Then
          aMen_MenuVolet.Checked := False
        Else
          if aMen_MenuVolet.Checked
           Then aMen_MenuVolet.OnClick ( aMen_MenuVolet );
        aMen_MenuVolet.Enabled := False ;
      End ;
   try
     aIma_ImagesTempo.Clear;
     aIma_ImagesTempo.Free ;
   Finally
   End ;
   try
     lbmp_FonctionImage.Free ;
   Finally
   End ;
   // Libération de l'icône
End ;

/////////////////////////////////////////////////////////////////////////
// function fb_CreeLeMenu
// creating the menus from global variables
// Result to false = error
/////////////////////////////////////////////////////////////////////////
function fb_CreeLeMenu ( ): Boolean ;
Begin
  Result := False;
  if assigned ( gMen_MenuVolet ) Then
    Begin
      Result := fb_CreeMenu (  gF_FormParent           ,
                               gs_SommaireEnCours      ,
                               gBmp_DefaultPicture     ,
                               gMen_MenuParent         ,
                               gMen_MenuVolet          ,
                               gIma_ImagesMenus        ,
                               gi_FinCompteurImages    ,
                               gb_UtiliseSMenu         );
      Result := fb_CreeXPButtons ( '', '', gF_FormParent, gF_FormParent, gWin_ParentContainer, gMen_Menuvolet, gBmp_DefaultPicture  , True, gIma_ImagesXPBars   ) and Result;
    end;
End ;

/////////////////////////////////////////////////////////////////////////
// function fb_CreeMenu
// Creating the menu items
// Création des composants MenuItem en fonction :
// aMenuParent             : Le menu parent
// as_SommaireEnCours      : Le Sommaire en cours
// aF_FormParent           : De la form Propriétaire
// gCon_ParentContainer    : du Container XP de la form Propriétaire
// axdo_FichierXML    : Requête ADO des fonctions par menus et sous menus des utilisateurs
// aBmp_DefaultPicture     : De l'image par défaut si pas d'image
// aIma_ImagesMenus        : La liste d'images du menu
// ai_FinCompteurImages    : Le nombre de bitmaps d'origine
// ab_UtiliseSousMenu      : Utilise-t-on les sous menus
// english
// aF_FormParent : Main form
// as_SommaireEnCours      : Data Menu Item
// aBmp_DefaultPicture     : Default bitmap
// aMen_MenuParent         : Main form menu items
// aMen_MenuVolet          : XP Bar setting to show
// aIma_ImagesMenus        : Images list of menus
// ai_FinCompteurImages    : Counter of images list
// ab_UtiliseSousMenu      : Creating sub menus
/////////////////////////////////////////////////////////////////////////
function fb_CreeMenu (              const aF_FormParent           : TForm        ;
                                    const as_SommaireEnCours      : String       ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
              			      const aMen_MenuParent         : TMenuItem    ;
               			      const aMen_MenuVolet          : TMenuItem    ;
               			      const aIma_ImagesMenus        : TImageList   ;
               			      const ai_FinCompteurImages    : Integer      ;
                                    var   ab_UtiliseSousMenu      : Boolean      ): Boolean ;
var //lMen_Menu           ,
    lMen_MenuEnCours    : TMenuItem ;  // Nouvelle barre xp
    li_i, li_j, li_k    ,
    li_Action           ,
    li_CompteurMenu     : LongInt ;  // Compteur barres xp
//    li_CompteurFonctions: Integer ; // Compteur fonctions
    ls_Menu             , // Menu en cours
    ls_SMenu,
    ls_MenuAction       ,
    ls_MenuClep         ,
    ls_MenuPrefix       ,
    ls_MenuGroup        ,
    ls_MenuValue        ,
    ls_MenuName         : string ;
    lMen_MenuEnfant     : TMenuItem;
    ls_MenuLabel        : WideString ;// Sous Menu en cours
{    ls_Fonction         ,          // Fonction en cours
    ls_FonctionType     ,          // Type de Fonction en cours
    ls_FonctionLibelle  ,          // Libellé de Fonction en cours
    ls_FonctionMode     ,          // Mode de Fonction en cours
    ls_FonctionNom      : string ; // Nom de la Fonction en cours}
    lbmp_BitmapOrigine  : TBitmap ;  // bitmap en cours
    lNode, lNodeChild : TALXMLNode ;

    lb_AjouteBitmap     , // Utilise-t-on un bitmap
//    lb_boutonsMenu    ,  // A-t-on ajouté les boutons d'accès au menu
    lb_ImageDefaut      : Boolean ; // Mode Sous Menu
    aIma_ImagesTempo    : TImagelist ;
//const lbmp_Rectangle = ( 0, 0 , 16, 16 );
Begin
  Result := False ;
// Tout doit exister
  if not assigned ( aF_FormParent                   )
  or not assigned ( aMen_MenuParent                 )
  or not assigned ( gNod_DashBoard               )
  or not gNod_DashBoard.HasChildNodes
   Then
    Exit ;
  lb_ImageDefaut := True ;
   // destruction des composants du container
  p_DetruitMenu ( aMen_MenuParent );
  // Création de la requête des fonctions par menus et sous menus des utilisateurs
  // Utilise-t-on les sous menus ?
//  ab_UtiliseSousMenu := axdo_FichierXML.FieldByName( CST_SOMM_Niveau ).ASBoolean;

  // Initialisation
//  lMen_Menu          := nil ;
  lMen_MenuEnCours   := nil ;
//  lb_AjouteBitmap    := False ;

  ls_Menu              := '' ;
  ls_SMenu             := '' ;
{  ls_FonctionType      := '' ;
  ls_FonctionMode      := '' ;
  ls_FonctionNom       := '' ;
  ls_Fonction          := '' ;
  ls_FonctionLibelle   := '' ;}
  li_CompteurMenu      := 0 ;
//  li_CompteurFonctions := 0 ;
//  lb_BoutonsMenu       := True ;

  lbmp_BitmapOrigine := TBitmap.Create ; // A libérer à la fin
  lbmp_BitmapOrigine.Handle := 0 ;
  lbmp_BitmapOrigine.Assign ( aBmp_DefaultPicture );


  // Imagelist pour la traduction en ticon
  aIma_ImagesTempo     := TImageList.Create ( af_FormParent );
  aIma_ImagesTempo     .Width  := 32 ;
  aIma_ImagesTempo     .Height := 32 ;

  if ( ai_FinCompteurImages < aIma_ImagesMenus.Count )
   Then
    For li_i := aIma_ImagesMenus.Count - 1 downto ai_FinCompteurImages do
      aIma_ImagesMenus.Delete( li_i );

  if  ( ai_FinCompteurImages = aIma_ImagesMenus.Count )
  and assigned ( aBmp_DefaultPicture )
   Then
    Begin
      p_RecuperePetitBitmap ( lbmp_BitmapOrigine );
      aIma_ImagesMenus.AddMasked ( lbmp_BitmapOrigine , lbmp_BitmapOrigine.TransparentColor );
    End
   Else
    lb_ImageDefaut := False ;


  gb_ExisteFonctionMenu := False ;


{  // Création des menus
  p_CreeBoutonsMenus ( axdo_FichierXML ,
                       ab_utiliseSousMenu   ,
                       aBmp_DefaultPicture  );}
  // Création des menus
  for li_i := 0 to gNod_DashBoard.ChildNodes.Count - 1 do
    Begin
      lNode := gNod_DashBoard.ChildNodes [ li_i ];
      if ( lNode.NodeName = CST_LEON_ACTIONS ) then
        for li_j := 0 to lNode.ChildNodes.Count  - 1 do
          Begin
           lNodeChild := lnode.ChildNodes [ li_j ];
      //      ShowMessage (  axdo_FichierXML.ChildNodes[li_i].LocalName + ' local '+ axdo_FichierXML.ChildNodes[li_i].NodeName + ' local '+ axdo_FichierXML.ChildNodes[li_i].Prefix + ' local '+ axdo_FichierXML.ChildNodes[li_i].Text + ' local '+ axdo_FichierXML.ChildNodes[li_i].XML );
            // Les sous-menus et menus doivent avoir des noms
            if  (  not ( lNodeChild.HasAttribute ( CST_LEON_ID )) // Ou alors pas de sous menu on crée la fonction
               and not ( lNodeChild.HasAttribute ( CST_LEON_ACTION_IDREF ))) // Ou alors pas de sous menu on crée la fonction
            or  (     ( lNodeChild.NodeName <> CST_LEON_ACTION )
                 and  ( lNodeChild.NodeName <> CST_LEON_ACTION_REF ))
              Then
               // Enregistrement sans donnée valide on va au suivant
                Continue ;
           Result := True ;
            if lNodeChild.HasAttribute(CST_LEON_ACTION_IDREF) then
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ACTION_IDREF ]
             Else
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ID ];
            lb_AjouteBitmap := False;
            // SI le menu existe et si il est différent création d'un menu
              if  ( ls_MenuClep   <> '' )
               Then
                Begin
                li_Action := fi_FindAction ( ls_MenuClep );
                if li_Action = -1 then
                  Continue;
                ls_MenuAction := ga_Functions [ li_Action ].Groupe ;
                ls_MenuPrefix := ga_Functions [ li_Action ].Prefix ;
                ls_MenuName   := ga_Functions [ li_Action ].Name   ;
                ls_MenuValue  := ga_Functions [ li_Action ].Value  ;
                ls_MenuGroup  := ga_Functions [ li_Action ].Groupe ;
                 if ( ls_MenuName = '' ) then
                   Continue;
                 ls_MenuLabel  := fs_GetLabelCaption ( ls_MenuName );
                 if (   ls_MenuGroup <> ls_Menu  )
                  Then
                   begin
                     // compteur de nom
                     inc ( li_CompteurMenu ); // compteur de nom
                       // Création des menus
                     lMen_MenuEnCours := TMenuItem.Create ( aF_FormParent );
                     lMen_MenuEnCours.Bitmap.Handle := 0 ;

                     //Gestion des raccourcis d'aide
                     lMen_MenuEnCours.HelpContext := aMen_MenuVolet.HelpContext ;

                      // affectation du compteur de nom
                     p_setComponentName ( lMen_MenuEnCours, ls_MenuName );
                     aMen_MenuParent.Add ( lMen_MenuEnCours );
                       // Menu Parent
//                     lMen_Menu        := lMen_MenuEnCours ;
                     ls_Menu  := ls_MenuGroup ;
                     // affectation du libellé du menu
                     lMen_MenuEnCours.Caption := fs_getLabelCaption ( ls_MenuAction );
                     lMen_MenuEnCours.Hint    := lMen_MenuEnCours.Caption;
                     //fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_MENU_Bmp ), lMen_MenuEnCours.Bitmap, aBmp_DefaultPicture );
      //               lMen_MenuEnCours.Bitmap  := aIma_ImagesMenus ;
      //               lMen_MenuEnCours.ImageIndex := fi_AjouteBmpAImages ( lbmp_BitmapOrigine, lb_AjouteBitmap, aIma_ImagesMenus );
                  // On remet le compteur des fonctions à 0
      //               li_CompteurFonctions := 0 ;
                   End ;
                 // Repositionnenement du menu
{                 if ab_UtiliseSousMenu
                 // Si un menu n'est pas null alors ajoute-t-on un sous menu ?
                 and  (   ls_MenuClep <> '' )
                 // Si on n'ajoute pas un sous menu alors le menu en cours n'est pas un sous menu
                 and  (   axdo_FichierXML.FieldByName ( CST_SOUM_Clep ).Value = Null )
                  Then lMen_MenuEnCours := lMen_Menu ;
                 // ajoute un sous menu
                 if ab_UtiliseSousMenu
                 // Si un menu n'est pas null alors on ajoute un sous menu
                 and (   lNodeChild.Attributes [ CST_LEON_ACTION_IDREF ] <> Null )
                 // Si un sous menu n'est pas null et différent alors on ajoute un sous menu
                 and   (   ls_MenuGroup <> ls_SMenu )
//                 and (   axdo_FichierXML.FieldByName ( CST_SOUM_Clep ).Value <> Null )
                    Then
                     begin
                   // Si une fonction dans l'enregistrement précédent affectation dans l'ancienne xpbar
                       inc ( li_CompteurMenu ); // compteur de nom
                       // Création des menus
                       lMen_MenuEnCours := TMenuItem.Create ( aF_FormParent );

                       //Gestion des raccourcis d'aide
                       lMen_MenuEnCours.HelpContext := aMen_MenuVolet.HelpContext ;

                       lMen_MenuEnCours.Bitmap.Handle := 0 ;
                       // affectation du compteur de nom
                       lMen_MenuEnCours.Name := CST_MENU_NOM_DEBUT + IntToStr ( li_CompteurMenu );
                       // Menu Parent
                       lMen_Menu.Add ( lMen_MenuEnCours );
                       // affectation du libellé du sous menu
                       lMen_MenuEnCours.Caption := ls_MenuLabel;
                       lMen_MenuEnCours.Hint    := ls_MenuLabel ;
                       fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_SOUM_Bmp ), lMen_MenuEnCours.Bitmap, aBmp_DefaultPicture );
                       ls_SMenu := axdo_FichierXML.FieldByName ( CST_SOUM_Clep ).AsString ;
                  // On remet le compteur des fonctions à 0
      //                 li_CompteurFonctions := 0 ;
                     End ;
 }
      // Si il n'y a pas de menu
            if (  ls_MenuClep    = '' )
             then
              Begin

                  // Le Menu où on ajoute les fonctions devient le menu Ouvrir
                lMen_MenuEnCours := aMen_MenuParent ;
              End
             else // Si c'est une fonction ayant au moins un menu
              Begin
               // Création d'un menu ou d'une fonction xp bouton
//                SetLength ( gT_TableauMenus, High ( gT_TableauMenus ) + 2 );
//                gT_TableauMenus [ high ( gT_TableauMenus )].Image := nil ;
{              // Alors utilisation dans le tableau des menus pour les xp boutons
                if  assigned ( lMen_MenuEnCours.Bitmap )
                and ( lMen_MenuEnCours.Bitmap.Handle <> 0 )
                and ( aIma_ImagesTempo.Width  = lMen_MenuEnCours.Bitmap.Width  )
                and ( aIma_ImagesTempo.Height = lMen_MenuEnCours.Bitmap.Height )
                 Then
                  Begin
                    gT_TableauMenus [ High ( gT_TableauMenus )].Image := TIcon.Create ;
                    gT_TableauMenus [ High ( gT_TableauMenus )].Image.Handle := 0 ;
                    aIma_ImagesTempo.AddMasked ( lMen_MenuEnCours.Bitmap, lMen_MenuEnCours.Bitmap.TransparentColor );
                    aIma_ImagesTempo.GetBitmap ( aIma_ImagesTempo.Count - 1, lMen_MenuEnCours.Bitmap );
                    p_BitmapVersIco ( lMen_MenuEnCours.Bitmap, gT_TableauMenus [ High ( gT_TableauMenus )].Image );
                  End
                 Else}
//                  gT_TableauMenus [ High ( gT_TableauMenus )].Image := nil ;
//                gT_TableauMenus [ High ( gT_TableauMenus )].Menu := ls_MenuClep ;
{                if ab_UtiliseSousMenu
                and ( axdo_FichierXML.FieldByName ( CST_MENU_Clep ).Value <> Null )
                 Then
                  gT_TableauMenus [ High ( gT_TableauMenus )].SousMenu := axdo_FichierXML.FieldByName ( CST_SOUM_Clep ).AsString ;
 }//               gT_TableauMenus [ High ( gT_TableauMenus )].Fonction   := ls_MenuClep ;
              End ;
            // A chaque fonction création d'une action dans la bar XP
            if    assigned ( lMen_MenuEnCours )
            and ( ls_MenuClep <> '' )
             Then
              Begin
      //          inc ( li_CompteurFonctions );
                inc ( li_CompteurMenu );
                 p_getImageToBitmap ( ls_MenuPrefix, lbmp_BitmapOrigine );
                 // Affectation des valeurs de la queue
                      // Chargement de la fonction à partir de la table des fonctions
//                   lb_AjouteBitmap := fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_FONC_Bmp ), lbmp_BitmapOrigine, aBmp_DefaultPicture );
                    // Ajoute une fonction dans un menu
                    lMen_MenuEnfant := fmen_AjouteFonctionMenu  ( aF_FormParent        ,
                                            lMen_MenuEnCours     ,
                                            ls_MenuClep ,
                                            ls_MenuLabel, //axdo_FichierXML.FieldByName (  CST_FONC_Libelle ).AsString ,
                                            ls_MenuValue, //axdo_FichierXML.FieldByName (  CST_FONC_Type    ).AsString ,
                                            '', //axdo_FichierXML.FieldByName (  CST_FONC_Mode    ).AsString ,
                                            ls_MenuName, //axdo_FichierXML.FieldByName (  CST_FONC_Nom     ).AsString ,
                                            li_CompteurMenu      ,
                                            lbmp_BitmapOrigine   ,
                                            lb_AjouteBitmap      ,
                                            lb_ImageDefaut       ,
                                            aIma_ImagesMenus     ,
                                            ai_FinCompteurImages );
                    p_ajouteEvenement ( aF_FormParent           ,
                                            lMen_MenuEnfant     ,
                                            ls_MenuClep         ,
                                            CST_FONCTION_CLICK  ,
                                            CST_EVT_STANDARD    );
      //            End ;
                End;
              End ;
        End;
        // Au suivant !
    End ;
  // Si une fonction dans le dernier enregistrement affectation dans l'ancien menu
// inc ( li_CompteurMenu );
  if not Result // Si pas de menu
   Then  aMen_MenuParent.Visible := False // Alors pas de menu ouvrir
   Else  aMen_MenuParent.Visible := True ; // Sinon menu ouvrir
   // Libération du bitmap
  try
    lbmp_BitmapOrigine.Free ;
  Finally
  End ;
End ;

/////////////////////////////////////////////////////////////////////////
// procedure  p_DetruitLeSommaire
// Destroying toolbar from global variables
/////////////////////////////////////////////////////////////////////////
procedure  p_DetruitLeSommaire ();
Begin
  p_DetruitSommaire ( gBar_ToolBarParent      ,
                      gSep_ToolBarSepareDebut ,
                      gPan_PanelSepareFin     );
End ;
// Création des composant JvXPButton en fonction :
// as_SommaireEnCours      : Le sommaire
// aF_FormParent           : la form Propriétaire
// aBar_ToolBarParent      : La tool barre parent
// aSep_ToolBarSepareDebut : Le séparateur de début
// aSep_ToolBarSepareFin   : Le séparateur de fin
// ai_TailleUnPanel        : La taille d'un panel
// axdo_FichierXML    : Requête ADO des fonctions par menus et sous menus des utilisateurs
// aIco_DefaultPicture     : l'image par défaut si pas d'image
{
function  fi_CreeSommaireBlank () : Integer ;
Begin
  Result :=  fi_CreeSommaire ( gF_FormParent          ,
                        			 gF_FormParent          ,
                        			 gs_SommaireEnCours     ,
                        			 gxdo_FichierXML   ,
                        			 gIco_DefaultPicture    ,
                        			 gBar_ToolBarParent     ,
                               gSep_ToolBarSepareDebut,
                               gPan_PanelSepareFin    ,
                        			 gi_TailleUnPanel       ,
                        			 gBmp_DefaultPicture    ,
                        			 True                   ) ;

End ;
 }
{
function  fi_CreeSommaire (         const aF_FormMain             : TCustomForm  ;
                        			      const aF_FormParent           : TCustomForm  ;
                        			      const as_SommaireEnCours      : String       ;
                                    const axdo_FichierXML         : TALXMLDocument    ;
                        			      const aIco_DefaultPicture     : TIcon        ;
                        			      const aBar_ToolBarParent      : TExtToolbar   ;
                        			      const aSep_ToolBarSepareDebut : TExtToolbarSep;
                        			      const aPan_PanelSepareFin     : TWinControl  ;
                        			      const ai_TailleUnPanel        : Integer      ;
                        			      const aBmp_DefaultPicture     : TBitmap      ;
                        			      const ab_GestionGlobale       : Boolean      ) : Integer ;

var //lbtn_ToolBarButton  : TJvXPButton  ;  // Nouveau bouton
    lSep_ToolBarSepare  : TExtToolbarSep ; // Nouveau séparateur
    lPan_ToolBarPanel   : TPanel     ; // Nouveau panel
    lb_UtiliseSousMenu    ,
    lb_ExisteFonctionMenu : Boolean ;
    li_i                 : Longint;
//    li_FonctionEnCours  ,
    li_CompteurFonctions: Integer ; // Compteur fonctions
    lico_FonctionBitmap : TBitmap ;  // Icône de la Fonction en cours
Begin
  Result := 0 ;
// Tout doit exister
  if not assigned ( axdo_FichierXML            )
  or not assigned ( aF_FormMain                     )
  or not assigned ( aF_FormParent                   )
  or not assigned ( aBar_ToolBarParent              )
  or not assigned ( aSep_ToolBarSepareDebut         )
  or not assigned ( aPan_PanelSepareFin             )
   Then
    Exit ;

  try
    axdo_FichierXML.Active := True  ;
  Except
    Exit ;
  End ;
// Initialisation
  lico_FonctionBitmap := TBitmap.Create ;
  lico_FonctionBitmap.Handle := 0 ;

  li_CompteurFonctions := 0 ;
  lb_ExisteFonctionMenu := False ;

// Premier enregistrement
  if ( axdo_FichierXML.Active )
   Then
    Begin
      for li_i := 0 to fi_GetXMlNodeCount (axdo_FichierXML.Node ) - 1 do
        Begin
            if axdo_FichierXML.FindField   ( CST_FONC_Clep ) <> nil
             Then
              Begin
                fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_FONC_Bmp ), lico_FonctionBitmap, aBmp_DefaultPicture );

                p_AjouteEvenement     ( af_FormParent           ,
                        			          nil                     ,
                        			          ''                      ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Clep    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Libelle ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Type    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Mode    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Nom     ).AsString ,
                        			          lico_FonctionBitmap     ,
                        			          CST_EVT_STANDARD        );
             End ;
          axdo_FichierXML.Next ;
        End ;
    End ;
// destruction des composants du sommaire
  p_DetruitSommaire ( aBar_ToolBarParent              ,
                      aSep_ToolBarSepareDebut         ,
                      aPan_PanelSepareFin             );
//  p_DetruitComposantsDescendant ( aCon_ParentContainer );

  axdo_FichierXML.Close ;

  try
    axdo_FichierXML.Open  ;
    // Connecté dans la form
    if ( aF_FormMain is TF_FormMainIni )
     Then
      ( aF_FormMain as TF_FormMainIni ).p_Connectee ;
  Except
    // déconnecté dans la form
    if ( aF_FormMain is TF_FormMainIni )
     Then
      ( aF_FormMain as TF_FormMainIni ).p_NoConnexion ;
    Exit ;
  End ;
   if axdo_FichierXML.IsEmpty
   or ( axdo_FichierXML.FieldByName ( CST_SOMM_Niveau ).Value = Null )
   Then
    Begin
    // PAs de champ trouvé : erreur
//      ShowMessage ( 'Le champ ' + CST_SOMM_Niveau + ' est Null !' );
      Exit ;
    End ;

  // Utilise-t-on les sous menus ?
  lb_UtiliseSousMenu := axdo_FichierXML.Fields [ 0 ].AsBoolean ;
// Requête sommaire
  axdo_FichierXML.Close ;
//  Showmessage ( axdo_FichierXML.SQL.Text );
  try
    axdo_FichierXML.Open  ;
    // Connecté dans la form
    if ( aF_FormMain is TF_FormMainIni )
     Then
      ( aF_FormMain as TF_FormMainIni ).p_Connectee ;
  Except
    // déconnecté dans la form
    if ( aF_FormMain is TF_FormMainIni )
     Then
      ( aF_FormMain as TF_FormMainIni ).p_NoConnexion ;
  End ;
  // Rien alors pas de menu

  // Premier enregistrement
  if not ( axdo_FichierXML.Isempty )
   Then
    Begin
      axdo_FichierXML.FindFirst ;
      while not ( axdo_FichierXML.Eof ) do
        Begin
             // Incrmétation des fonctions en sortie
          inc ( li_CompteurFonctions );
           // Affectation des valeurs
           // création d''un panel d'un bouton d'un séparateur
          lPan_ToolBarPanel   := TPanel       .Create ( aF_FormParent ); // Nouveau panel
          lbtn_ToolBarButton  := TJvXPButton   .Create ( lPan_ToolBarPanel  );  // Nouveau bouton
          lSep_ToolBarSepare  := TExtToolbarSep.Create ( aF_FormParent );// Nouveau séparateur

          //Gestion des raccourcis d'aide
          lPan_ToolBarPanel .HelpType    := aBar_ToolBarParent.HelpType ;
          lPan_ToolBarPanel .HelpKeyword := aBar_ToolBarParent.HelpKeyword ;
          lPan_ToolBarPanel .HelpContext :=  aBar_ToolBarParent.HelpContext ;
          lbtn_ToolBarButton.HelpType    := aBar_ToolBarParent.HelpType ;
          lbtn_ToolBarButton.HelpKeyword := aBar_ToolBarParent.HelpKeyword ;
          lbtn_ToolBarButton.HelpContext :=  aBar_ToolBarParent.HelpContext ;
          lSep_ToolBarSepare.HelpContext :=  aBar_ToolBarParent.HelpContext ;
          lSep_ToolBarSepare.HelpType    := aBar_ToolBarParent.HelpType ;
          lSep_ToolBarSepare.HelpKeyword := aBar_ToolBarParent.HelpKeyword ;

          lbtn_ToolBarButton.Name := CST_DBT_NOM_DEBUT   + IntToStr ( li_CompteurFonctions );
          lSep_ToolBarSepare.Name := CST_SEP_NOM_DEBUT   + IntToStr ( li_CompteurFonctions );
          lPan_ToolBarPanel .Name := CST_PANEL_NOM_DEBUT + IntToStr ( li_CompteurFonctions );
          lPan_ToolBarPanel .Parent := aBar_ToolBarParent ; // Parent Barre  : Toolbar
          lSep_ToolBarSepare.Parent := aBar_ToolBarParent ; // Parent séparateur : Toolbar
          lbtn_ToolBarButton.Parent := lPan_ToolBarPanel  ; // Parent bouton : Panel
           // Aligne en haut
          aBar_ToolBarParent.Realign ;
          lPan_ToolBarPanel.Align      := alLeft ;
          lPan_ToolBarPanel.TabOrder   := aPan_PanelSepareFin.TabOrder - 1 ;
          aBar_ToolBarParent.OrderIndex [ lPan_ToolBarPanel ]  := aBar_ToolBarParent.OrderIndex [ aPan_PanelSepareFin ] ;
          lPan_ToolBarPanel.Width      := ai_TailleUnPanel ;
          lPan_ToolBarPanel.Height     := aPan_PanelSepareFin.Height ;
          lPan_ToolBarPanel.Caption    := '' ;
          lPan_ToolBarPanel.BevelOuter := bvNone ;
            // affectation du compteur de nom

    //      lSep_ToolBarSepare.Align    := alClient ;
          aBar_ToolBarParent.OrderIndex [ lSep_ToolBarSepare ]  := aBar_ToolBarParent.OrderIndex [ aPan_PanelSepareFin ] ;
             // affectation du libellé du menu
          lbtn_ToolBarButton.Layout   := blGlyphRight ;
          lbtn_ToolBarButton.Caption  := '' ;
          lbtn_ToolBarButton.ShowHint := True ;
          lbtn_ToolBarButton.Height  := aPan_PanelSepareFin.Height ;
          lbtn_ToolBarButton.Width   := lbtn_ToolBarButton.Height ;
          lbtn_ToolBarButton.Left    := ( lPan_ToolBarPanel.Width - lbtn_ToolBarButton.Width  ) div 2 ;
          if  lb_UtiliseSousMenu
          and ( axdo_FichierXML.FindField   ( CST_FONC_Clep ) <> nil )
          and ( axdo_FichierXML.FieldByName ( CST_FONC_Clep ).Value = Null )
           Then
            Begin
              lbtn_ToolBarButton.Hint     := axdo_FichierXML.FieldByName ( CST_MENU_Clep ).AsString ;
              lbtn_ToolBarButton.Tag      := 1 ;
              fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_MENU_Bmp ), lbtn_ToolBarButton.Glyph.Bitmap, aBmp_DefaultPicture );
              lb_ExisteFonctionMenu := True ;
              p_AjouteEvenement     ( af_FormParent           ,
                        			        lbtn_ToolBarButton      ,
                        			        lbtn_ToolBarButton.Name ,
                        			        axdo_FichierXML.FieldByName (  CST_MENU_Clep    ).AsString ,
                        			        axdo_FichierXML.FieldByName (  CST_MENU_Clep    ).AsString ,
                        			        CST_FCT_TYPE_MENU ,
                        			        '' ,
                        			        axdo_FichierXML.FieldByName (  CST_MENU_Clep    ).AsString ,
                        			        lbtn_ToolBarButton.Glyph.Bitmap,
                        			        CST_EVT_STANDARD        );
            End
           Else
            if axdo_FichierXML.FindField   ( CST_FONC_Clep ) <> nil
             Then
              Begin
                lbtn_ToolBarButton.Hint     := axdo_FichierXML.FieldByName ( CST_FONC_Libelle ).AsString ;
                lbtn_ToolBarButton.Tag      := 2 ;
                fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_FONC_Bmp ), lbtn_ToolBarButton.Glyph.Bitmap, aBmp_DefaultPicture );

                p_AjouteEvenement     ( af_FormParent           ,
                        			          lbtn_ToolBarButton      ,
                        			          lbtn_ToolBarButton.Name ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Clep    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Libelle ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Type    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Mode    ).AsString ,
                        			          axdo_FichierXML.FieldByName (  CST_FONC_Nom     ).AsString ,
                        			          lbtn_ToolBarButton.Glyph.Bitmap,
                        			          CST_EVT_STANDARD        );
             End ;
          lbtn_ToolBarButton.Show ;
          lSep_ToolBarSepare.Show ;
          lPan_ToolBarPanel .Show ;
            // Au suivant !
          axdo_FichierXML.Next ;
        End ;
    End ;
  // Si une fonction dans le dernier enregistrement affectation dans l'ancienne xpbar
   // Libération de l'icône
  lico_FonctionBitmap.Free ;

  Result := li_CompteurFonctions ;
  if not ab_GestionGlobale // On ne gère pas les variables globales
   Then
    Exit ;
  if  lb_ExisteFonctionMenu // Si il y a une fonction menu
//  and lb_UtiliseSousMenu       // Et on utilise les sous menus
   Then gMen_MenuVolet.Enabled := True
   Else
    if not lb_UtiliseSousMenu  // Si on n'utilise  pas les sous menus
     Then
      Begin
        fb_CreeXPButtons ( as_SommaireEnCours, '', aF_FormParent, aF_FormParent, gWin_ParentContainer, gMen_Menuvolet, aBmp_DefaultPicture  , True, gIma_ImagesXPBars   );
      End
    Else
     gMen_MenuVolet.Enabled := False ;

End ;
      }
/////////////////////////////////////////////////////////////////////////
// procedure  p_DetruitTout
// Destroying all menus built from global variables
// Destruction des composants dynamiques
// ab_DetruitMenu : Destroy windows menu items too
/////////////////////////////////////////////////////////////////////////

procedure  p_DetruitTout ( const ab_DetruitMenu : Boolean );
Begin
  if not assigned ( gMen_MenuVolet ) Then
    Exit;
// Fermeture avant destruction
  gNod_DashBoard := nil ;
  if gMen_MenuVolet .Checked
   Then
    gMen_MenuVolet .OnClick ( gMen_MenuVolet );
  gMen_MenuVolet .Enabled := False ;
  gMen_MenuParent.Visible := False ;
// destruction des items de menu
  if ab_DetruitMenu Then
    p_DetruitMenu ( gMen_MenuParent );
// destruction du sommaire
  p_DetruitLeSommaire;
// destruction des xp boutons
  p_DetruitXPBar ( gWin_ParentContainer );
  // Destruction des fonctions
End ;

/////////////////////////////////////////////////////////////////////////
// procedure p_LoadNodesEntities
// Searching some nodes in xml tree view
// ano_Node : A node
// ano_Parent  : Parent node
// ai_LastCFonction : Last compound function
/////////////////////////////////////////////////////////////////////////
procedure p_LoadNodesEntities ( const ano_Node,ano_Parent : TALXMLNode ; ai_LastCFonction  : Longint );
var li_i, li_j  : LongInt ;
    lNode, lNodeChild : TALXMLNode ;
    ls_Mode,
    lParam1,lParam2,lParam3,lPrefix: String;
    procedure p_SetAttributeValues;
      Begin
        if lnodeChild.NodeName = CST_LEON_ACTION_PREFIX then
          lPrefix :=  lnodeChild.Attributes [ CST_LEON_ACTION_VALUE ];
        if lnodeChild.NodeName = CST_LEON_ACTION_NAME then
          lParam1 :=  lnodeChild.Attributes [ CST_LEON_ACTION_VALUE ]
         else
          if lnodeChild.NodeName = CST_LEON_ACTION_GROUP then
            lParam2 :=  lnodeChild.Attributes [ CST_LEON_ACTION_VALUE ];
      end;

Begin
  for li_i := 0 to ano_Node.ChildNodes.Count - 1 do
    Begin
      lNode := ano_Node.ChildNodes [ li_i ];;
      if ( lNode.NodeName = CST_LEON_ACTION )
      or ( lNode.NodeName = CST_LEON_COMPOUND_ACTION ) then
        Begin
          if lnode.Attributes [ CST_LEON_TEMPLATE ] =  CST_LEON_TEMPLATE_DASHBOARD then
            Begin
              gnod_DashBoard := lnode;
              if gnod_DashBoard.HasChildNodes Then
                for li_j := 0 to gnod_DashBoard.ChildNodes.Count -1 do
                  if gnod_DashBoard.ChildNodes [ li_j ].NodeName = CST_LEON_ACTIONS Then
                    p_LoadNodesEntities ( gnod_DashBoard.ChildNodes [ li_j ], gnod_DashBoard, -1 );
              Continue;
            End;

          lParam1 := '' ;
          lParam2 := '' ;
          lParam3 := '' ;
          lPrefix := '';

//          Showmessage ( lNode.XML );
//          if lnode.HasAttribute ( CST_LEON_TEMPLATE ) then
//              ShowMessage ( lNode.XML );

          // On ajoute la fonction complémentaire
          if  ( lnode.HasChildNodes ) then
            for  li_j := 0 to lNode.ChildNodes.count - 1 do
              Begin
                lNodeChild := lNode.ChildNodes [ li_j ];
                p_SetAttributeValues;
                if lnodeChild.NodeName = CST_LEON_PARAMETER then
                  Begin
                    if  ( lnodeChild.HasAttribute ( CST_LEON_PARAMETER_name ) )
                    and ( lnodeChild.Attributes [ CST_LEON_PARAMETER_name ] = CST_LEON_PARAMETER_CLASSINFO ) Then
                      lParam3 :=  lnodeChild.Attributes [ CST_LEON_PARAMETER_IDREF ];
                  End;
              End;

          // On ajoute la fonction action
           Begin
             SetLength ( ga_Functions, high ( ga_Functions ) + 2 );
             with ga_Functions [ high ( ga_Functions )] do
               Begin
                 Clep := lnode.Attributes [ CST_LEON_ID ];
                 Groupe := lParam2;
                 Name   := lParam1;
                 AFile  := lParam3;
                 Prefix := lPrefix;
{                 if (  Name = '' ) then
                   Begin
                     ShowMessage (  Gs_EmptyFunctionName +  Clep );
                   End;   }
                 if lNode.Attributes [ CST_LEON_ACTION_TEMPLATE ] = CST_LEON_TEMPLATE_MULTIPAGETABLE then
                   Template := atMultiPageTable ;
                 finalize ( Functions );
                 if ls_Mode =' '
                   Then Mode := fsStayOnTop
                   Else if ls_Mode = ' '
                     Then Mode := fsNormal
                     Else Mode := fsMDIChild ;
               End;

             if ( lNode.NodeName = CST_LEON_COMPOUND_ACTION ) then
               if  ( lnode.HasChildNodes ) then
                 for  li_j := 0 to  lNode.ChildNodes.Count- 1 do
                  Begin
                    lNodeChild := lNode.ChildNodes [ li_j ];
                    p_SetAttributeValues;
                    finalize (ga_Functions [high ( ga_Functions )].Functions);
                    if  ( lnode.NodeName = CST_LEON_COMPOUND_ACTION ) Then
                      p_LoadNodesEntities ( lnode, ano_Node, high ( ga_Functions ) );
                  End;
           End;
        End
       else
        if  ( lnode.NodeName = CST_LEON_ACTION_REF )
        and ( ano_Node.NodeName = CST_LEON_COMPOUND_ACTION ) then
          Begin
            SetLength ( ga_Functions [ ai_LastCFonction ].Functions, high ( ga_Functions [ ai_LastCFonction ].Functions ) + 2 );
            ga_Functions [ ai_LastCFonction ].Functions [ high ( ga_Functions [ ai_LastCFonction ].Functions )] := lnode.Attributes [ CST_LEON_ACTION_IDREF ];
          End;
    End;
End;

/////////////////////////////////////////////////////////////////////////
// Procédure  p_LoadNavigationTree
// Searching in XML Navigation tree document for entities
// Chargement de l'arbre de login et menu
// axdo_FichierXML : XML Navigation tree file
/////////////////////////////////////////////////////////////////////////
procedure p_LoadNavigationTree  ( const axdo_FichierXML : TALXMLDocument );
var lnod_Node : TALXMLNode ;
    li_i, li_j : Longint ;
Begin
  for li_i := 0 to axdo_FichierXML.ChildNodes.Count - 1 do
    Begin
      lnod_Node := axdo_FichierXML.ChildNodes [ li_i ];
      if lnod_Node.NodeName = CST_LEON_ACTION then
        for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
         if lnod_Node.ChildNodes [ li_j ].NodeName = CST_LEON_ACTIONS Then
           p_LoadNodesEntities ( lnod_Node.ChildNodes [ li_j ], nil, -1 );
    End;

end;

/////////////////////////////////////////////////////////////////////////
// Procédure  p_CreateRootEntititiesForm
// Creating login root form
// Il n'y a pas de menu donc rootentities est une fenêtre
/////////////////////////////////////////////////////////////////////////
procedure p_CreateRootEntititiesForm;
var lMen_MenuRoot : TMenuItem ;
Begin
 SetLength ( ga_Functions, high ( ga_Functions ) + 2 );
 with ga_Functions [ high ( ga_Functions )] do
   Begin
     Afile := gs_RootEntities;
     Clep  := CST_XMLFRAMES_ROOT_FORM_CLEP ;
     Name := Gs_RootForm;
     Mode := fsMDIChild ;
     Template := atmultiPageTable;
     
       // Création des menus
     lMen_MenuRoot := TMenuItem.Create ( gF_FormParent );
     lMen_MenuRoot.Bitmap.Handle := 0 ;

     //Gestion des raccourcis d'aide
     lMen_MenuRoot.HelpContext := gMen_MenuVolet.HelpContext ;

      // affectation du compteur de nom
     p_setComponentName ( lMen_MenuRoot, CST_XMLFRAMES_ROOT_FORM_CLEP );
     gMen_MenuParent.Add ( lMen_MenuRoot );
     // affectation du libellé du menu
     lMen_MenuRoot.Caption := Gs_RootForm;
     lMen_MenuRoot.Hint    := lMen_MenuRoot.Caption;
   End;
   p_ExecuteFonction ( lMen_MenuRoot );
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_LoadEntitites
// Calling a recursive procedure loading entities from XML Document
// axdo_FichierXML : XML entities file
/////////////////////////////////////////////////////////////////////////
procedure p_LoadEntitites ( const axdo_FichierXML : TALXMLDocument );

Begin
  p_LoadNodesEntities ( axdo_FichierXML.node, nil , -1 );
End;

/////////////////////////////////////////////////////////////////////////
// Procédure p_Loaddata
// Loading data link
// Charge le lien de données
// axno_Node : xml data document
/////////////////////////////////////////////////////////////////////////
procedure p_LoadData ( const axno_Node : TALXMLNode );
var li_i : LongInt ;
    li_Pos ,
    li_connection : Integer;
    lNode : TALXMLNode ;
    ls_ConnectionClep : String;
Begin
  for li_i := 0 to axno_Node.ChildNodes.Count - 1 do
    Begin
      lNode := axno_Node.ChildNodes [ li_i ];
      if (   ( lNode.NodeName = CST_LEON_DATA_FILE )
          or ( lNode.NodeName = CST_LEON_DATA_SQL  ))
      and lNode.HasAttribute(CST_LEON_ID)
      then
       Begin
        // Le module M_Donnees n'est pas encore chargé
        ls_ConnectionClep := lNode.Attributes [CST_LEON_ID];
        li_connection:= fi_FindConnection(ls_ConnectionClep, False);
        if li_connection > -1 Then
          Continue;
        if ( lNode.NodeName = CST_LEON_DATA_FILE ) Then
          Begin
            M_Donnees.CreateConnection ( dtCSV, ls_ConnectionClep );
            with ga_Connections [ high ( ga_Connections )] do
              Begin
                s_dataURL := fs_LeonFilter ( lNode.Attributes [ CST_LEON_DATA_URL ])+DirectorySeparator + lNode.Attributes [ CST_LEON_ID ] + '#';
                {$IFDEF WINDOWS}
                s_dataURL := fs_RemplaceChar ( s_DataURL, '/', '\' );
                {$ENDIF}
              end;
          end
         Else
          Begin
            M_Donnees.CreateConnection ( dtZEOS, ls_ConnectionClep );
            with ga_Connections [ high ( ga_Connections )] do
              Begin
                s_dataURL := lNode.Attributes [ CST_LEON_DATA_URL ];
                li_Pos := pos ( '//', s_dataURL );
                s_dataURL := copy ( s_DataURL , li_pos + 2, length ( s_DataURL ) - li_pos - 1 );
                i_DataPort := 0;
                li_Pos := pos ( ':', s_DataURL );
                // Récupération du port
                if li_Pos > 0 Then
                  try
                    if pos ( '/', s_DataURL ) > 0 Then
                      i_DataPort    := StrToInt ( copy ( s_dataURL, li_Pos + 1, pos ( '/', s_dataURL ) - li_pos - 1 ))
                     Else
                      i_DataPort    := StrToInt ( copy ( s_dataURL, li_Pos + 1, length ( s_dataURL ) - li_pos ));
                    // Finition de l'URL : Elle ne contient que l'adresse du serveur
                    s_DataURL := copy ( s_DataURL , 1, li_Pos - 1 );
                  Except
                  end;
                if ( s_DataURL [ length ( s_DataURL )] = '/' ) Then
                  s_DataURL := copy ( s_DataURL , 1, length ( s_DataURL ) - 1 );
                s_DataUser := lNode.Attributes [ CST_LEON_DATA_USER ];
                s_DataPassword := lNode.Attributes [ CST_LEON_DATA_Password ];
                s_Database := lNode.Attributes [ CST_LEON_DATA_DATABASE ];
                s_DataDriver := lNode.Attributes [ CST_LEON_DATA_DRIVER ];
                {$IFDEF ZEOS}
                case dtt_DatasetType of
                    dtZEOS : Begin
                             p_setComponentProperty ( com_Connection, 'User', s_DataUser );
                             p_setComponentProperty ( com_Connection, 'Password', s_DataPassword );
                             p_setComponentProperty ( com_Connection, 'Hostname', s_DataURL );
                             p_setComponentProperty ( com_Connection, 'Database', s_Database );
                             if i_DataPort > 0 Then
                               p_setComponentProperty ( com_Connection, 'Port', i_DataPort );
                             if ( pos ( CST_LEON_DATA_MYSQL, s_DataDriver ) > 0 ) Then
                               p_setComponentProperty ( com_Connection, 'Protocol', CST_LEON_DRIVER_MYSQL )
                             else if ( pos ( CST_LEON_DATA_FIREBIRD, s_DataDriver ) > 0 ) Then
                               p_setComponentProperty ( com_Connection, 'Protocol', CST_LEON_DRIVER_FIREBIRD )
                             else if ( pos ( CST_LEON_DATA_SQLLITE, s_DataDriver ) > 0 ) Then
                               p_setComponentProperty ( com_Connection, 'Protocol', CST_LEON_DRIVER_SQLLITE )
                             else if ( pos ( CST_LEON_DATA_ORACLE, s_DataDriver ) > 0 ) Then
                               p_setComponentProperty ( com_Connection, 'Protocol', CST_LEON_DRIVER_ORACLE )
                             else if ( pos ( CST_LEON_DATA_POSTGRES, s_DataDriver ) > 0 ) Then
                               p_setComponentProperty ( com_Connection, 'Protocol', CST_LEON_DRIVER_POSTGRES );
                             try
                               p_setComponentBoolProperty ( com_Connection, 'Connected', True );
                             except
                               on e: Exception do
                                 ShowMessage ( 'Could not initiate connection on ' + s_DataDriver + ' and ' + s_DataURL +#13#10 + 'User : ' + s_DataUser +#13#10 + 'Base : ' + s_Database +#13#10   );
                             end;
                           end;
                End;
                {$ENDIF}
              end;
          end;
       End;
    End;
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_BuildFromXML
// recursive loading entities menu and data
// Level : recursive level
// aNode : recursive node
// abo_BuildOrder : entities to load
/////////////////////////////////////////////////////////////////////////
procedure p_BuildFromXML ( Level : Integer ; const aNode : TALXMLNode; const abo_BuildOrder : TBuildOrder ) ;
var li_i : Integer ;
    lNode : TALXMLNode ;
    ls_EntityFile   : String ;
    lxdo_FichierXML : TALXMLDocument;
    lb_Login, lb_CreateNavigation : Boolean;
Begin
   lxdo_FichierXML := nil ;
   lb_Login := False;
   if ( aNode.HasChildNodes ) then
     for li_i := 0 to aNode.ChildNodes.Count - 1 do
      Begin
        lNode := aNode.ChildNodes [ li_i ];
//        if (  lNode.IsTextElement ) then
//          ShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.NodeValue)
//         else
        if ( lNode.NodeName = CST_LEON_PROJECT )
        and ( abo_BuildOrder = boConnect ) Then
          Begin
            p_LoadData ( lNode );
          end;
        if ( copy ( lNode.NodeName, 1, 8 ) = CST_LEON_ENTITY )
        and (  lNode.HasAttribute ( CST_LEON_DUMMY ) ) then
          Begin
//            ShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.Attributes [ 'DUMMY' ]);
            ls_EntityFile := lNode.Attributes [ CST_LEON_DUMMY ];
            {$IFDEF WINDOWS}
            ls_EntityFile := fs_RemplaceChar ( ls_EntityFile, '/', '\' );
            {$ENDIF}
            // Pas besoin du chemin complet
            if abo_BuildOrder = boMenus then
              Begin
                gs_RootEntities := fs_EraseFirstDirectory ( fs_EraseFirstDirectory ( ls_EntityFile ));
                if pos ( '.', gs_RootEntities ) > 0 then
                  Begin
                    gs_RootEntities := copy ( gs_RootEntities, 1, pos ( '.', gs_RootEntities ) - 1 );
                  End;
              End;

            ls_EntityFile := fs_getSoftDir + fs_EraseFirstDirectory ( ls_EntityFile );
            if FileExists ( ls_EntityFile ) then
              Begin
                case abo_BuildOrder of
                  boMenus :
                    Begin
                      lb_CreateNavigation := False;
                      if  ( pos ( CST_LEON_SYSTEM_ROOT, lNode.NodeName ) > 0 )
                       then
                         Begin
                           lb_CreateNavigation := True;
                           if not assigned ( gxdo_MenuXML ) Then
                             gxdo_ActionsXML := TALXMLDocument.Create(Application);
                           if fb_LoadXMLFile ( gxdo_ActionsXML, ls_EntityFile ) then
                             p_LoadEntitites ( gxdo_ActionsXML );
                         End;
                      if  ( pos ( CST_LEON_SYSTEM_NAVIGATION, lNode.NodeName ) > 0 )
                       then
                         Begin
                           lb_CreateNavigation := True;
                           lb_Login := fb_NavigationTree ( ls_EntityFile );
                         End;
                       if not ( lb_Login )
                       and lb_CreateNavigation
                       and assigned ( gxdo_MenuXML )
                       and assigned ( gxdo_ActionsXML ) then
                         p_CreeAppliFromNode ( ls_entityFile );
                     End;
                  boConnect :
                    Begin
                      if  ( pos ( CST_LEON_SYSTEM_LOCATION, lNode.NodeName ) > 0 ) Then
                       Begin
                         if lxdo_FichierXML = nil then
                           lxdo_FichierXML := TALXMLDocument.Create(Application);
                          if fb_LoadXMLFile ( lxdo_FichierXML, ls_EntityFile )
                           then
                             p_LoadData ( lxdo_FichierXML.Node );
                       End;
                    End;
                 end;
              End;
          End;
//         else
//          ShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.ClassName);
        p_BuildFromXML ( Level + 1, lNode, abo_BuildOrder );
      End;
   lxdo_FichierXML.Free;
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_CreeAppliFromNode
// creating root login if no dashboard
// as_EntityFile : xml file login
/////////////////////////////////////////////////////////////////////////
procedure p_CreeAppliFromNode ( const as_EntityFile : String );
Begin
 if not assigned ( gNod_DashBoard ) then
   Begin
     SetLength( ga_Functions, high ( ga_Functions ) +2  );
     with ( ga_Functions [ high ( ga_Functions ) ] ) do
       Begin
         Clep  := fs_ExtractFileNameOnly ( as_EntityFile );
         AFile := Clep;
         Name  := fs_GetNameSoft;
         Mode  := fsMDIChild;
       end;
     p_ExecuteNoFonction(high ( ga_Functions ), True);
   End
 Else
  fb_CreeLeMenu ( );
End;
/////////////////////////////////////////////////////////////////////////
// function fb_NavigationTree
// Loading navigation and login
// as_EntityFile : navigation tree file
/////////////////////////////////////////////////////////////////////////
function fb_NavigationTree ( const as_EntityFile : String ):Boolean;
var
    li_i : Longint;
    lnod_Node : TALXMLNode ;
Begin
 if not assigned ( gxdo_MenuXML ) Then
   gxdo_MenuXML := TALXMLDocument.Create(Application);
 Result := False;
 if fb_LoadXMLFile ( gxdo_MenuXML, as_EntityFile ) then
   Begin
     p_LoadNavigationTree ( gxdo_MenuXML );
     for li_i := 0 to gxdo_MenuXML.ChildNodes.Count -1  do
       Begin
         lnod_Node := gxdo_MenuXML.ChildNodes [li_i];
         if  ( lnod_Node.NodeName = CST_LEON_ACTION )
         and lnod_Node.HasAttribute(CST_LEON_TEMPLATE)
         and ( lnod_Node.Attributes[CST_LEON_TEMPLATE] = CST_LEON_TEMPLATE_LOGIN )
          Then
           Begin
             gf_Users := TF_XMLForm.Create ( Application );
             (gf_Users as TF_XMLForm).p_setLogin(gxdo_MenuXML);
             Result := True;
           end;
       end;
   end;
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_InitIniProjectFile
// loading ini : if no ini lazarus file creating a line and saving
/////////////////////////////////////////////////////////////////////////
procedure p_InitIniProjectFile;
var lstl_FichierIni : TSTringList ;
Begin
  if ( gs_ProjectFile = '' ) then
    Begin
      lstl_FichierIni := TStringList.Create ;
      try
        lstl_FichierIni.LoadFromFile( fs_getSoftDir + fs_GetNameSoft + CST_EXTENSION_INI);
        if ( pos ( INISEC_PAR, lstl_FichierIni [ 0 ] ) <= 0 ) Then
          Begin
            lstl_FichierIni.Insert(0,'['+INISEC_PAR+']');
            lstl_FichierIni.SaveToFile(fs_getSoftDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI );
            lstl_FichierIni.Free;
            Showmessage ( 'New INI in '+ fs_getSoftDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI + '.'+#13#10+#13#10 +
                          'Restart.');
            Application.Terminate;
            Exit;
          End;
      Except
        lstl_FichierIni.Free;
      End;
    End;
End;

/////////////////////////////////////////////////////////////////////////
// function fb_ReadIni
// reading ini and creating project
// Lecture du fichier INI
// Résultat : il y a un fichier projet.
// amif_Init : ini file
/////////////////////////////////////////////////////////////////////////
function fb_ReadIni ( var amif_Init : TIniFile ) : Boolean;
Begin
  Result := False;
  gs_Language := 'en';
  gs_NomApp := fs_GetNameSoft;
  if not assigned ( amif_Init ) then
    amif_Init := TMemIniFile.Create(fs_getSoftDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI);
  if assigned ( amif_Init ) Then
    Begin
      gs_ProjectFile := amif_Init.ReadString(INISEC_PAR,CST_INI_PROJECT_FILE,'');
      gs_Language    := amif_Init.ReadString(INISEC_PAR,CST_INI_LANGUAGE,'en');
      fb_ReadLanguage ( gs_Language );

      p_InitIniProjectFile;

      if not assigned ( gxdo_FichierXML ) then
        gxdo_FichierXML := TALXMLDocument.Create ( Application );
      Result := gs_ProjectFile <> '';
      if result Then
        Begin
          {$IFDEF WINDOWS}
          gs_ProjectFile := fs_RemplaceChar ( gs_ProjectFile, '/', '\' );
          {$ENDIF}
          gs_ProjectFile := fs_EraseNameSoft ( gs_ProjectFile );
          gchar_DecimalSeparator := ',' ;
          DecimalSeparator := gchar_DecimalSeparator ;
//          Showmessage ( fs_getSoftDir + gs_ProjectFile );

          if fb_LoadXMLFile ( gxdo_FichierXML, fs_getSoftDir + gs_ProjectFile ) Then
            Begin
             p_BuildFromXML ( 0, gxdo_FichierXML.Node, boConnect) ;
            End;

        End;
  End;
End;
////////////////////////////////////////////////////////////////////////////////
// Fonction fb_ReadLanguage
// Lecture du fichier de langue leonardi
// reading leonardi language file
// as_little_lang : language on two chars
////////////////////////////////////////////////////////////////////////////////
function fb_ReadLanguage (const as_little_lang : String ) : Boolean;
Begin
  Result := False;
  gstl_Labels.Free;
  gstl_Labels := TStringlist.Create ;
  if fileExists ( fs_getSoftDir + 'properties'+ DirectorySeparator + 'strings_'+gs_NomApp + '_'+ as_little_lang+'.properties' ) then
    Begin
      gstl_Labels.LoadFromFile ( fs_getSoftDir + 'properties'+ DirectorySeparator + 'strings_'+gs_NomApp + '_'+ as_little_lang + '.properties' );
      if assigned ( gmif_MainFormIniInit ) then
        Begin
          gmif_MainFormIniInit.WriteString(INISEC_PAR,CST_INI_LANGUAGE,as_little_lang);
          fb_iniWriteFile( gmif_MainFormIniInit, False );
        End;
      // La fenêtre n'est peut-être pas encore complètement créée
      fb_CreeLeMenu;
      Result := True;
    End
  else if fileExists ( fs_getSoftDir + 'properties'+ DirectorySeparator + 'strings_'+gs_NomApp + '_en.properties' ) then
    Begin
      gstl_Labels.LoadFromFile ( fs_getSoftDir + 'properties'+ DirectorySeparator + 'strings_'+gs_NomApp + '_en.properties' );
    End;
End;
////////////////////////////////////////////////////////////////////////////////
// function fb_ReadXMLEntitites
// destroying and Loading prject xml files
// Résultat : il y a un fichier projet.
////////////////////////////////////////////////////////////////////////////////
function fb_ReadXMLEntitites () : Boolean;
Begin
  Result := gs_ProjectFile <> '';
  gxdo_ActionsXML.Free;
  gxdo_MenuXML   .Free;
  gxdo_ActionsXML := nil;
  gxdo_MenuXML    := nil;
  if result Then
    Begin
      p_BuildFromXML ( 0, gxdo_FichierXML.Node, boMenus ) ;
    End;
End;

procedure p_CopyLeonFunction ( const ar_Source : TLeonFunction ; var ar_Destination : TLeonFunction );
var li_i: Integer ;
Begin
  with ar_Source do
    Begin
      ar_Destination.Clep     := clep;
      ar_Destination.Name     := Name;
      ar_Destination.Mode     := Mode;
      ar_Destination.Groupe   := Groupe ;
      ar_Destination.AFile    := AFile  ;
      ar_Destination.Template := Template  ;
      ar_Destination.Value    := Value  ;
      finalize ( ar_Destination.Functions );
      setLength ( ar_Destination.Functions, high ( Functions ) + 1 );
      for li_i := 0 to high ( Functions ) do
        ar_Destination.Functions [ li_i ] := Functions [ li_i ];
    End;

End;

////////////////////////////////////////////////////////////////////////////////
// Modifie une xpbar
// adx_WinXpBar            : Parent
// as_Fonction             : Fonction
// as_FonctionLibelle      : Libellé de Fonction
// as_FonctionType         : Type de Fonction
// as_FonctionMode         : Mode de la Fonction
// as_FonctionNom          : Nom de la Fonction
// aIco_Picture            : Icône de la fonction à utiliser
// ai_Compteur             : Compteur de nom
////////////////////////////////////////////////////////////////////////////////
procedure p_ModifieXPBar  ( const aF_FormParent       : TCustomForm        ;
                            const adx_WinXpBar        : TJvXpBar ;
                            const as_Fonction         ,
                                  as_FonctionLibelle  ,
                                  as_FonctionType     ,
                                  as_FonctionMode     ,
                                  as_FonctionNom      : String      ;
                            const aIma_ListeImages    : TImageList  ;
                            const abmp_Picture        ,
                                  abmp_DefaultPicture : TBitmap     ;
                            const ab_AjouteEvenement   : Boolean   );
//var lbmp_Bitmap : TBitmap ;
Begin
  //création d'une action dans la bar XP
// Transformation d'un champ bitmap en TIcon
  fonctions_Objets_Dynamiques.p_ModifieXPBar(aF_FormParent       ,
                                             adx_WinXpBar        ,
                                             as_Fonction         ,
                                             as_FonctionLibelle  ,
                                             as_FonctionType     ,
                                             as_FonctionMode     ,
                                             as_FonctionNom      ,
                                             aIma_ListeImages    ,
                                             abmp_Picture        ,
                                             abmp_DefaultPicture ,
                                             ab_AjouteEvenement  );
  p_setComponentName ( adx_WinXpBar, as_Fonction );
End ;

////////////////////////////////////////////////////////////////////////////////
// function fdoc_GetCrossLinkFunction
// Getting over side link of relationships
// as_FunctionClep    : String
// as_Table           : Table name and class name
// as_connection      : connect link key
// aanod_idRelation   : List to add link
// anod_NodeCrossLink : linked node in other file
////////////////////////////////////////////////////////////////////////////////
function fdoc_GetCrossLinkFunction( const as_FunctionClep :String;
                                    var as_Table, as_connection : String; var aanod_idRelation : TList ;
                                    var anod_NodeCrossLink : TALXMLNode ): TALXMLDocument ;
var li_i , li_j, li_k: Integer ;
    lnod_ClassProperties,
    lnod_Node : TALXMLNode;
    ls_ProjectFile : String;
begin
  Result := TALXMLDocument.Create ( Application );
  ls_ProjectFile := fs_getProjectDir ( ) + as_Table + CST_LEON_File_Extension;
  If ( FileExists ( ls_ProjectFile )) Then
    try
      if fb_LoadXMLFile ( Result, ls_ProjectFile ) Then
        Begin
          for li_i := 0 to Result.ChildNodes.Count -1 do
            Begin
              lnod_Node := Result.ChildNodes [ li_i ];
              if not assigned ( anod_NodeCrossLink )
              and fb_GetCrossLinkFunction(as_FunctionClep,lnod_Node ) Then
                anod_NodeCrossLink := lnod_Node;
              if lnod_Node.NodeName = CST_LEON_CLASS then
                Begin
                  for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
                    Begin
                      lnod_ClassProperties := lnod_Node.ChildNodes [ li_j ];
                      if lnod_ClassProperties.NodeName = CST_LEON_CLASS_BIND Then
                        Begin
                          as_Table := lnod_ClassProperties.Attributes [ CST_LEON_VALUE ];
                          as_connection:= lnod_ClassProperties.Attributes [ CST_LEON_LOCATION ];
                        end;
                      if  ( lnod_ClassProperties.NodeName = CST_LEON_FIELDS ) then
                        Begin
                          for li_k := 0 to lnod_ClassProperties.ChildNodes.Count -1 do
                            Begin
                              p_GetMarkFunction(lnod_ClassProperties.ChildNodes [ li_k ], CST_LEON_FIELD_id, aanod_idRelation );
                            End;
                        End;
                    End;
                End;
            End;
        End;
    Except
      On E: Exception do
        Begin
          ShowMessage ( 'Erreur : ' + E.Message );
        End;
    End ;
end;

////////////////////////////////////////////////////////////////////////////////
// fonction ffd_CreateFieldDef
// creating CSV definition properties
// Création de la définition de champ pour les fichiers CSV
// anod_Field : Field node
// ab_isLarge : Large or little field
// afd_FieldsDefs : CSV definitions to add definition
// result a field definition
////////////////////////////////////////////////////////////////////////////////
function ffd_CreateFieldDef ( const anod_Field : TALXMLNode ; const ab_isLarge : Boolean ; const afd_FieldsDefs : TFieldDefs ):TFieldDef;
var lft_FieldType : TFieldType;
begin
  Result := nil;

  if assigned ( afd_FieldsDefs ) then
    Begin
      lft_FieldType := ftString;
      if anod_Field.NodeName = CST_LEON_FIELD_NUMBER then
        Begin
          lft_FieldType := ftCurrency;
        End
      else if anod_Field.NodeName = CST_LEON_FIELD_TEXT then
        Begin
          if ab_isLarge Then
            Begin
              lft_FieldType := ftBlob;
            End
           Else
            Begin
              lft_FieldType := ftString;
            End
        End
      else if anod_Field.NodeName = CST_LEON_FIELD_FILE then
        Begin
          lft_FieldType := ftString;
        End
      else if anod_Field.NodeName = CST_LEON_FIELD_RELATION then
        Begin
        End
      else if anod_Field.NodeName = CST_LEON_FIELD_DATE then
        Begin
          lft_FieldType := ftDate;
        End
      else if anod_Field.NodeName = CST_LEON_FIELD_CHOICE then
        Begin
          lft_FieldType := ftInteger;
        End;

     afd_FieldsDefs.Add ( anod_Field.Attributes [ CST_LEON_ID ], lft_FieldType, 0 );
     Result := afd_FieldsDefs [ afd_FieldsDefs.Count - 1];
    End;
end;


////////////////////////////////////////////////////////////////////////////////
// procedure p_setFieldDefs
// getting CSV definitions and adding them from file
// adat_Dataset : CSV dataset
// alis_NodeFields : node of field nodes
////////////////////////////////////////////////////////////////////////////////

procedure p_setFieldDefs ( const adat_Dataset : TDataset ; const alis_NodeFields : TList );
var lfds_FieldDefs : TFieldDefs;
    li_i : Integer ;
begin
  lfds_FieldDefs := fobj_getComponentObjectProperty(adat_Dataset,'FieldDefs') as TFieldDefs;
  for li_i := 0 to  alis_NodeFields.count - 1 do
    Begin
       ffd_CreateFieldDef ( TALXMLNode ( alis_NodeFields [ li_i ] ), False, lfds_FieldDefs );
    End;
End;

////////////////////////////////////////////////////////////////////////////////
// function fs_GetStringFields
// getting a list separated by comma from nodes
// alis_NodeFields : Node fields
// as_Empty        : if empty put this string
////////////////////////////////////////////////////////////////////////////////
function fs_GetStringFields  ( const alis_NodeFields : TList ; const as_Empty : String ):String;
var
    li_i : Integer ;
Begin
  Result := as_Empty;
  for li_i := 0 to  alis_NodeFields.count - 1 do
    if li_i = 0 Then
      Result := fs_GetNodeAttribute( TALXMLNode ( alis_NodeFields [ li_i ] ), CST_LEON_ID )
     Else
      Result := Result + ',' + fs_GetNodeAttribute( TALXMLNode ( alis_NodeFields [ li_i ] ), CST_LEON_ID );
end;

////////////////////////////////////////////////////////////////////////////////
// function fds_CreateDataSourceAndOpenedQuery
// create datasource, dataset, setting and open it
// as_Table      : Table name
// as_Fields     : List of fields with comma
// as_NameEnd    : End of components' names
// ar_Connection : Connection of table
// alis_NodeFields : Node of fields' nodes
////////////////////////////////////////////////////////////////////////////////
function fds_CreateDataSourceAndOpenedQuery ( const as_Table, as_Fields, as_NameEnd : String  ; const ar_Connection : TAConnection; const alis_NodeFields : TList ; const acom_Owner : TComponent): TDatasource;
begin
  with ar_Connection do
    Begin
      Result := fds_CreateDataSourceAndDataset ( as_Table, as_NameEnd, dat_QueryCopy, acom_Owner );
      case dtt_DatasetType of
        dtCSV  :
         Begin
          p_setComponentProperty ( Result.Dataset, 'FileName', s_DataURL + as_Table + CST_LEON_Data_Extension );
          p_setFieldDefs ( Result.Dataset, alis_NodeFields );
        end;
       else
        p_SetSQLQuery(Result.Dataset, 'SELECT '+as_Fields + ' FROM ' + as_Table );
      End;
    end;
  Result.Dataset.Open;
end;



initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_Objets_XML );
{$ENDIF}
end.
