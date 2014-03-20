unit fonctions_xmlform;

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

uses Forms, JvXPBar, JvXPContainer,
{$IFDEF FPC}
   LCLIntf, LCLType,
{$ELSE}
   Windows, ToolWin,
{$ENDIF}
  Controls, Classes, JvXPButtons, ExtCtrls,
  Menus, DB,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  ALXmlDoc, Graphics,
  u_multidonnees,
  u_xmlform,
  fonctions_manbase,
  ComCtrls,
  fonctions_ObjetsXML,
  fonctions_dbservice,
  fonctions_system, u_customframework,
  u_multidata;

{$IFDEF VERSIONS}
const
  gver_fonctions_XMLForm : T_Version = (Component : 'Gestion des objets dynamiques de XMLForm' ;
                                           FileUnit : 'fonctions_XMLForm' ;
              			           Owner : 'Matthieu Giroux' ;
              			           Comment : 'Gestion des données des objets dynamiques de XMLForm.' + #13#10
                                                   + 'Il comprend une création de menus' ;
              			           BugsStory :'Version 1.1.0.0 : not every leonardi types, adapting to manframes.'+#10+
                                                      'Version 1.0.0.0 : from fonctions_objetsXML.';
              			           UnitType : 1 ;
              			           Major : 1 ; Minor : 1 ; Release : 0 ; Build : 0 );

{$ENDIF}


function fb_ReadXMLEntitites () : Boolean;
procedure p_CreeAppliFromNode ( const as_EntityFile : String );
function fxf_ExecuteNoFonction ( const ai_Fonction                  : LongInt    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteFonction ( const as_Fonction                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteFonctionFile ( const as_FonctionFile                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteAFonction ( const alf_Function                  : TLeonFunction    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
procedure p_ExecuteFonction ( aobj_Sender                  : TObject            ); overload;

implementation

uses U_FormMainIni, SysUtils, TypInfo,
     fonctions_Dialogs,
     fonctions_xml,
     fonctions_images ,
     fonctions_init,
     Variants, fonctions_proprietes,
     fonctions_Objets_Dynamiques,
     fonctions_dbcomponents,
     unite_variables, u_languagevars, Imaging,
     u_framework_dbcomponents,
     u_connection,
     fonctions_createsql,
     fonctions_languages,
     u_xmlfillcombobutton,
     u_fillcombobutton,
     fonctions_forms;

////////////////////////////////////////////////////////////////////////////////
// function fb_ReadXMLEntitites
// destroying and Loading project xml files
// Résultat : il y a un fichier projet.
////////////////////////////////////////////////////////////////////////////////
function fb_ReadXMLEntitites () : Boolean;
var ls_entityFile : String ;
Begin
  Result := gs_ProjectFile <> '';
  FreeAndNil(gxdo_RootXML);
  FreeAndNil(gxdo_MenuXML);
  if result Then
    Begin
      ls_entityFile := fs_BuildTreeFromXML ( 0, gxdo_FichierXML.Node ,TOnExecuteProjectNode ( p_onProjectNode ) ) ;
      if  assigned ( gNod_RootAction )
      and ( gNod_RootAction <> gNod_DashBoard ) Then
       Begin
         if gNod_RootAction.Attributes[CST_LEON_TEMPLATE]=CST_LEON_TEMPLATE_LOGIN Then
          Begin
           gf_Users := TF_XMLForm.Create ( Application );
           (gf_Users as TF_XMLForm).p_setLogin(gxdo_MenuXML, gxb_Ident, gMen_MenuIdent, gIma_ImagesMenus, gBmp_DefaultAcces, gi_FinCompteurImages );
           Exit;
          end
         Else
          MyShowMessage(Gs_NotImplemented);
       end
      Else
       p_CreeAppliFromNode ( '' );
    End;
End;


procedure p_CreeAppliFromNode ( const as_EntityFile : String );
Begin
  if fb_CreeAppliFromNode ( as_EntityFile ) then
   fxf_ExecuteNoFonction(high ( ga_Functions ), True);
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
// function fs_GetIDFields
// getting a list separated by comma from nodes
// alis_NodeFields : Node fields
// as_Empty        : if empty put this string
////////////////////////////////////////////////////////////////////////////////
function fs_GetStringFields  ( const alis_NodeFields : TList ; const as_Empty : String ; const ab_AddOne : Boolean ):String;
var
    li_i, li_j : Integer ;
    lb_IsLarge : Boolean;
    lnode  : TALXMLNode;
Begin
  Result := as_Empty;
  li_j := 0;
  for li_i := 0 to  alis_NodeFields.count - 1 do
    Begin
      lnode := TALXMLNode ( alis_NodeFields [ li_i ]);
      if li_j = 0 Then
        Begin
          Result := fs_GetIdAttribute( lnode );
          inc ( li_j );
          if ab_AddOne Then
            Break;
        end
       Else
        Result := Result + ',' + fs_GetIdAttribute( lnode );
    end;
end;
////////////////////////////////////////////////////////////////////////////////
// function fs_GetIDFields
// getting a list separated by comma from nodes
// alis_NodeFields : Node fields
// as_Empty        : if empty put this string
////////////////////////////////////////////////////////////////////////////////
function fa_GetArrayFields  ( const alis_NodeFields : TList ):TStringArray;
var
    li_i : Integer ;
Begin
  Finalize(Result);
  for li_i := 0 to  alis_NodeFields.count - 1 do
    Begin
      SetLength(Result, high ( Result ) + 2);
      Result [high ( Result )] := fs_GetNodeAttribute( TALXMLNode ( alis_NodeFields [ li_i ] ), CST_LEON_NAME );
    end
end;

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

function fb_IsNodeLocal ( const anode : TALXMLNode ): Boolean;
var li_k : Integer;
Begin
  Result := False;
  for li_k := 0 to anode.ChildNodes.Count - 1 do
  with anode.ChildNodes [ li_k ] do
   if  ( NodeName = CST_LEON_FIELD_F_MARKS )
   and   HasAttribute(CST_LEON_FIELD_LOCAL )
   and ( Attributes[CST_LEON_FIELD_LOCAL] <> CST_LEON_BOOL_FALSE ) Then
    Begin
     Result := True;
     Exit;
    end;
end;

// procedure p_AddFieldsToString
// used to create a combo
procedure p_AddFieldsToString ( var as_Fields : String; const alis_NodeFields : TList );
var li_i, li_k : Integer;
    lnode : TALXMLNode;
Begin
  if assigned ( alis_NodeFields ) Then
    for li_i := 0 to alis_NodeFields.Count - 1 do
      Begin
        lnode := TALXMLNode (alis_NodeFields [li_i]);
        if fb_IsNodeLocal ( lnode ) Then
          Exit;
        if as_Fields = '*'
         Then as_Fields := fs_GetIdAttribute ( lnode )
         Else AppendStr(as_Fields, ','+ fs_GetIdAttribute ( lnode ));

     End;
end;


/////////////////////////////////////////////////////////////////////////
// function fxf_ExecuteNoFonction
// Execute a function number
// Fonction qui exécute une fonction à partir d'une clé de fonction
// as_Fonction : The number of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
function fxf_ExecuteNoFonction ( const ai_Fonction                  : LongInt    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
var llf_Function      : TLeonFunction;
begin
  Result := nil;
  // Recherche dans ce qui a été chargé par les fichiers XML
  if ai_Fonction < 0 then
    Exit;
  //Trouvé
  // Fichier XML de la fonction
  llf_Function := ga_functions [ ai_Fonction ];
  Result := fxf_ExecuteAFonction ( llf_Function, ab_Ajuster );
End ;

/////////////////////////////////////////////////////////////////////////
// function fxf_ExecuteAFonction
// Execute a function record
// Fonction qui exécute une fonction à partir d'un enregistrement fonction
// as_Fonction : The number of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
function fxf_ExecuteAFonction ( const alf_Function                  : TLeonFunction    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
var lb_Unload        : Boolean ;
    li_i : Longint;
    lfs_newFormStyle : TFormStyle ;
    lico_icon : TIcon ;
    lbmp_Bitmap : TBitmap ;
begin
  Result := nil;
  // La fiche peut être déjà créée
  for li_i := 0 to Application.ComponentCount -1 do
    if ( Application.Components [ li_i ] is TF_XMLForm )
    and (( Application.Components [ li_i ] as TF_XMLForm ).Fonction.Clep = alf_Function.Clep ) Then
      Result := Application.Components [ li_i ] as TF_XMLForm ;
  // Se place sur la bonne fonction
  if not assigned ( Result ) Then
    Begin
      Result := TF_XMLForm.create ( Application );
      Result.Fonction := alf_Function;
      lbmp_Bitmap := TBitmap.Create;
      fb_getImageToBitmap(alf_Function.Prefix,lbmp_Bitmap);
      lico_Icon := TIcon.Create;
      p_BitmapVersIco(lbmp_Bitmap,lico_Icon);
    // Assigne l'icône si existe
      If not lico_Icon.Empty
       Then
        try
          Result.Icon.Modified := False ;
          Result.Icon.PaletteModified := False ;
          if Result.Icon.Handle <> 0 Then
            Begin
              Result.Icon.ReleaseHandle ;
              Result.Icon.CleanupInstance ;
            End ;
          Result.Icon.Handle := 0 ;
          Result.Icon.width  := 16 ;
          Result.Icon.Height := 16 ;
          Result.Icon.Assign ( lico_Icon );
          Result.Icon.Modified := True ;
          Result.Icon.PaletteModified := True ;

          Result.Invalidate ;
        Except
        End ;
      {$IFDEF FPC}
      if lico_Icon.Handle <> 0 Then
        lico_Icon.ReleaseHandle;
      lico_Icon.Handle := 0;
      {$ENDIF}
       lico_Icon.Free;
      {$IFDEF DELPHI}
       lbmp_Bitmap.Dormant ;
      {$ENDIF}
       lbmp_Bitmap.FreeImage;
       lbmp_Bitmap.Free;
        // Paramètres d'affichage
    End;

  if  ab_Ajuster then
    Begin
      lb_Unload := fb_getComponentBoolProperty ( Result, 'DataUnload' );
     // Initialisation de l'ouverture de fiche
      lfs_newFormStyle := TFormStyle(alf_Function.Mode) ;
      if not lb_Unload Then
        fb_setNewFormStyle( Result, lfs_newFormStyle, ab_Ajuster)
      else
        Result.Free ;
    End ;
End ;


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
      fxf_ExecuteFonction ( ls_FonctionClep, True );
    End;
  // Se place sur la fonction
End ;

/////////////////////////////////////////////////////////////////////////
// function fxf_ExecuteFonction
// Execute a funtion with key as_Fonction
// Fonction qui exécute une fonction à partir d'une clé de fonction
// as_Fonction : la clé de la fonction
// as_Fonction : the key of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
function fxf_ExecuteFonction ( const as_Fonction                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
begin
  // Recherche dans ce qui a été chargé par les fichiers XML
  Result := fxf_ExecuteNoFonction ( fi_findAction ( as_Fonction ), ab_ajuster);
End ;

/////////////////////////////////////////////////////////////////////////
// function fxf_ExecuteFonction
// Execute a funtion with key as_Fonction
// Fonction qui exécute une fonction à partir d'une clé de fonction
// as_Fonction : la clé de la fonction
// as_Fonction : the key of function
// ab_Ajuster  : Adjust the form of function
/////////////////////////////////////////////////////////////////////////
function fxf_ExecuteFonctionFile ( const as_FonctionFile                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
var llf_Function      : TLeonFunction;
begin
  // Recherche dans ce qui a été chargé par les fichiers XML
  Result := fxf_ExecuteNoFonction ( fi_findActionFile ( as_FonctionFile ), ab_ajuster);

  // Form not found in registered forms, but can exists in files.
  if Result = nil Then
    Begin
      llf_Function.Clep  := as_FonctionFile;
      llf_Function.AFile := as_FonctionFile;
      llf_Function.Name  := CST_LEON_NAME_BEGIN + UpperCase(as_FonctionFile);
      Result :=  fxf_ExecuteAFonction ( llf_Function, ab_Ajuster );
    end;
End ;

function fb_AutoCreateDatabaseWithQuery ( const as_BaseName, as_user, as_password, as_host, as_sql1, as_sql2 : String ; const ads_connection : TDSSource = nil ):Boolean;
var     LDataset : TDataset;
Begin
  with ads_connection do
   Begin
    p_ShowConnectionWindow(Connection,f_GetMemIniFile);
    try
      if not fb_OpenCloseDatabase ( Connection, True )
       Then
        Abort;
    Except
      on e: Exception do
        Raise EDatabaseError.Create ( 'Connection not started : ' + DataDriver + ' and ' + DataURL +#13#10 + 'User : ' + DataUser +#13#10 + 'Base : ' + Database    );
    end;
    LDataset:=fdat_CloneDatasetWithoutSQL(DMModuleSources.Sources[0].QueryCopy,ads_connection.Connection.Owner);
    try
      p_ExecuteSQLScriptServer(Connection,as_sql1);
    finally
    end;
    p_SetComponentProperty(Connection,CST_DB_DATABASE,as_BaseName);
    try
      p_ExecuteSQLScriptServer(Connection,as_sql2);
    finally
      LDataset.Destroy;
    end;
   end;
 End;

initialization
  gefc_FillComboAutoCreated := TXMLFillCombo;
  ge_ExecuteSQLScript:=TOnExecuteSQLScript(fb_AutoCreateDatabaseWithQuery);
end.
