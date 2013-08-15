unit fonctions_xml;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  ALXmlDoc, controls,
  Forms;

const CST_LEON_File_Extension = '.xml';

      CST_LEON_DUMMY = 'DUMMY' ;
      CST_LEON_PROJECT = 'PROJECT' ;
      CST_LEON_ROOT_ACTION = 'rootAction' ;
      CST_LEON_CLASS = 'CLASS' ;
      CST_LEON_BOOL_FALSE = 'false' ;
      CST_LEON_BOOL_TRUE  = 'true' ;

      CST_LEON_NAME_BEGIN     = 'NAME_' ;
      CST_LEON_LOCATION = 'location';
      CST_LEON_IDREF = 'idref';
      CST_LEON_VALUE = 'value';
      CST_LEON_NAME  = 'NAME' ;
      CST_LEON_VIEW  = 'view' ;

      CST_LEON_PASSWORD_INFO = '_passwordFieldInfo' ;
      CST_LEON_LOGIN_INFO    = '_loginFieldInfo' ;
      CST_LEON_USER_CLASS    = '_userClassInfo' ;

      CST_LEON_SYSTEM_ROOT     = 'ROOT SYSTEM';
      CST_LEON_SYSTEM_LOCATION = 'LOCATION SYSTEM';
      CST_LEON_SYSTEM_NAVIGATION = 'NAVIGATION SYSTEM';

      CST_LEON_DIR           = '$LY_APP_DIR$';
      CST_IMAGES_DIR         = 'images/';

      CST_LEON_DATA_FILE     = 'L_FILE' ;
      CST_LEON_DATA_SQL      = 'L_SQL' ;
      CST_LEON_DATA_URL      = 'url' ;
      CST_LEON_DATA_USER     = 'user' ;
      CST_LEON_DATA_password = 'password' ;
      CST_LEON_DATA_DATABASE = 'dbName' ;
      CST_LEON_DATA_DRIVER   = 'driver' ;
      CST_LEON_DATA_FIELDSEP = 'fieldSep' ;
      CST_LEON_DATA_VALUESEP = 'valueSep' ;
      CST_LEON_DATA_MYSQL    = '.mysql.' ;
      CST_LEON_DATA_FIREBIRD = '.firebird.' ;
      CST_LEON_DATA_POSTGRES = '.postgresql.' ;
      CST_LEON_DATA_SQLSERVER= '.mssql.' ;
      CST_LEON_DATA_ORACLE   = '.oracle.' ;
      CST_LEON_DATA_SQLLITE  = '.sqllite.' ;

      CST_LEON_DRIVER_MYSQL    = 'mysql-5' ;
      CST_LEON_DRIVER_FIREBIRD = 'firebird-2.1' ;
      CST_LEON_DRIVER_POSTGRES = 'postgresql-8' ;
      CST_LEON_DRIVER_SQLSERVER= 'mssql' ;
      CST_LEON_DRIVER_SQLLITE  = 'sqllite' ;
      CST_LEON_DRIVER_ORACLE   = 'oracle-9i' ;

      CST_LEON_FIELDS = 'FIELDS' ;
      CST_LEON_FIELD_id = 'id' ;
      CST_LEON_FIELD_TIP   = 'TIP' ;
      CST_LEON_FIELD_NCOLS = 'NCOLS' ;
      CST_LEON_FIELD_MIN   = 'MIN' ;
      CST_LEON_FIELD_MAX   = 'MAX' ;
      CST_LEON_FIELD_NROWS = 'NROWS' ;

      CST_LEON_IDREFs = 'idrefs';
      CST_LEON_CLASS_REF    = 'CLASS_REF';
      CST_LEON_CLASSES      = 'CLASSES';
      CST_LEON_CLASS_BIND   = 'C_BIND';

      CST_LEON_CHOICE_OPTIONS = 'OPTIONS' ;
      CST_LEON_CHOICE_OPTION  = 'OPTION' ;
      CST_LEON_OPTION_NAME    = 'name' ;
      CST_LEON_OPTION_VALUE   = 'value' ;

      CST_LEON_FIELD_NUMBER   = 'NUMBER' ;
      CST_LEON_FIELD_TYPE     = 'type' ;
      CST_LEON_FIELD_DOUBLE   = 'DOUBLE' ;
      CST_LEON_FIELD_DATE     = 'DATE' ;
      CST_LEON_FIELD_TEXT     = 'TEXT' ;
      CST_LEON_FIELD_CHOICE   = 'CHOICE' ;
      CST_LEON_FIELD_FILE     = 'FILE' ;
      CST_LEON_STRUCT         = 'STRUCT' ;
      CST_LEON_ARRAY          = 'ARRAY' ;

      CST_LEON_RELATION       = 'RELATION' ;
      CST_LEON_RELATION_C_BIND= 'C_BIND' ;
      CST_LEON_RELATION_F_BIND= 'F_BIND' ;
      CST_LEON_RELATION_CBIND = 'cbind' ;
      CST_LEON_RELATION_JOIN  = 'JOIN_DAEMON' ;

      CST_LEON_FIELDS_DEF  : array [0..6] of string = (CST_LEON_FIELD_NUMBER,CST_LEON_FIELD_DATE,CST_LEON_RELATION,CST_LEON_FIELD_TEXT,CST_LEON_FIELD_CHOICE,CST_LEON_FIELD_FILE,CST_LEON_STRUCT);


      CST_LEON_FIELD_F_MARKS  = 'F_MARKS' ;
      CST_LEON_FIELD_F_BIND   = 'F_BIND' ;
      CST_LEON_FIELD_LOCAL    = 'local' ;
      CST_LEON_FIELD_CREATE   = 'create' ;
      CST_LEON_FIELD_UNIQUE   = 'unique' ;
      CST_LEON_FIELD_HIDDEN   = 'hidden' ;
      CST_LEON_FIELD_private  = 'private' ;
      CST_LEON_FIELD_optional = 'optional' ;
      CST_LEON_FIELD_main     = 'main' ;
      CST_LEON_FIELD_sort     = 'sort' ;
      CST_LEON_FIELD_find     = 'find' ;
      CST_LEON_FIELD_filter   = 'filter' ;

      CST_LEON_TEMPLATE = 'template' ;
      CST_LEON_TEMPLATE_DASHBOARD = '_dashboard' ;
      CST_LEON_TEMPLATE_LOGIN = '_login' ;
      CST_LEON_ID    = 'id' ;

      CST_LEON_PARAMETER = 'PARAMETER';
      CST_LEON_PARAMETER_NAME = 'name' ;
      CST_LEON_PARAMETER_IDREF = 'idref' ;
      CST_LEON_PARAMETER_CLASSINFO = '_classInfo' ;

      CST_LEON_TEMPLATE_MULTIPAGETABLE = '_multiPageTable' ;
      CST_LEON_ACTION_NAME = 'NAME' ;
      CST_LEON_ACTION_TEMPLATE = 'template' ;
      CST_LEON_ACTION = 'ACTION' ;
      CST_LEON_ACTION_REF = 'ACTION_REF' ;
      CST_LEON_ACTION_PREFIX = 'PREFIX' ;
      CST_LEON_ACTION_GROUP = 'GROUP' ;
      CST_LEON_ACTION_CLASSINFO = '_classInfo' ;
      CST_LEON_ACTION_VALUE = 'value' ;
      CST_LEON_ACTION_IDREF = 'idref' ;
      CST_LEON_ACTION_REF_DELETE = '_delete' ;
      CST_LEON_ACTION_REF_PRINT = '_print' ;
      CST_LEON_ACTION_REF_ADD    = '_add' ;
      CST_LEON_ACTION_REF_SET    = '_set' ;
      CST_LEON_ACTION_REF_CLONE  = '_clone' ;

      CST_LEON_COMPOUND_ACTION = 'COMPOUND_ACTION' ;
      CST_LEON_ACTIONS = 'ACTIONS' ;
      CST_LEON_ENTITY = '!ENTITY ';

      CST_XMLFRAMES_ROOT_FORM_CLEP = 'rootentitie' ;

      CST_COMBO_FIELD_SEPARATOR    = ',' ;

{$IFDEF VERSIONS}
  gver_fonctions_XML : T_Version = ( Component : 'Librairie de fonctions XML' ;
                                     FileUnit : 'fonctions_xml' ;
              			                 Owner : 'Matthieu Giroux' ;
              			                 Comment : 'Gestion des fichiers XML.' + #13#10 +
                                                           'Il ne doit pas y avoir de lien vers les objets à créer.' ;
              			                 BugsStory :  'Version 0.9.0.2 : centralising searching on xml nodes.' + #13#10 +
                                                              'Version 0.9.0.1 : Images Directory.' + #13#10 +
                                                              'Version 0.9.0.0 : Unit functionnal.' + #13#10 +
                                                              'Version 0.1.0.0 : Création de l''unité.';
              			                 UnitType : 1 ;
              			                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 2 );

{$ENDIF}
function fb_LoadXMLFile ( const axdo_FichierXML : TALXMLDocument; const as_FileXML : String ): Boolean;

// XML parameters
var gs_ProjectFile  : String;
    gs_RootEntities : String ;
    gNod_DashBoard  : TALXMLNode = nil;
    gNod_RootAction : TALXMLNode = nil;
    gxdo_FichierXML : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
    gxdo_MenuXML    : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
    gxdo_RootXML    : TALXMLDocument = nil;// Lecture de Document XML   initialisé  au create
    gs_entities     : String  = 'rootEntities' ;
    gs_Encoding     : String = 'ISO-8859-1';


function fs_getSoftInfo : String;
function fs_getSoftFiles : String;
function fs_getImagesDir : String;
function fs_getProjectDir : String;
function fs_LeonFilter ( const AString : String ): String;
procedure p_GetMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const aano_IdNodes : TList );
procedure p_CountMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const ab_IsTrue : Boolean;  var ai_Count : Integer );
function fb_GetCrossLinkFunction( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
function fs_GetNodeAttribute( const anod_Node : TALXMLNode ; const as_Attribute : String ) : String ;
function fnod_GetClassFromRelation( const anod_Node : TALXMLNode ) : TALXMLNode ;
function fnod_GetNodeFromTemplate( const anod_Node : TALXMLNode ) : TALXMLNode ;

function fwin_CreateAFieldComponent ( const as_FieldType : String ; const acom_Owner : TComponent ; const ab_isLarge, ab_IsLocal : Boolean  ; const ai_Counter : Longint ):TWinControl;
function fs_GetIdAttribute ( const anode : TALXMLNode ) : String;


implementation

uses fonctions_init, u_multidonnees,
{$IFNDEF FPC}
     Variants, StrUtils,
{$ENDIF}
     fonctions_string, Dialogs, U_ExtNumEdits,
     fonctions_autocomponents, u_framework_components,
     ExtCtrls, u_framework_dbcomponents,
     fonctions_system, fonctions_manbase,
     DbCtrls;

////////////////////////////////////////////////////////////////////////////////
// function fs_GetIdAttribute
// get id or idref attribute of node
// anode : a node with id or idref
// Result : ID or IDREF Attribute
////////////////////////////////////////////////////////////////////////////////
function fs_GetIdAttribute ( const anode : TALXMLNode ) : String;
Begin
  if anode.HasAttribute(CST_LEON_ID)
   Then Result := anode.Attributes[CST_LEON_FIELD_ID]
   Else Result := anode.Attributes[CST_LEON_IDREF]
end;



// function fs_LeonFilter
// special words replacing
// AString : Leon string
function fs_LeonFilter ( const AString : String ): String;
Begin
  Result := StringReplace ( AString, CST_LEON_DIR+DirectorySeparator, fs_getSoftDir, [rfReplaceAll] );
  Result := StringReplace ( AString, CST_LEON_DIR, fs_getSoftDir, [rfReplaceAll] );
End;

// procedure p_GetMarkFunction
// Getting field marks
// anod_Field : Node Field
// as_MarkSearched : Mark searched
// aano_IdNodes : List to add scruted field node
procedure p_GetMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const aano_IdNodes : TList );
var lnod_FieldProperties : TALXMLNode ;
    li_i : Integer ;
Begin
  if anod_Field.HasChildNodes then
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_MARKS then
          Begin
            if lnod_FieldProperties.HasAttribute ( as_MarkSearched )
            and ( lnod_FieldProperties.Attributes [ as_MarkSearched ] <> CST_LEON_BOOL_FALSE )  then
              Begin
                aano_IdNOdes.Add ( anod_Field );
              End;
            Break;
          End;
      End;
End;


/////////////////////////////////////////////////////////////////////////
// function fwin_CreateAFieldComponent
// Creating an edit component and setting properties
// as_FieldType : XML field type string
// acom_Owner : Form
// ab_isLarge : Large or litte edit
// ab_IsLocal : Local or data linked
// ai_Counter : Field counter
// returns an editing component
//////////////////////////////////////////////////////////////////////////
function fwin_CreateAFieldComponent ( const as_FieldType : String ; const acom_Owner : TComponent ; const ab_isLarge, ab_IsLocal : Boolean  ; const ai_Counter : Longint ):TWinControl;
begin
  Result := nil;
  if as_FieldType = CST_LEON_FIELD_NUMBER then
    Begin
      if ab_IsLocal then
        Begin
         Result := TExtNumEdit.Create ( acom_Owner );
         (Result as TExtNumEdit).Text:='';
        end
       else
        Result := TExtDBNumEdit.Create ( acom_Owner );
    End
  else if as_FieldType = CST_LEON_FIELD_TEXT then
    Begin
      Result := fwin_CreateAEditComponent ( acom_Owner, ab_isLarge, ab_IsLocal );
    End
  else if as_FieldType = CST_LEON_FIELD_FILE then
    Begin
      if ab_IsLocal then
        Result := TFWEdit.Create ( acom_Owner )
       else
        Result := TFWDBEdit.Create ( acom_Owner );
    End
  else if as_FieldType = CST_LEON_FIELD_DATE then
    Begin
      if ab_IsLocal then
        Result := TFWDateEdit.Create ( acom_Owner )
       Else
        Result := TFWDBDateEdit.Create ( acom_Owner );
    End
  else if as_FieldType = CST_LEON_FIELD_CHOICE then
    Begin
      if ab_IsLocal then
        Result := TRadioGroup.Create ( acom_Owner )
       Else
        Result := TDBRadioGroup.Create ( acom_Owner );
    End;
end;



// procedure p_GetMarkFunction
// Getting field marks
// anod_Field : Node Field
// as_MarkSearched : Mark searched
// aano_IdNodes : List to add scruted field node
procedure p_CountMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const ab_IsTrue : Boolean; var ai_Count : Integer );
var lnod_FieldProperties : TALXMLNode ;
    li_i : Integer ;
Begin
  if anod_Field.HasChildNodes then
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_MARKS then
          Begin
            if  (         lnod_FieldProperties.HasAttribute ( as_MarkSearched )
                   and (( not ( lnod_FieldProperties.Attributes [ as_MarkSearched ] = CST_LEON_BOOL_FALSE )
                   and ab_IsTrue ))
                or ( ( not lnod_FieldProperties.HasAttribute ( as_MarkSearched )
                       or ( lnod_FieldProperties.Attributes [ as_MarkSearched ] = CST_LEON_BOOL_FALSE ))
                      and not ab_IsTrue )) Then
                inc ( ai_Count );
            Break;
          End;
      End;
End;

// function fb_GetCrossLinkFunction
// getting other side relationships
// as_ParentClass : Orginal class name
// anod_FieldProperties : Node field properties

function fb_GetCrossLinkFunction( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
var lnod_ClassesProperties : TALXMLNode ;
    li_j : Integer;
Begin
  Result := False;
  if ( anod_FieldProperties.NodeName = CST_LEON_CLASSES )
  and anod_FieldProperties.HasChildNodes then
    for li_j :=  0 to anod_FieldProperties.ChildNodes.Count -1 do
    Begin
      lnod_ClassesProperties := anod_FieldProperties.ChildNodes [ li_j ];
      if lnod_ClassesProperties.NodeName = CST_LEON_CLASS_REF  then
        Begin
          if ( as_ParentCLass = '' )
          or ( anod_FieldProperties.Attributes [ CST_LEON_IDREF ] = as_ParentCLass ) Then
            Begin
              Result := True;
            end;
        End;
    End
  else if ( anod_FieldProperties.NodeName = CST_LEON_CLASS )
  and    (   ( as_ParentCLass = '' )
          or ( anod_FieldProperties.Attributes [ CST_LEON_IDREF ] = as_ParentCLass )) Then
    Begin
      Result := True;
    end;
End;

// function fs_GetNodeAttribute
// getting attribute of node
// anod_Node : A node
// as_Attribute : An attribute
function fs_GetNodeAttribute( const anod_Node : TALXMLNode ; const as_Attribute : String ) : String ;
begin
  if anod_Node.HasAttribute ( as_Attribute ) then
    Result := anod_Node.Attributes [ as_Attribute ]
   Else
    Result := '';
end;

// function fnod_GetClassFromRelation
// getting class from XML Node
// anod_Node : Node containing class node
function fnod_GetClassFromRelation( const anod_Node : TALXMLNode ) : TALXMLNode ;
var li_i : Integer ;
    lnod_Node : TALXMLNode;
begin

  Result := nil;
  for li_i := 0 to anod_Node.ChildNodes.Count -1 do
    Begin
      lnod_Node := anod_Node.ChildNodes [ li_i ];
      if ( lnod_Node.NodeName = CST_LEON_CLASSES )
      or ( lnod_Node.NodeName = CST_LEON_CLASS ) Then
        Result := lnod_Node;
    End;
end;

// function fnod_GetNodeFromIdRef
// getting node from idref attributes of node
// anod_Node : Node containing or not containing idref
function fnod_GetNodeFromTemplate( const anod_Node : TALXMLNode ) : TALXMLNode ;
var li_i : Integer ;
    lnod_Node : TALXMLNode;
    ls_Template : String;
begin

  Result := anod_Node;
  if ( anod_Node.Attributes [ CST_LEON_TEMPLATE ] <> Null ) Then
    Begin
      ls_Template := anod_Node.Attributes [ CST_LEON_TEMPLATE ];
      for li_i := 0 to gxdo_RootXML.ChildNodes.Count -1 do
        Begin
          lnod_Node := gxdo_RootXML.ChildNodes [ li_i ];
          if ( lnod_Node.Attributes[CST_LEON_ID] = ls_Template ) Then
            Begin
              Result := lnod_Node;
              Break;
            end;
        End;
    end;
end;

// function fs_getSoftInfo
// getting info directory

function fs_getSoftInfo : String;
Begin
  Result := fs_getSoftFiles + 'info' + DirectorySeparator ;
End;

// function fs_getSoftFiles
// getting files directory
function fs_getSoftFiles : String;
Begin
  Result := fs_getSoftDir + 'files' + DirectorySeparator ;
End;

// function fs_getProjectDir
// getting main directory
function fs_getProjectDir : String;
Begin
  Result := fs_getSoftDir + ExtractFileDir ( gs_ProjectFile ) + DirectorySeparator ;
End;

// function fs_getImagesDir
// getting image directory
function fs_getImagesDir : String;
Begin
  Result := fs_getSoftDir + CST_IMAGES_DIR;
End;

// function fb_LoadXMLFile
// Loading XML File
// axdo_FichierXML : XML document loading
// as_FileXML : XML File Path to set
function fb_LoadXMLFile ( const axdo_FichierXML : TALXMLDocument; const as_FileXML : String ): Boolean;
  function fb_LoadXML (): Boolean;
    Begin
      if not FileExists ( as_FileXML ) Then
        Begin
          ShowMessage ( 'File Not Found : ' + as_FileXML );
          Result := False;
          Exit;
        end;
      try
       axdo_FichierXML.LoadFromFile ( as_FileXML );
      Except
      End;
      Result := axdo_FichierXML.Active;
    End;
Begin
  Result := fb_LoadXML ();
End;


initialization
  GS_Data_Extension := '.res';
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_XML );
{$ENDIF}
end.
