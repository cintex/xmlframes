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
  ALXmlDoc, IniFiles, Graphics,
  u_multidonnees, fonctions_string,
  fonctions_manbase, u_xmlform,
  fonctions_ObjetsXML,
  fonctions_service,
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
function fds_CreateDataSourceAndOpenedQuery ( const as_Table, as_NameEnd : String  ; const ar_Connection : TDSSource; const alis_IdFields, alis_NodeFields : TList ; const acom_Owner : TComponent; const afws_SourceAdded : TFWSource ): TDatasource;
procedure p_setNodeId ( const anod_FieldId, anod_FieldIsId : TALXMLNode;  const afws_Source : TFWTable ; const ach_FieldDelimiter : Char );



implementation

uses U_FormMainIni, SysUtils, TypInfo, Dialogs, fonctions_xml,
     fonctions_images , fonctions_init, U_XMLFenetrePrincipale,
     Variants, fonctions_proprietes, fonctions_Objets_Dynamiques,
     fonctions_autocomponents, fonctions_dbcomponents, strutils,
     unite_variables, u_languagevars, Imaging, fonctions_languages,
     fonctions_forms;

////////////////////////////////////////////////////////////////////////////////
// function fb_ReadXMLEntitites
// destroying and Loading prject xml files
// Résultat : il y a un fichier projet.
////////////////////////////////////////////////////////////////////////////////
function fb_ReadXMLEntitites () : Boolean;
var ls_entityFile : String ;
Begin
  Result := gs_ProjectFile <> '';
  gxdo_RootXML.Free;
  gxdo_MenuXML   .Free;
  gxdo_RootXML := nil;
  gxdo_MenuXML    := nil;
  if result Then
    Begin
      ls_entityFile := fs_BuildMenuFromXML ( 0, gxdo_FichierXML.Node ) ;
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
          ShowMessage(Gs_NotImplemented);
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
function fdoc_GetCrossLinkFunction( const as_FunctionClep, as_ClassBind :String;
                                    var as_Table, as_connection : String; var aanod_idRelation,  aanod_DisplayRelation : TList ;
                                    var anod_NodeCrossLink : TALXMLNode ; var ab_OnFieldToFill : Boolean ): TALXMLDocument ;
var li_i , li_j, li_k: Integer ;
    lnod_ClassProperties,
    lnod_Node : TALXMLNode;
    ls_ProjectFile : String;
    li_CountFields : Integer;
begin
  Result := TALXMLDocument.Create ( Application );
  ls_ProjectFile := fs_getProjectDir ( ) + as_Table + CST_LEON_File_Extension;
  li_CountFields := 0 ;
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
                              p_GetMarkFunction(lnod_ClassProperties.ChildNodes [ li_k ], CST_LEON_FIELD_main, aanod_DisplayRelation );
                              p_CountMarkFunction(lnod_ClassProperties.ChildNodes [ li_k ], CST_LEON_FIELD_optional, False, li_CountFields );
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
  if li_CountFields <= 1 Then
   ab_OnFieldToFill := True;
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
function fft_getFieldType ( const anod_Field : TALXMLNode; const ab_SearchLarge : Boolean = True ;const ab_IsLarge : Boolean = False) : TFieldType;
var lb_isLarge : Boolean ;
    li_k : Integer;
    lnod_FieldProperties : TALXMLNode;
begin
  Result := ftString;
  if ab_SearchLarge then
     Begin
       lb_isLarge := False;
       if anod_Field.HasChildNodes then
       for li_k := 0 to anod_Field.ChildNodes.Count -1 do
        Begin
          lnod_FieldProperties := anod_Field.ChildNodes [ li_k ];
          if ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS )
          or ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS ) then
           Begin
            lb_IsLarge := True;
            Break;
           end;
        end;
      End
    Else
     lb_isLarge:=ab_IsLarge;
  if ( anod_Field.NodeName = CST_LEON_FIELD_NUMBER ) then
   begin
     if  anod_Field.HasAttribute(CST_LEON_FIELD_TYPE)
     and ( anod_Field.Attributes [ CST_LEON_FIELD_TYPE ] = CST_LEON_FIELD_DOUBLE )
      Then Result := ftFloat
      Else Result := ftInteger;
   end
  else if anod_Field.NodeName = CST_LEON_FIELD_TEXT then
    Begin
      if lb_isLarge Then
        Begin
          Result := ftBlob;
        End
       Else
        Begin
          Result := ftString;
        End
    End
  else if anod_Field.NodeName = CST_LEON_FIELD_FILE then
    Begin
      Result := ftString;
    End
  else if anod_Field.NodeName = CST_LEON_RELATION then
    Begin
    End
  else if anod_Field.NodeName = CST_LEON_FIELD_DATE then
    Begin
      Result := ftDate;
    End
  else if anod_Field.NodeName = CST_LEON_FIELD_CHOICE then
    Begin
      Result := ftInteger;
    End;

end;


////////////////////////////////////////////////////////////////////////////////
// procedure p_setFieldDefs
// getting CSV definitions and adding them from file
// adat_Dataset : CSV dataset
// alis_NodeFields : node of field nodes
////////////////////////////////////////////////////////////////////////////////

procedure p_setFieldDefs ( const afws_Source : TFWSource ; const alis_NodeFields : TList );
var li_i, li_j : Integer ;
    ls_FieldName : String;
begin
  for li_i := 0 to  alis_NodeFields.count - 1 do
   Begin
     with TALXMLNode ( alis_NodeFields [ li_i ] ) do
     Begin
      if Attributes[CST_LEON_ID] <> Null
       Then ls_FieldName:= Attributes[CST_LEON_ID]
       Else ls_FieldName:= Attributes[CST_LEON_IDREF];
      li_j := afws_Source.FieldsDefs.indexOf(ls_FieldName);
      if li_j = -1
       Then
        Exit;
      with afws_Source.FieldsDefs.Add do
       Begin
        FieldType := fft_getFieldType ( TALXMLNode ( alis_NodeFields [ li_i ] ), True );
        FieldName:=ls_FieldName;
       end;
     end;
   end;
End;

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

function fs_GetDisplayFields  ( const alis_NodeFields : TList ; const as_Empty : String ):String;
var
    li_i : Integer ;
    listnodes : TList ;
Begin
  Result := as_Empty;
  listnodes := TList.Create;
  for li_i := 0 to  alis_NodeFields.count - 1 do
    Begin
      p_GetMarkFunction(alis_NodeFields [ li_i ],CST_LEON_FIELD_main, listnodes );
    End;
  Result := as_Empty;
  for li_i := 0 to  listnodes.count - 1 do
    if li_i = 0 Then
      Result := fs_GetNodeAttribute( TALXMLNode ( listnodes [ li_i ] ), CST_LEON_ID )
     Else
      Result := Result + CST_COMBO_FIELD_SEPARATOR + fs_GetNodeAttribute( TALXMLNode ( listnodes [ li_i ] ), CST_LEON_ID );
  listnodes.Free;
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

procedure p_AddFieldsToFieldColumn ( const afc_Fields : TFWFieldColumns; const alis_NodeFields : TList );
var li_i, li_k : Integer;
    lnode : TALXMLNode;
Begin
  if assigned ( alis_NodeFields ) Then
    for li_i := 0 to alis_NodeFields.Count - 1 do
      Begin
        lnode := TALXMLNode (alis_NodeFields [li_i]);
        if fb_IsNodeLocal ( lnode ) Then
          Exit;
        with afc_Fields.Add do
            FieldName := fs_GetIdAttribute ( lnode )

     End;
end;

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

////////////////////////////////////////////////////////////////////////////////
// function fds_CreateDataSourceAndOpenedQuery
// create datasource, dataset, setting and open it
// as_Table      : Table name
// as_Fields     : List of fields with comma
// as_NameEnd    : End of components' names
// ar_Connection : Connection of table
// alis_NodeFields : Node of fields' nodes
////////////////////////////////////////////////////////////////////////////////
function fds_CreateDataSourceAndOpenedQuery ( const as_Table, as_NameEnd : String  ; const ar_Connection : TDSSource; const alis_IdFields, alis_NodeFields : TList ; const acom_Owner : TComponent; const afws_SourceAdded : TFWSource ): TDatasource;
var lfc_Fields : TFWFieldColumns ;
    ls_FieldString : String;
    li_i : Integer;
begin
  with ar_Connection do
    Begin
      Result := fds_CreateDataSourceAndDataset ( as_Table, as_NameEnd, QueryCopy, acom_Owner );
      lfc_Fields := nil;
      if assigned ( afws_SourceAdded ) Then
         with afws_SourceAdded do
           Begin
             if GetKeyCount = 0 Then
              with Indexes.Insert(0) do
                Begin
                 IndexKind:=ikPrimary;
                 lfc_Fields := FieldsDefs;
                end;
            p_AddFieldsToFieldColumn ( lfc_Fields, alis_IdFields );
            ls_FieldString := lfc_Fields.GetString;
            Datasource:=Result;
            Table := as_Table;
            p_setFieldDefs ( afws_SourceAdded, alis_IdFields );
            p_AddFieldsToFieldColumn ( FieldsDefs, alis_NodeFields );
            ls_FieldString:=FieldsDefs.GetString;
            if ls_FieldString > '' Then
             for li_i := 0 to lfc_Fields.Count -1 do
              with lfc_Fields [ li_i ] do
               if FieldsDefs.indexOf ( FieldName ) = -1 Then
                if ls_FieldString=''
                 Then ls_FieldString:=FieldName
                 else ls_FieldString:=','+FieldName;
           end;

      if DatasetType in [dtCSV{$IFDEF DBNET},dtDBNet{$ENDIF}]
       Then
         Begin
           if DatasetType = dtCSV Then
             p_setComponentProperty ( Result.Dataset, 'FileName', DataURL + as_Table +GS_Data_Extension );
           {$IFDEF DBNET}
           if DatasetType = dtDBNet Then
             p_SetSQLQuery(Result.Dataset, 'SELECT '+ls_FieldString + ' FROM ' + as_Table );
           {$ENDIF}
         end
        else
        p_SetSQLQuery(Result.Dataset, 'SELECT '+ls_FieldString + ' FROM ' + as_Table );
      Result.DataSet.Open;
    end;
end;


procedure p_setNodeId ( const anod_FieldId, anod_FieldIsId : TALXMLNode;  const afws_Source : TFWTable ; const ach_FieldDelimiter : Char );
Begin
  if anod_FieldIsId.HasAttribute ( CST_LEON_ID)
  and not ( anod_FieldIsId.Attributes [ CST_LEON_ID ] = CST_LEON_BOOL_FALSE )  then
     with afws_Source do
    Begin
      if afws_Source.FieldsDefs.indexOf(anod_FieldId.Attributes [CST_LEON_ID]) = -1 Then
        with afws_Source.FieldsDefs.Add do
         Begin
          FieldType := fft_getFieldType ( anod_FieldId, True );
          FieldName := anod_FieldId.Attributes [CST_LEON_ID];
         end;
      with GetKey.Add do
       Begin
        FieldName := anod_FieldId.Attributes [CST_LEON_ID];
       end;
    End;
end;



function fb_OpenClass ( const as_XMLClass : String ; const acom_owner : TComponent ; var axml_SourceFile : TALXMLDocument ):Boolean;
var ls_ProjectFile : String ;
begin
  Result := False;
  if not assigned ( axml_SourceFile ) Then
    axml_SourceFile := TALXMLDocument.Create ( acom_owner );
  ls_ProjectFile := fs_getProjectDir ( ) + as_XMLClass + CST_LEON_File_Extension;
  // For actions at the end of xml file
  If ( FileExists ( ls_ProjectFile )) Then
   // reading the special XML form File
    try
      if fb_LoadXMLFile ( axml_SourceFile, ls_ProjectFile ) Then
         Result := True;
    Except
      On E: Exception do
        Begin
          ShowMessage ( 'Erreur opening XML Class File : ' + E.Message );
        End;
    End ;

end;


function fb_createFieldID (const ab_IsSourceTable : Boolean; const anod_Field: TALXMLNode ; const affd_ColumnFieldDef : TFWFieldColumn; const ai_Fieldcounter : Integer; const ab_IsLocal : Boolean ):Boolean;
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

// Function fb_getFieldOptions
// setting some data properties
// Result : quitting
function fb_getFieldOptions ( const afws_Source : TFWSource; const anod_Field,anod_FieldProperties : TALXMLNode ; const ab_IsLarge : Boolean; const affd_ColumnFieldDef : TFWFieldColumn; var ab_IsLocal : Boolean ; const ach_FieldDelimiter : Char; const ai_counter : Integer ): Boolean;
begin
  Result := False;
  with anod_FieldProperties do
  if NodeName = CST_LEON_FIELD_F_MARKS then
    Begin
      if HasAttribute ( CST_LEON_FIELD_local )
      and ( Attributes [ CST_LEON_FIELD_local ] <> CST_LEON_BOOL_FALSE )  then
        Begin
          ab_IsLocal := True;
          affd_ColumnFieldDef.ColSelect:=False;
        End;
      if afws_Source.Connection.DatasetType in [dtCSV{$IFDEF DBNET},dtDBNet{$ENDIF}] then
        Begin
          affd_ColumnFieldDef.FieldType := fft_GetFieldType ( anod_Field, False, ab_IsLarge );
        End;

      if HasAttribute ( CST_LEON_FIELD_CREATE)
       then affd_ColumnFieldDef.ColCreate  := Attributes [ CST_LEON_FIELD_CREATE ] = CST_LEON_BOOL_TRUE;
      if HasAttribute ( CST_LEON_FIELD_UNIQUE)
       then affd_ColumnFieldDef.ColUnique  := Attributes [ CST_LEON_FIELD_UNIQUE ] = CST_LEON_BOOL_TRUE;
      p_setNodeId ( anod_Field, anod_FieldProperties, afws_Source, ach_FieldDelimiter );
      if HasAttribute ( CST_LEON_FIELD_hidden )
      and not ( Attributes [ CST_LEON_FIELD_hidden ] = CST_LEON_BOOL_FALSE )  then
        Begin
          affd_ColumnFieldDef.ShowCol := -1;
          affd_ColumnFieldDef.ShowSearch := -1;
          Result := True;
          Exit;
        End;
      affd_ColumnFieldDef.ShowCol := ai_counter + 1;
      if HasAttribute ( CST_LEON_FIELD_optional)
      and not ( Attributes [ CST_LEON_FIELD_optional ] = CST_LEON_BOOL_TRUE )  then
        Begin
          affd_ColumnFieldDef.ColMain  := False;
          affd_ColumnFieldDef.ShowCol := -1;
        End
       Else
        affd_ColumnFieldDef.ColMain := True;
      if ( HasAttribute ( CST_LEON_FIELD_sort)
           and ( Attributes [ CST_LEON_FIELD_sort ] = CST_LEON_BOOL_TRUE ))
      or ( HasAttribute ( CST_LEON_FIELD_find)
           and ( Attributes [ CST_LEON_FIELD_find ] = CST_LEON_BOOL_TRUE ))  then
        Begin
          affd_ColumnFieldDef.ShowSearch := ai_counter + 1;
        End
    End;

end;

procedure p_SetFieldSelect ( const afws_Source : TFWSource ; const anod_Field : TALXMLNode; const affd_ColumnFieldDef : TFWFieldColumn ; const ab_IsLocal, ab_IsLarge : Boolean );
Begin
  if not ab_IsLocal Then
   Begin
     affd_ColumnFieldDef.ColSelect:=True;
     if (afws_Source.Connection.DatasetType in [dtCSV{$IFDEF DBNET},dtDBNet{$ENDIF}]) then
      Begin
        affd_ColumnFieldDef.FieldType := fft_getFieldType ( anod_Field, False, ab_IsLarge );
      End;

   end;
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
    End;

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


end.
