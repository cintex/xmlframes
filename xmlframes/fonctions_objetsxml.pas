unit fonctions_ObjetsXML;

interface

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{

Créée par Matthieu Giroux le 01-2004

Pas de XMLForm SVP

Fonctionnalités :

Création de la barre d'accès
Création du menu d'accès
Création du volet d'accès

English

No XMLForm please

}

uses Forms, JvXPBar, LCLType,
{$IFNDEF FPC}
   Windows, ToolWin,
{$ENDIF}
  Controls, Classes, JvXPButtons, ExtCtrls,
  Menus,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
{$IFDEF TNT}
  TntForms,TntStdCtrls, TntExtCtrls,
{$ENDIF}
  ALXmlDoc, IniFiles, Graphics,
  u_multidata,
  fonctions_string,
  fonctions_dbservice,
  fonctions_manbase,
  fonctions_system;

{$IFDEF VERSIONS}
const
  gver_fonctions_Objets_XML : T_Version = (Component : 'Gestion des objets dynamiques XML' ;
                                           FileUnit : 'fonctions_ObjetsXML' ;
              			           Owner : 'Matthieu Giroux' ;
              			           Comment : 'Gestion des données des objets dynamiques de la Fenêtre principale.' + #13#10 + 'Il comprend une création de menus' ;
              			           BugsStory : 'Version 1.0.2.0 : Centralising setting Properties on TFWTable.'  + #13#10 +
                                                       'Version 1.0.1.1 : Centralising getting Properties into fonctions_languages.'  + #13#10 +
                                                       'Version 1.0.1.0 : Integrating TXMLFillCombo button.'  + #13#10 +
                                                       'Version 1.0.0.6 : Images on menu items.' + #13#10 +
                                                       'Version 1.0.0.5 : No ExtToolbar.' + #13#10 +
                                                       'Version 1.0.0.4 : Testing.' + #13#10 +
                                                       'Version 1.0.0.3 : Better menu.' + #13#10 +
                                                       'Version 1.0.0.2 : Better Ini.' + #13#10 +
                                                       'Version 1.0.0.1 : No ExtToolbar on LAZARUS.' + #13#10 +
                                                       'Version 1.0.0.0 : Création de l''unité à partir de fonctions_objets_dynamiques.';
              			           UnitType : 1 ;
              			           Major : 1 ; Minor : 0 ; Release : 2 ; Build : 0 );

{$ENDIF}
type

      TStringArray             = Array Of String;
      TLeonField                  = Record
                                        FieldName : String ;
                                        Name      : String ;
                                   end;
      TLeonFields = Array of TLeonField;
var
      gs_SommaireEnCours      : string       ;   // Sommaire en cours MAJ régulièrement
      gF_FormParent           : {$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}        ;   // Form parent initialisée au create
      gBmp_DefaultPicture     : TBitmap        = nil;   // Bmp apparaissant si il n'y a pas d'image
      gBmp_DefaultAcces       : TBitmap        = nil;   // Bmp apparaissant si il n'y a pas d'image
      gWin_ParentContainer    : TScrollingWinControl  ;   // Volet d'accès
      gIco_DefaultPicture     : TIcon        ;   // Ico apparaissant si il n'y a pas d'image
      gi_TailleUnPanel        ,                  // Taille d'un panel de dxbutton
      gi_FinCompteurImages    : Integer      ;   // Un seul imagelist des menus donc efface après la dernière image
      gBar_ToolBarParent      : {$IFDEF FPC}TCustomControl{$ELSE}TToolWindow{$ENDIF}  = nil;   // Barre d'accès
      gSep_ToolBarSepareDebut : TControl= nil;   // Séparateur de début délimitant les boutons à effacer
      gPan_PanelSepareFin     : TPanel       = nil;   // Panel      de fin   délimitant les boutons à effacer
      gb_UtiliseSMenu         : Boolean      ;            // Utilise-t-on les sous-menus
      gMen_MenuLangue         : TMenuItem    = nil;
      gMen_MenuVolet          : TMenuItem    = nil;
      gMen_MenuIdent          : TMenuItem    = nil;
      gMen_MenuParent         : TMenuItem    = nil;
      gxb_Ident               : TJvXPButton  = nil;
      gIma_ImagesXPBars       : TImageList   = nil;
      gIma_ImagesMenus        : TImageList   = nil;
      gf_Users                : TCustomForm=nil;
      ResInstance             : THandle      ;
      gchar_DecimalSeparator  : Char ;


procedure p_setPrefixToMenuAndXPButton ( const as_Prefix : String;
                                        const axb_Button : TJvXPButton ;
                                        const amen_Menu : TMenuItem ;
                                        const aiml_Images : TImageList );
function fb_createFieldID (const ab_IsSourceTable : Boolean; const anod_Field: TALXMLNode ; const affd_ColumnFieldDef : TFWFieldColumn; const ai_Fieldcounter : Integer ):Boolean;
function fb_CreeAppliFromNode ( const as_EntityFile : String ):boolean;
function fb_getImageToBitmap ( const as_Prefix : String; const abmp_Bitmap : TBitmap ):Boolean;
procedure p_onProjectNode ( const as_FileName : String ; const ANode : TALXMLNode );
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
procedure p_setControl  ( const as_BeginName : String ;
                          const awin_Control : TWinControl ;
                          const awin_Parent : TWinControl ;
                          const anod_Field : TALXMLNode ;
                          const ai_FieldCounter, ai_counter : Longint );
procedure p_NavigationTree ( const as_EntityFile : String );
function fi_FindActionFile ( const afile : String ):Longint ;
procedure p_FindAndSetSourceKey ( const as_Class : String ; const afws_Source : TFWTable ; const acom_owner : TComponent; const ach_FieldDelimiter : Char );
function fi_FindAction ( const aClep : String ):Longint ;
function fb_ReadIni ( var amif_Init : TIniFile ) : Boolean;
procedure p_CopyLeonFunction ( const ar_Source : TLeonFunction ; var ar_Destination : TLeonFunction );
function  fb_setChoiceProperties ( const anod_FieldProperty : TALXMLNode ; const argr_Control : TCustomRadioGroup ): Boolean;
procedure p_initialisationSommaire ( const as_SommaireEnCours      : String       );
procedure p_initialisationBoutons ( const aF_FormParent           : {$IFDEF TNT}TTntForm{$ELSE}TForm{$ENDIF}        ;
                                    const aMen_MenuLanguage       : TMenuItem       ;
                        	    const aWin_PanelVolet         : TScrollingWinControl  ;
//                                    const aWin_BarreVolet         : TWinControl  ;
                                    const aMen_MenuVolet          : TMenuItem    ;
                                    const aIco_DefaultPicture     : TIcon        ;
                                    const aBar_ToolBarParent      : {$IFDEF FPC}TCustomControl{$ELSE}TToolWindow{$ENDIF} ;
                                    const aSep_ToolBarSepareDebut : TControl;
                                    const aPan_PanelSepareFin     : TPanel       ;
                                    const ai_TailleUnPanel        : Integer      ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const aMen_MenuParent         : TMenuItem    ;
                                    const aIma_ImagesMenus        : TImageList   ;
                                    const aPic_DefaultAcces       ,
                                          aPic_DefaultAide        ,
                                          aPic_DefaultQuit        : TPicture     ;
                                    const aMen_MenuIdent          : TMenuItem    ;
                                    const axb_ident               : TJvXPButton  ;
                                    const aMen_MenuAide           : TMenuItem    ;
                                    const axb_Aide                : TJvXPButton  ;
                                    const aMen_MenuQuitter        : TMenuItem    ;
                                    const axb_Quitter             : TJvXPButton  );


procedure  p_DetruitLeSommaire ;

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

function fb_CreateXPButtonsFromProject ( const as_SommaireEnCours      ,
              			    as_LeMenu               : String      ;
                        		const aF_FormParent           ,
                       			    af_FormEnfant           : TCustomForm       ;
                        		const aCon_ParentContainer    : TScrollingWinControl ;
                        		const aMen_MenuVolet          : TMenuItem   ;
                        		const aBmp_DefaultPicture     : TBitmap     ;
                        		const ab_AjouteEvenement      : Boolean     ;
                        		const aIma_ImagesXPBars       : TImageList  ): Boolean;

function fb_CreateXPButtonsFromDashBoard ( const as_SommaireEnCours      ,
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
function fb_CreateMenuFromDashBoard : Boolean ;
function fb_CreateMenuFromProject ( ): Boolean ;

procedure p_getNomImageToBitmap ( const as_Nom : String; const abmp_Bitmap : TBitmap ) ;
procedure p_RegisterSomeLanguages;

implementation

uses SysUtils, Dialogs, fonctions_xml,
{$IFDEF FPC}
     FileUtil,
{$ENDIF}
     fonctions_images , fonctions_init, U_XMLFenetrePrincipale,
     fonctions_proprietes,
     Variants, fonctions_Objets_Dynamiques, fonctions_dbcomponents, strutils,
     unite_variables, u_languagevars, Imaging, fonctions_languages;


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

procedure p_FindAndSetSourceKey ( const as_Class : String ; const afws_Source : TFWTable ; const acom_owner : TComponent ; const ach_FieldDelimiter : Char );
var  li_k, li_l, li_m, li_n : Longint;
    lnod_NodeClass, lnod_Field, lnod_FieldsTemp,
    lnod_FieldProperty, lnod_mark      : TALXMLNode ;
    lfd_Fielddef : TFWFieldColumn;
    lxdoc_Document : TALXMLDocument;
    lb_isrelation : Boolean;
Begin
  lxdoc_Document := nil;
  lnod_FieldsTemp := nil;
  If fb_OpenClass ( as_class, acom_owner, lxdoc_Document ) Then
    try
   // reading the special XML form File
      for li_k := 0 to lxdoc_Document.ChildNodes.Count -1 do
        Begin
          lnod_NodeClass := lxdoc_Document.ChildNodes [ li_k ];
          if ( lnod_NodeClass.NodeName = CST_LEON_CLASS  )
          or ( lnod_NodeClass.NodeName = CST_LEON_STRUCT ) then
              for li_l := 0 to lnod_NodeClass.ChildNodes.Count -1 do
                Begin
                  lnod_Field := lnod_NodeClass.ChildNodes [ li_l ];
                  if lnod_Field.NodeName = CST_LEON_FIELDS Then
                   for li_m := 0 to lnod_Field.ChildNodes.Count -1 do
                     Begin
                       lnod_FieldProperty := lnod_Field.ChildNodes [ li_m ];
                       if fb_getNodesField(lnod_FieldProperty) Then
                         lnod_FieldsTemp:=lnod_FieldProperty;
                       with lnod_FieldProperty do
                       if HasChildNodes Then
                        for li_n := 0 to lnod_FieldProperty.ChildNodes.Count -1 do
                          if ( ChildNodes [ li_n ].NodeName = CST_LEON_FIELD_F_MARKS  ) then
                           Begin
                             lfd_Fielddef:=afws_Source.FieldsDefs.Add;
                             fb_setNodeField(lnod_Field,lfd_Fielddef);
                             if assigned(lnod_FieldsTemp)Then
                              p_setNodesField(lnod_FieldsTemp,lfd_Fielddef);
                             lb_isrelation :=False;
                             fb_setFieldType(afws_Source,lfd_Fielddef,lnod_FieldProperty,li_m,True,False,acom_owner,lb_isrelation);
                             p_setNodeId ( ChildNodes [ li_n ], afws_Source, lfd_Fielddef );
                           end;
                     end;
                end;
        end;
    finally
      lxdoc_Document.Destroy;
    end;
End;


procedure p_RegisterSomeLanguages;
var ls_Dir, ls_lang, ls_Language : String ;
    lsr_Files : TSearchRec;
    lb_IsFound : Boolean ;
    lini_Inifile : TStringList;
    li_pos : Cardinal;
 Begin
  ls_Dir := fs_getLeonDir +CST_DIR_LANGUAGE;
  lini_Inifile := nil;
  if FileExistsUTF8( fs_getLeonDir +CST_DIR_LANGUAGE_LAZARUS + CST_FILE_LANGUAGES + GS_EXT_LANGUAGES) Then
  try
    lini_Inifile := TStringList.Create( );
    lini_Inifile.LoadFromFile(fs_getLeonDir +CST_DIR_LANGUAGE_LAZARUS + CST_FILE_LANGUAGES + GS_EXT_LANGUAGES);
  Except
  End ;
  try
    lb_IsFound := FindFirst(ls_Dir+CST_SUBFILE_LANGUAGE+gs_NomApp+'_*'+GS_EXT_LANGUAGES, faAnyFile-faDirectory, lsr_Files) = 0;
    while lb_IsFound do
     begin
        if FileExistsUTF8 ( ls_Dir + lsr_Files.Name )
         Then
          Begin
            li_pos := Length(CST_SUBFILE_LANGUAGE+gs_NomApp+'_');
            ls_lang:=Copy(lsr_Files.Name,li_pos+1, posex ( '.', lsr_Files.Name, li_pos) - li_pos - 1);
            ls_Language:= fs_GetStringValue ( lini_Inifile, ls_lang );
            p_RegisterALanguage ( ls_lang, ls_Language);
          end;
        lb_IsFound := FindNext(lsr_Files) = 0;
      end;
    FindClose(lsr_Files);
  Except
    FindClose(lsr_Files);
  End ;
  lini_Inifile.Free;
end;



/////////////////////////////////////////////////////////////////////////
// function fi_FindAction
// Find a function with a key
// aClep : Key of function
/////////////////////////////////////////////////////////////////////////
function fi_FindActionFile ( const afile : String ):Longint ;
var li_i : Longint ;
Begin
  Result := -1 ;
  for li_i := 0 to high ( ga_Functions ) do
    if ga_Functions [ li_i ].AFile = afile then
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
    lb_IsFound : Boolean;
Begin
  if as_Nom = '' Then
    Exit;
  ls_ImagesDir := fs_getImagesDir;
  try
    lb_IsFound := FindFirst(ls_ImagesDir + as_Nom + '.*', faAnyFile, SR) = 0 ;
  Except
    lb_IsFound := False;
  End ;
  while lb_IsFound do
   begin
    if  FileExistsUTF8 ( ls_ImagesDir + SR.Name )
    and ( DetermineFileFormat ( ls_ImagesDir + SR.Name ) <> '' )
     then
      Begin
        p_FileToBitmap (ls_ImagesDir + SR.Name, abmp_Bitmap, True );
      End ;
    try
      lb_IsFound := FindNext(SR) = 0;
    Except
      lb_IsFound := False;
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
function fb_getImageToBitmap ( const as_Prefix : String; const abmp_Bitmap : TBitmap ):Boolean;
Begin
  {$IFDEF DELPHI}
  abmp_Bitmap.Dormant ;
  {$ENDIF}
  abmp_Bitmap.FreeImage ;
  abmp_Bitmap.Handle := 0 ;
  p_getNomImageToBitmap ( as_Prefix, abmp_Bitmap );
  p_RecuperePetitBitmap ( abmp_Bitmap );
  Result := abmp_Bitmap.Handle <> 0;
end;

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
                                    const aBar_ToolBarParent      : {$IFDEF FPC}TCustomControl{$ELSE}TToolWindow{$ENDIF}   ;
                                    const aSep_ToolBarSepareDebut : TControl;
                                    const aPan_PanelSepareFin     : TPanel       ;
                                    const ai_TailleUnPanel        : Integer      ;
                                    const aBmp_DefaultPicture     : TBitmap      ;
                                    const aMen_MenuParent         : TMenuItem    ;
                                    const aIma_ImagesMenus        : TImageList   ;
                                    const aPic_DefaultAcces       ,
                                          aPic_DefaultAide        ,
                                          aPic_DefaultQuit        : TPicture     ;
                                    const aMen_MenuIdent          : TMenuItem    ;
                                    const axb_ident               : TJvXPButton  ;
                                    const aMen_MenuAide           : TMenuItem    ;
                                    const axb_Aide                : TJvXPButton  ;
                                    const aMen_MenuQuitter        : TMenuItem    ;
                                    const axb_Quitter             : TJvXPButton  );

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
  gMen_MenuIdent          := aMen_MenuIdent          ;
  gMen_MenuLangue         := aMen_MenuLanguage       ;
  gxb_Ident               := axb_ident               ;
  gIma_ImagesMenus        := aIma_ImagesMenus        ;
  gIma_ImagesXPBars       := TImageList.Create ( aF_FormParent );
  gBmp_DefaultAcces       := TBitmap.Create;
  p_setImageToMenuAndXPButton ( aPic_DefaultAide.Bitmap, axb_Aide   , aMen_MenuAide   , aIma_ImagesMenus );
  p_setImageToMenuAndXPButton ( aPic_DefaultQuit.Bitmap, axb_Quitter, aMen_MenuQuitter, aIma_ImagesMenus );
  gi_FinCompteurImages    := aIma_ImagesMenus.Count - 1    ;
  gBmp_DefaultAcces.Assign(aPic_DefaultAcces.Bitmap);
End ;
/////////////////////////////////////////////////////////////////////////
// function fb_CreateXPButtonsFromDashBoard
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

function fb_CreateXPButtonsFromDashBoard ( const as_SommaireEnCours      ,
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
    li_Action           : Integer;
    li_Compteur         ,
    li_CompteurFonctions: Integer ; // Compteur fonctions
    lr_Function         ,
    lr_FunctionOld      : TLeonFunction;
    ls_MenuClep         ,
    ls_MenuClep2        : String;
    ls_MenuLabel        : WideString ;// Sous Menu en cours
//    lbmp_BitmapOrigine  : TBitmap ;  // bitmap en cours
    lNode, lNodeChild   : TALXMLNode ;
    lbmp_FonctionImage  : TBitmap ;  // Icône de la Fonction en cours
    li_TopXPBar         : Integer ;
    aIma_ImagesTempo    : TImageList ;
    procedure p_SetOneFunctiontoBar;
    Begin
        // Si une fonction dans le dernier enregistrement affectation dans l'ancienne xpbar
       if ( ls_MenuClep2 <> '' )
       and ( lr_FunctionOld.Groupe <> lr_Function.Groupe )
       and ( li_CompteurFonctions = 1 )
        Then
         Begin
           ls_MenuLabel := fs_GetLabelCaption ( lr_FunctionOld.Name );
           fb_getImageToBitmap ( lr_FunctionOld.Prefix,  lbmp_FonctionImage );
           p_ModifieXPBar( aF_FormParent       ,
                           ldx_WinXpBar        ,
                           ls_MenuClep2        ,
                           ls_MenuLabel        ,
                           lr_FunctionOld.Value,
                           ''                  ,
                           lr_FunctionOld.Name ,
                           aIma_ImagesTempo    ,
                           lbmp_FonctionImage  ,
                           aBmp_DefaultPicture ,
                           ab_AjouteEvenement  );
         end;

    end;

    procedure p_MenuGrouping;
    Begin

      // SI les sous-menus ou menus sont différents ou pas de sous menu alors création d''une xpbar
      // SI les sous-menus ou menus sont différents ou pas de sous menu alors création d''une xpbar
      if  ( lr_Function    .Groupe <> '' )
       Then
        Begin
          if ( lr_Function.Groupe <> lr_Functionold.Groupe )
{                     or (     lb_UtiliseSMenu
                       and (    ( gT_TableauMenus [ li_CompteurMenus ].SousMenu <> ls_SMenu )
                             or ( gT_TableauMenus [ li_CompteurMenus ].SousMenu = ''        )))))}
            Then
             Begin
               // création d''une xpbar
               if assigned ( ldx_WinXpBar )
                Then
                 Begin
                   ldx_WinXpBar.Refresh ;
                   li_TopXPBar := ldx_WinXpBar.Top + ldx_WinXpBar.Height + 1 ;
                 End ;
               ldx_WinXpBar := TJvXpBar.Create ( af_FormEnfant );//aF_FormParent );

               // Affectation des valeurs
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
//                           p_setComponentName ( ldx_WinXpBar, lr_Function.Groupe );
               // Parent


               ldx_WinXpBar.Parent := aCon_ParentContainer ;
               fb_getImageToBitmap ( lr_Function.Prefix, lbmp_FonctionImage );
                     // affectation du libellé du menu
                // Gestion sans base de données
               p_ModifieXPBar  ( aF_FormParent       ,
                                     ldx_WinXpBar        ,
                                     lr_Function.Groupe        ,
                                     fs_GetLabelCaption ( lr_Function.Groupe )        ,
                                     ''                  ,
                                     ''                  ,
                                     lr_Function.Groupe        ,
                                     aIma_ImagesTempo    ,
                                     lbmp_FonctionImage    ,
                                     abmp_DefaultPicture ,
//                                       li_Compteur         ,
                                     False  );

                // On remet le compteur des fonctions à 0
               li_CompteurFonctions := 0 ;

             End
            else
            // Si une fonction dans l'enregistrement précédent affectation dans l'ancienne xpbar
             if ( li_CompteurFonctions = 1 )
              Then
                Begin
                  fb_getImageToBitmap ( lr_Function.Prefix,  lbmp_FonctionImage );
                // fonction dans la file d'attente
                  fdxi_AddItemXPBar ( aF_FormParent       ,
                                      ldx_WinXpBar        ,
                                      ls_MenuClep         ,
                                      ls_MenuLabel        ,
                                      lr_Function.Value        ,
                                      ''                  ,
                                      lr_Function.Name         ,
                                      aIma_ImagesXPBars   ,
                                      lbmp_FonctionImage  ,
                                      aBmp_DefaultPicture ,
                                      li_Compteur - 1     );

                end;
        End;
    end;

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
  lr_Functionold.Groupe  := '' ;
  lr_Function   .Groupe  := '' ;
  ls_MenuClep            := '' ;
  li_CompteurFonctions := 0 ;
  li_Compteur          := 0 ;
  li_TopXPBar          := 1 ;
//  lico_IconMenu        := nil ;
  lbmp_FonctionImage   := TBitmap.Create ; // A libérer à la fin
  lbmp_FonctionImage.Handle := 0 ;
  aIma_ImagesTempo     := TImageList.Create ( af_FormParent );
  aIma_ImagesTempo     .Width  := 32 ;
  aIma_ImagesTempo     .Height := 32 ;
  ls_MenuClep2 := '';

  // Premier enregistrement
  // Création des XPBars
  // Rien alors pas de menu

  for li_i := 0 to gNod_DashBoard.ChildNodes.Count - 1 do
    Begin
      lNode := gNod_DashBoard.ChildNodes [ li_i ];
      if ( lNode.NodeName = CST_LEON_ACTIONS ) then
        for li_j := 0 to lNode.ChildNodes.Count - 1 do
          Begin
             lNodeChild := lNode.ChildNodes [ li_j ];
      //      MyShowMessage (  axdo_FichierXML.ChildNodes[li_i].LocalName + ' local '+ axdo_FichierXML.ChildNodes[li_i].NodeName + ' local '+ axdo_FichierXML.ChildNodes[li_i].Prefix + ' local '+ axdo_FichierXML.ChildNodes[li_i].Text + ' local '+ axdo_FichierXML.ChildNodes[li_i].XML );
            // Les sous-menus et menus doivent avoir des noms
            if  (  not ( lNodeChild.HasAttribute ( CST_LEON_ID )) // Ou alors pas de sous menu on crée la fonction
               and not ( lNodeChild.HasAttribute ( CST_LEON_ACTION_IDREF ))) // Ou alors pas de sous menu on crée la fonction
            or  (     ( lNodeChild.NodeName <> CST_LEON_ACTION )
                 and  ( lNodeChild.NodeName <> CST_LEON_ACTION_REF )
                 and  ( lNodeChild.NodeName <> CST_LEON_COMPOUND_ACTION ))
              Then
               Begin
               // Enregistrement sans donnée valide on va au suivant
                 Continue ;
               End ;
            p_MenuGrouping;
            Result := True ;
            ls_MenuClep2 := ls_MenuClep;
            lr_FunctionOld := lr_Function;
            if lNodeChild.HasAttribute(CST_LEON_ACTION_IDREF) then
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ACTION_IDREF ]
             Else
              ls_MenuClep := lNodeChild.Attributes [ CST_LEON_ID ];
            lr_Function.Name   := '' ;
            lr_Function.Groupe  := '' ;
            lr_Function.Value  := '' ;
            // SI le menu existe et si il est différent création d'un menu
              if  ( ls_MenuClep   <> '' )
               Then
                Begin
                  inc ( li_CompteurFonctions );
                  li_Action := fi_FindAction ( ls_MenuClep );
                  if li_Action = -1 then
                    Continue;
                  lr_Function.Prefix := ga_Functions [ li_Action ].Prefix ;
                  lr_Function.Name   := ga_Functions [ li_Action ].Name   ;
                  lr_Function.Value  := ga_Functions [ li_Action ].Value  ;
                  lr_Function.Groupe  := ga_Functions [ li_Action ].Groupe ;
                  if ( lr_Function.Name = '' ) then
                     Continue;
                 ls_MenuLabel  := fs_GetLabelCaption ( lr_Function.Name );
                  Result := True ;

                  // A chaque fonction création d'une action dans la bar XP
                  if    assigned ( ldx_WinXpBar )
                  and (    ( ls_Menuclep <> '' ))
      //            or  (       not assigned ( axdo_FichierXML )
      //                  and ( gT_TableauMenus [ li_CompteurMenus ].Fonction <> '' ))
                   Then
                    Begin
                      inc ( li_Compteur          );
                      if ( li_CompteurFonctions > 1 ) // Ajoute si plus d'une fonction
                       Then
                        Begin
                          // fonction dans la file d'attente
                          fb_getImageToBitmap ( lr_Function.Prefix,  lbmp_FonctionImage );
                          fdxi_AddItemXPBar  ( aF_FormParent       ,
                                              ldx_WinXpBar        ,
                                              ls_MenuClep         ,
                                              ls_MenuLabel        ,
                                              lr_Function.Value        ,
                                              ''                  ,
                                              lr_Function.Name         ,
                                              aIma_ImagesXPBars   ,
                                              lbmp_FonctionImage  ,
                                              aBmp_DefaultPicture ,
                                              li_Compteur - 1     );
                        End ;
                    End ;
                    // Au suivant !
              End ;
             p_SetOneFunctiontoBar;
            End ;
          End;
   p_SetOneFunctiontoBar;
   if assigned ( aMen_MenuVolet )
    Then
     if Result
     Then
      Begin
        aMen_MenuVolet.Enabled := True ;
        if gb_FirstAcces Then
          aMen_MenuVolet.Checked := True;
      End
     Else
      Begin
        if aMen_MenuVolet.Checked Then
          aMen_MenuVolet.Checked := False;
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

function fb_CreateXPButtonsFromProject ( const as_SommaireEnCours      ,
              			    as_LeMenu               : String      ;
                        		const aF_FormParent           ,
                       			    af_FormEnfant           : TCustomForm       ;
                        		const aCon_ParentContainer    : TScrollingWinControl ;
                        		const aMen_MenuVolet          : TMenuItem   ;
                        		const aBmp_DefaultPicture     : TBitmap     ;
                        		const ab_AjouteEvenement      : Boolean     ;
                        		const aIma_ImagesXPBars       : TImageList  ): Boolean;
var ldx_WinXpBar        : TJvXpBar ;  // Nouvelle barre xp
    li_i,
    li_Action           : Integer;
    lr_FunctionOld      : TLeonFunction;
    ls_MenuClep         ,
    ls_MenuClep2        : String;
    ls_MenuLabel        : WideString ;// Sous Menu en cours
//    lbmp_BitmapOrigine  : TBitmap ;  // bitmap en cours
    lbmp_FonctionImage  : TBitmap ;  // Icône de la Fonction en cours
    li_TopXPBar         : Integer ;
    aIma_ImagesTempo    : TImageList ;
    procedure p_SetOneFunctiontoBar ( const AFunction : TLeonFunction );
    Begin
        // Si une fonction dans le dernier enregistrement affectation dans l'ancienne xpbar
       if ( ls_MenuClep2 <> '' )
       and ( lr_FunctionOld.Groupe <> AFunction.Groupe )
       and ( li_Action = 0 )
        Then
         Begin
           ls_MenuLabel := fs_GetLabelCaption ( lr_FunctionOld.Name );
           fb_getImageToBitmap ( lr_FunctionOld.Prefix,  lbmp_FonctionImage );
           p_ModifieXPBar( aF_FormParent       ,
                           ldx_WinXpBar        ,
                           ls_MenuClep2        ,
                           ls_MenuLabel        ,
                           lr_FunctionOld.Value,
                           ''                  ,
                           lr_FunctionOld.Name ,
                           aIma_ImagesTempo    ,
                           lbmp_FonctionImage  ,
                           aBmp_DefaultPicture ,
                           ab_AjouteEvenement  );
         end;

    end;
  var lxdoc_Project : TALXMLDocument;
      lst_Classes : TStringList;
Begin
// un noeud et la main form doivent exister
  Result := False ;
  if not assigned ( aF_FormParent                   )
  or not assigned ( aCon_ParentContainer            )
  or (gNod_Classes = nil)
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
  lr_Functionold.Groupe  := '' ;
  ls_MenuClep            := '' ;
  li_TopXPBar          := 1 ;
//  lico_IconMenu        := nil ;
  lbmp_FonctionImage   := TBitmap.Create ; // A libérer à la fin
  lbmp_FonctionImage.Handle := 0 ;
  aIma_ImagesTempo     := TImageList.Create ( af_FormParent );
  aIma_ImagesTempo     .Width  := 32 ;
  aIma_ImagesTempo     .Height := 32 ;
  ls_MenuClep2 := '';
  li_Action:=-1;

  // Premier enregistrement
  // Création des XPBars
  // Rien alors pas de menu
  lxdoc_Project:=nil;
  lst_Classes := TStringList.Create;
  try
    lst_Classes.Text:=gNod_Classes.Attributes[CST_LEON_DUMMY];
    for li_i := 0 to lst_Classes.Count -1 do
      Begin
        ls_MenuClep:=trim(lst_Classes [ li_i ]);
        if pos( '&', ls_MenuClep ) = 1 Then
         Begin
          inc(li_Action);
          ls_MenuClep:=copy(ls_MenuClep,2,Length(ls_MenuClep)-1);
          ls_MenuLabel  := fs_GetLabelCaption ( ls_MenuClep );
          Result := True ;
          SetLength(ga_Functions,high(ga_Functions)+2);
          // A chaque fonction création d'une action dans la bar XP
          with ga_Functions [li_Action] do
           Begin
            Clep:=ls_MenuClep;
            Name:=ls_MenuClep;
            if    assigned ( ldx_WinXpBar )
            and (    ( ls_Menuclep <> '' ))
      //            or  (       not assigned ( axdo_FichierXML )
      //                  and ( gT_TableauMenus [ li_CompteurMenus ].Fonction <> '' ))
             Then
              Begin
                if ( li_Action > 0 ) // Ajoute si plus d'une fonction
                 Then
                  Begin
                    // fonction dans la file d'attente
                    fb_getImageToBitmap ( Prefix,  lbmp_FonctionImage );
                    fdxi_AddItemXPBar  ( aF_FormParent       ,
                                        ldx_WinXpBar        ,
                                        ls_MenuClep         ,
                                        ls_MenuLabel        ,
                                        Value        ,
                                        ''                  ,
                                        Name         ,
                                        aIma_ImagesXPBars   ,
                                        lbmp_FonctionImage  ,
                                        aBmp_DefaultPicture ,
                                        li_Action     );
                  End ;
              End ;
           end;
         end;
      End ;
     if high(ga_Functions)>0 Then
       p_SetOneFunctiontoBar(ga_Functions[High(ga_Functions)]);
     if assigned ( aMen_MenuVolet )
      Then
       if Result
       Then
        Begin
          aMen_MenuVolet.Enabled := True ;
          if gb_FirstAcces Then
            aMen_MenuVolet.Checked := True;
        End
       Else
        Begin
          if aMen_MenuVolet.Checked Then
            aMen_MenuVolet.Checked := False;
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

  finally
    lst_Classes.Destroy;
  end;
End ;

/////////////////////////////////////////////////////////////////////////
// function fb_CreateMenuFromDashBoard
// creating the menus from global variables
// Result to false = error
/////////////////////////////////////////////////////////////////////////
function fb_CreateMenuFromDashBoard ( ): Boolean ;
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
      Result := fb_CreateXPButtonsFromDashBoard ( '', '', gF_FormParent, gF_FormParent, gWin_ParentContainer, gMen_Menuvolet, gBmp_DefaultPicture  , True, gIma_ImagesXPBars   ) and Result;
    end;
End ;

/////////////////////////////////////////////////////////////////////////
// function fb_CreeLeMenu
// creating the menus from global variables
// Result to false = error
/////////////////////////////////////////////////////////////////////////
function fb_CreateMenuFromProject ( ): Boolean ;
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
      Result := fb_CreateXPButtonsFromProject ( '', '', gF_FormParent, gF_FormParent, gWin_ParentContainer, gMen_Menuvolet, gBmp_DefaultPicture  , True, gIma_ImagesXPBars   ) and Result;
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
    li_i, li_j    ,
    li_Action           ,
    li_CompteurMenu     : LongInt ;  // Compteur barres xp
//    li_CompteurFonctions: Integer ; // Compteur fonctions
    lr_Function         : TLeonFunction;
    ls_Menu             , // Menu en cours
    ls_MenuAction       ,
    ls_MenuClep         : string ;
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
      //      MyShowMessage (  axdo_FichierXML.ChildNodes[li_i].LocalName + ' local '+ axdo_FichierXML.ChildNodes[li_i].NodeName + ' local '+ axdo_FichierXML.ChildNodes[li_i].Prefix + ' local '+ axdo_FichierXML.ChildNodes[li_i].Text + ' local '+ axdo_FichierXML.ChildNodes[li_i].XML );
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
            // SI le menu existe et si il est différent création d'un menu
              if  ( ls_MenuClep   <> '' )
               Then
                Begin
                li_Action := fi_FindAction ( ls_MenuClep );
                if li_Action = -1 then
                  Continue;
                ls_MenuAction := ga_Functions [ li_Action ].Groupe ;
                lr_Function.Prefix := ga_Functions [ li_Action ].Prefix ;
                lr_Function.Name   := ga_Functions [ li_Action ].Name   ;
                lr_Function.Value  := ga_Functions [ li_Action ].Value  ;
                lr_Function.Groupe  := ga_Functions [ li_Action ].Groupe ;
                 if ( lr_Function.Name = '' ) then
                   Continue;
                 ls_MenuLabel  := fs_GetLabelCaption ( lr_Function.Name );
                 if (   lr_Function.Groupe <> ls_Menu  )
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
                     p_setComponentName ( lMen_MenuEnCours, lr_Function.Name );
                     aMen_MenuParent.Add ( lMen_MenuEnCours );
                       // Menu Parent
//                     lMen_Menu        := lMen_MenuEnCours ;
                     ls_Menu  := lr_Function.Groupe ;
                     // affectation du libellé du menu
                     lMen_MenuEnCours.Caption := fs_getLabelCaption ( ls_MenuAction );
                     lMen_MenuEnCours.Hint    := lMen_MenuEnCours.Caption;
                   End ;
      // Si il n'y a pas de menu
            if (  ls_MenuClep    = '' )
             then
              Begin

                  // Le Menu où on ajoute les fonctions devient le menu Ouvrir
                lMen_MenuEnCours := aMen_MenuParent ;
              End;
            // A chaque fonction création d'une action dans la bar XP
            if    assigned ( lMen_MenuEnCours )
            and ( ls_MenuClep <> '' )
             Then
              Begin
      //          inc ( li_CompteurFonctions );
                inc ( li_CompteurMenu );
                 lb_AjouteBitmap := fb_getImageToBitmap ( lr_Function.Prefix, lbmp_BitmapOrigine );
                 // Affectation des valeurs de la queue
                      // Chargement de la fonction à partir de la table des fonctions
//                   lb_AjouteBitmap := fb_AssignDBImage ( axdo_FichierXML.FieldByName ( CST_FONC_Bmp ), lbmp_BitmapOrigine, aBmp_DefaultPicture );
                    // Ajoute une fonction dans un menu
                    lMen_MenuEnfant := fmen_AjouteFonctionMenu  ( aF_FormParent        ,
                                            lMen_MenuEnCours     ,
                                            ls_MenuClep ,
                                            ls_MenuLabel, //axdo_FichierXML.FieldByName (  CST_FONC_Libelle ).AsString ,
                                            lr_Function.Value, //axdo_FichierXML.FieldByName (  CST_FONC_Type    ).AsString ,
                                            '', //axdo_FichierXML.FieldByName (  CST_FONC_Mode    ).AsString ,
                                            lr_Function.Name, //axdo_FichierXML.FieldByName (  CST_FONC_Nom     ).AsString ,
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
//      MyShowMessage ( 'Le champ ' + CST_SOMM_Niveau + ' est Null !' );
      Exit ;
    End ;

  // Utilise-t-on les sous menus ?
  lb_UtiliseSousMenu := axdo_FichierXML.Fields [ 0 ].AsBoolean ;
// Requête sommaire
  axdo_FichierXML.Close ;
//  MyShowMessage ( axdo_FichierXML.SQL.Text );
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
        fb_CreateXPButtonsFromDashBoard ( as_SommaireEnCours, '', aF_FormParent, aF_FormParent, gWin_ParentContainer, gMen_Menuvolet, aBmp_DefaultPicture  , True, gIma_ImagesXPBars   );
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
    gMen_MenuVolet .Checked := False;
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
     Mode := Byte(fsMDIChild);
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
End;

procedure p_onProjectNode ( const as_FileName : String ; const ANode : TALXMLNode );
Begin
  if  ( pos ( CST_LEON_SYSTEM_ROOT, aNode.NodeName ) > 0 )
   then
     Begin
       if not assigned ( gxdo_MenuXML ) Then
         gxdo_RootXML := TALXMLDocument.Create(Application);
       if fb_LoadXMLFile ( gxdo_RootXML, as_FileName ) then
         p_LoadEntitites ( gxdo_RootXML );
     End;
  if  ( pos ( CST_LEON_SYSTEM_NAVIGATION, aNode.NodeName ) > 0 )
   then
     Begin
       p_NavigationTree ( as_FileName );
     End;
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_CreeAppliFromNode
// creating root login if no dashboard
// as_EntityFile : xml file login
// Result : Exécution de la derinère fonction
/////////////////////////////////////////////////////////////////////////
function fb_CreeAppliFromNode ( const as_EntityFile : String ):Boolean;
Begin
 if assigned ( gNod_DashBoard )
  then fb_CreateMenuFromDashBoard
  Else fb_CreateMenuFromProject;

 F_FenetrePrincipale.p_AccessToSoft;
End;

procedure p_setControl  ( const as_BeginName : String ;
                          const awin_Control : TWinControl ;
                          const awin_Parent : TWinControl ;
                          const anod_Field : TALXMLNode ;
                          const ai_FieldCounter, ai_counter : Longint );
begin
  awin_Control.Parent := awin_Parent ;
  awin_Control.Name := as_BeginName + anod_Field.NodeName + IntToStr(ai_counter) + anod_Field.Attributes[CST_LEON_ID] + IntToStr(ai_FieldCounter);
  awin_Control.Tag := ai_FieldCounter + 1;
End;

/////////////////////////////////////////////////////////////////////////
// function fb_NavigationTree
// Loading navigation and login
// as_EntityFile : navigation tree file
/////////////////////////////////////////////////////////////////////////
procedure p_NavigationTree ( const as_EntityFile : String );
var
    li_i, li_j : Longint;
    lnod_Node : TALXMLNode ;
Begin
 if not assigned ( gxdo_MenuXML ) Then
   gxdo_MenuXML := TALXMLDocument.Create(Application);
 if fb_LoadXMLFile ( gxdo_MenuXML, as_EntityFile ) then
   Begin
     for li_i := 0 to gxdo_MenuXML.ChildNodes.Count -1  do
       Begin
         lnod_Node := gxdo_MenuXML.ChildNodes [li_i];
         if  ( lnod_Node.NodeName = CST_LEON_ACTION )
         and ( lnod_Node.Attributes[CST_LEON_ID] = gs_RootAction )
          Then
           Begin
             gNod_RootAction:=lnod_Node;
             if  lnod_Node.HasChildNodes Then
             for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
               if ( lnod_Node.ChildNodes [ li_j ].NodeName = CST_LEON_ACTIONS ) Then
                 p_LoadRootAction(lnod_Node.ChildNodes [ li_j ]);
           end;
       end;
   end;
End;

/////////////////////////////////////////////////////////////////////////
// function fb_ReadIni
// reading ini, creating and building project
// Lecture du fichier INI
// Résultat : il y a un fichier projet.
// amif_Init : ini file
/////////////////////////////////////////////////////////////////////////
function fb_ReadIni ( var amif_Init : TIniFile ) : Boolean;
Begin
  if fb_CreateProject ( amif_Init, Application )
  and fb_LoadXMLFile ( gxdo_FichierXML, fs_getLeonDir + gs_ProjectFile ) Then
    Begin
      Result := True;
      // La fenêtre n'est peut-être pas encore complètement créée
      fb_CreateMenuFromDashBoard;
      gchar_DecimalSeparator := ',' ;
      DecimalSeparator := gchar_DecimalSeparator ;
      fs_BuildFromXML ( 0, gxdo_FichierXML.Node, Application ) ;
      fs_BuildTreeFromXML ( 0, gxdo_FichierXML.Node, TOnExecuteProjectNode ( p_onProjectNode) ) ;

    End
   Else
    Result := False;
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


// procedure p_setImageToMenuAndXPButton
// Set the xpbutton and menu from prefix
procedure p_setPrefixToMenuAndXPButton( const as_Prefix : String;
                                        const axb_Button : TJvXPButton ;
                                        const amen_Menu : TMenuItem ;
                                        const aiml_Images : TImageList );
var lbmp_Bitmap   : TBitmap ;
Begin
  lbmp_Bitmap := TBitmap.Create;
  p_getNomImageToBitmap(as_Prefix, lbmp_Bitmap);
  p_setImageToMenuAndXPButton ( lbmp_Bitmap,
                                axb_Button  ,
                                amen_Menu   ,
                                aiml_Images );
{$IFDEF DELPHI}
  lbmp_Bitmap.Dormant;
{$ENDIF}
  lbmp_Bitmap.free;
end;

procedure p_AddFieldsToString ( var as_Fields : String; const alis_NodeFields : TList );
var li_i, li_k : Integer;
    lb_Found : Boolean;
    lnode : TALXMLNode;
Begin
  if assigned ( alis_NodeFields ) Then
    for li_i := 0 to alis_NodeFields.Count - 1 do
      Begin
        lnode := TALXMLNode (alis_NodeFields [li_i]);
        lb_Found := False;
        for li_k := 0 to lnode.ChildNodes.Count - 1 do
          with lnode.ChildNodes [ li_k ] do
           if  ( NodeName = CST_LEON_FIELD_F_MARKS )
           and   HasAttribute(CST_LEON_FIELD_LOCAL )
           and ( Attributes[CST_LEON_FIELD_LOCAL] <> CST_LEON_BOOL_FALSE ) Then
             Exit;
        if as_Fields = '*'
         Then as_Fields := fs_GetIdAttribute ( lnode )
         Else AppendStr(as_Fields, ','+ fs_GetIdAttribute ( lnode ));

     End;
end;


function fb_createFieldID (const ab_IsSourceTable : Boolean; const anod_Field: TALXMLNode ; const affd_ColumnFieldDef : TFWFieldColumn; const ai_Fieldcounter : Integer ):Boolean;
Begin
  Result := anod_Field.Attributes [ CST_LEON_ID ] <> Null;
  if result Then
    with affd_ColumnFieldDef do
      begin
        IsSourceTable := ab_IsSourceTable;
        NumTag      := ai_Fieldcounter + 1;
        FieldName   := anod_Field.Attributes [ CST_LEON_ID ];
        ShowSearch  := -1;
        ColSelect:=False;
      end;
end;



// function fb_setChoiceProperties
// After having read child nodes from component node setting the values of choice node
// anod_FieldProperty : Component Node
// argr_Control : Choice component
function fb_setChoiceProperties ( const anod_FieldProperty : TALXMLNode ; const argr_Control : TCustomRadioGroup ): Boolean;
var li_i : LongInt ;
    lnod_ChoiceProperty : TALXMLNode ;
    lstl_Values : TStrings;
Begin
  Result := False;
  if  ( anod_FieldProperty.NodeName = CST_LEON_CHOICE_OPTIONS )
  and   anod_FieldProperty.HasChildNodes  then
   Begin
    lstl_Values := fobj_getComponentObjectProperty(argr_Control,CST_PROPERTY_VALUES) as TStrings;
    Result := True;
    for li_i := 0 to anod_FieldProperty.ChildNodes.Count -1 do
      Begin
        lnod_ChoiceProperty := anod_FieldProperty.ChildNodes [ li_i ];
        // optional values
        if lnod_ChoiceProperty.NodeName = CST_LEON_CHOICE_OPTION then
          Begin
            argr_Control.Items .Add ( fs_getLabelCaption ( lnod_ChoiceProperty.Attributes [ CST_LEON_OPTION_NAME ]));
            if  lnod_ChoiceProperty.HasAttribute(CST_LEON_OPTION_VALUE)
            and Assigned(lstl_Values) Then
              lstl_Values.Add ( lnod_ChoiceProperty.Attributes [ CST_LEON_OPTION_VALUE ]);
            if  lnod_ChoiceProperty.HasAttribute(CST_LEON_OPTION_DEFAULT)
            and (lnod_ChoiceProperty.Attributes [ CST_LEON_OPTION_DEFAULT ] = CST_LEON_BOOL_TRUE ) Then
              argr_Control.ItemIndex:=argr_Control.Items.Count-1;
            Continue;
          End;
      End;
  End;
End;

initialization
  GS_SUBDIR_IMAGES_SOFT := DirectorySeparator+'images'+DirectorySeparator;
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_Objets_XML );
{$ENDIF}
  if assigned ( gBmp_DefaultAcces ) Then
    Begin
      {$IFDEF DELPHI}
      gBmp_DefaultAcces.dormant;
      {$ENDIF}
      gBmp_DefaultAcces.free;
    End;
  gch_SeparatorCSV:= '|';

end.
