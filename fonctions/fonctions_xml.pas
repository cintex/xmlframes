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
  ALXMLDoc,
  Forms;

const CST_LEON_File_Extension = '.xml';
      CST_LEON_Data_Extension = '.res';
      CST_LEON_DUMMY = 'DUMMY' ;
      CST_LEON_PROJECT = 'PROJECT' ;
      CST_LEON_CLASS = 'CLASS' ;
      CST_LEON_BOOL_FALSE = 'false' ;
      CST_LEON_BOOL_TRUE  = 'true' ;

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
      CST_LEON_FIELD_DATE     = 'DATE' ;
      CST_LEON_FIELD_RELATION = 'RELATION' ;
      CST_LEON_FIELD_TEXT     = 'TEXT' ;
      CST_LEON_FIELD_CHOICE   = 'CHOICE' ;
      CST_LEON_FIELD_FILE     = 'FILE' ;
      CST_LEON_STRUCT         = 'STRUCT' ;
      CST_LEON_ARRAY          = 'ARRAY' ;

      CST_LEON_FIELDS_DEF  : array [0..6] of string = (CST_LEON_FIELD_NUMBER,CST_LEON_FIELD_DATE,CST_LEON_FIELD_RELATION,CST_LEON_FIELD_TEXT,CST_LEON_FIELD_CHOICE,CST_LEON_FIELD_FILE,CST_LEON_STRUCT);


      CST_LEON_FIELD_F_MARKS  = 'F_MARKS' ;
      CST_LEON_FIELD_LOCAL    = 'local' ;
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
              			                 Comment : 'Gestion des donn�es des objets dynamiques du composant Fen�tre principale.' + #13#10 + 'Il comprend une cr�ation de menus' ;
              			                 BugsStory :  'Version 0.9.0.1 : Images Directory.' + #13#10 +
                                                              'Version 0.9.0.0 : Unit functionnal.' + #13#10 +
                                                              'Version 0.1.0.0 : Cr�ation de l''unit�.';
              			                 UnitType : 1 ;
              			                 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 1 );

{$ENDIF}
function fb_LoadXMLFile ( const axdo_FichierXML : TALXMLDocument; const as_FileXML : String ): Boolean;

// XML parameters
var gs_ProjectFile  : String;
    gs_RootEntities : String ;
    gch_SeparatorCSV: Char = '|';
    gs_entities     : String  = 'rootEntities' ;
    gs_Encoding     : String = 'ISO-8859-1';
    gstl_Labels             : TStringlist = nil ;

function fs_getSoftInfo : String;
function fs_getSoftFiles : String;
function fs_GetLabelCaption ( const as_Name : String ):WideString;
function fs_getImagesDir : String;
function fs_getProjectDir : String;
function fs_LeonFilter ( const AString : String ): String;
procedure p_GetMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const aano_IdNodes : TList );
function fb_GetCrossLinkFunction( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
function fs_GetNodeAttribute( const anod_Node : TALXMLNode ; const as_Attribute : String ) : String ;
function fnod_GetClassFromRelation( const anod_Node : TALXMLNode ) : TALXMLNode ;


implementation

uses StrUtils, fonctions_init, u_multidonnees, fonctions_string, Dialogs;

// function fs_GetLabelCaption
// Getting label caption from name
// Name of caption
function fs_GetLabelCaption ( const as_Name : String ):WideString;
Begin
  Result  := gstl_Labels.Values [ as_Name ];
  if ( Result = '' ) then
    Result := as_Name ;
End;

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
            and not ( lnod_FieldProperties.Attributes [ as_MarkSearched ] = CST_LEON_BOOL_FALSE )  then
              Begin
                aano_IdNOdes.Add ( anod_Field );
              End;
            Break;
          End;
      End;
End;

// function fb_GetCrossLinkFunction
// getting other side relationships
// as_ParentClass : Orginal class name
// anod_FieldProperties : Node field properties

function fb_GetCrossLinkFunction( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
var lnod_FieldProperties   ,
    lnod_ClassesProperties : TALXMLNode ;
    li_i , li_j : Integer;
Begin
  Result := False;
  if ( anod_FieldProperties.NodeName = CST_LEON_CLASSES )
  and anod_FieldProperties.HasChildNodes then
    for li_j :=  0 to anod_FieldProperties.ChildNodes.Count -1 do
    Begin
      lnod_ClassesProperties := anod_FieldProperties.ChildNodes [ li_i ];
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
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_XML );
{$ENDIF}
finalization
  gstl_Labels.Free;
end.
