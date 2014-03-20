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
  DB,
  fonctions_manbase,
  Forms;
type
  TOnExecuteNode = procedure ( const ADBSources : TFWTables; const ANode : TALXMLNode );
  TOnExecuteFieldNode = procedure ( const ADBSources : TFWTables;
                                    const ADBSource  : TFWTable;
                                    const ANode : TALXMLNode ;
                                    var ab_FieldFound, ab_column : Boolean ;
                                    var   ai_Fieldcounter : Longint );


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
      gs_LeonardiSubDir : String = '';

const CST_LEON_File_Extension = '.xml';
      {$IFDEF VERSIONS}
        gver_fonctions_XML : T_Version = ( Component : 'Librairie de fonctions XML' ;
                                           FileUnit : 'fonctions_xml' ;
                    			                 Owner : 'Matthieu Giroux' ;
                    			                 Comment : 'XML Form and SQL creating Functions. No XML Form in this unit.' + #13#10 +
                                                                 'Il ne doit pas y avoir de lien vers les objets à créer.' ;
                    			                 BugsStory :'Version 0.9.9.0 : centralising SQL Creating functions.' + #13#10 +
                                                                    'Version 0.9.0.2 : centralising searching on xml nodes.' + #13#10 +
                                                                    'Version 0.9.0.1 : Images Directory.' + #13#10 +
                                                                    'Version 0.9.0.0 : Unit functionnal.' + #13#10 +
                                                                    'Version 0.1.0.0 : Création de l''unité.';
                    			                 UnitType : 1 ;
                    			                 Major : 0 ; Minor : 9 ; Release : 9 ; Build : 0 );

      {$ENDIF}

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
      CST_LEON_SYSTEM          = 'SYSTEM';
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
      CST_LEON_DATA_POSTGRES = '.postgres' ;
      CST_LEON_DATA_SQLSERVER= '.mssql.' ;
      CST_LEON_DATA_ORACLE   = '.oracle.' ;
      CST_LEON_DATA_SQLLITE  = '.sqllite.' ;

      CST_LEON_DRIVER_MYSQL    = 'mysql-5' ;
      CST_LEON_DRIVER_FIREBIRD = 'firebird-2.1' ;
      CST_LEON_DRIVER_POSTGRES = 'postgresql-8' ;
      CST_LEON_DRIVER_SQLSERVER= 'mssql' ;
      CST_LEON_DRIVER_SQLLITE  = 'sqllite' ;
      CST_LEON_DRIVER_ORACLE   = 'oracle-9i' ;

      CST_LEON_FIELD_LOCAL    = 'local' ;

      CST_LEON_FIELDS = 'FIELDS' ;
      CST_LEON_FIELD_id = 'id' ;
      CST_LEON_FIELD_TIP   = 'TIP' ;
      CST_LEON_FIELD_NCOLS = 'NCOLS' ;
      CST_LEON_FIELD_NCHARS= 'NCHARS' ;
      CST_LEON_FIELD_MIN   = 'MIN' ;
      CST_LEON_FIELD_MAX   = 'MAX' ;
      CST_LEON_FIELD_NROWS = 'NROWS' ;

      CST_LEON_IDREFs = 'idrefs';
      CST_LEON_CLASS_REF    = 'CLASS_REF';
      CST_LEON_CLASSES      = 'CLASSES';
      CST_LEON_CLASS_C_BIND   = 'C_BIND';
      CST_LEON_CLASS_C_MARKS  = 'C_MARKS' ;

      CST_LEON_CHOICE_OPTIONS = 'OPTIONS' ;
      CST_LEON_CHOICE_OPTION  = 'OPTION' ;
      CST_LEON_OPTION_NAME    = 'name' ;
      CST_LEON_OPTION_VALUE   = 'value' ;
      CST_LEON_OPTION_DEFAULT = 'default' ;

      CST_LEON_FIELD_NUMBER   = 'NUMBER' ;
      CST_LEON_FIELD_TYPE     = 'type' ;
      CST_LEON_FIELD_COMPOSITION = 'COMPOSITION' ;
      CST_LEON_FIELD_DOUBLE   = 'DOUBLE' ;
      CST_LEON_FIELD_DECIMALS = 'DECIMALS' ;
      CST_LEON_FIELD_DATE     = 'DATE' ;
      CST_LEON_FIELD_TEXT     = 'TEXT' ;
      CST_LEON_FIELD_CHOICE   = 'CHOICE' ;
      CST_LEON_FIELD_FILE     = 'FILE' ;
      CST_LEON_STRUCT         = 'STRUCT' ;
      CST_LEON_ARRAY          = 'ARRAY' ;

      CST_LEON_RELATION       = 'RELATION' ;
      CST_LEON_RELATION_JOIN  = 'JOIN_DAEMON' ;

      CST_LEON_FIELDS_DEF  : array [0..6] of string = (CST_LEON_FIELD_NUMBER,CST_LEON_FIELD_DATE,CST_LEON_RELATION,CST_LEON_FIELD_TEXT,CST_LEON_FIELD_CHOICE,CST_LEON_FIELD_FILE,CST_LEON_STRUCT);


      CST_LEON_FIELD_F_MARKS  = 'F_MARKS' ;
      CST_LEON_FIELD_F_BIND   = 'F_BIND' ;
      CST_LEON_FIELD_CREATE   = 'create' ;
      CST_LEON_FIELD_PROVIDER = 'providerValue' ;
      CST_LEON_FIELD_DEFAULT  = 'N_DEFAULT' ;
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
      CST_LEON_ACTIONS = 'ACTIONS' ;
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
      CST_LEON_ENTITY = '!ENTITY ';

      CST_XMLFRAMES_ROOT_FORM_CLEP = 'rootentitie' ;

      CST_COMBO_FIELD_SEPARATOR    = ',' ;

function fb_LoadXMLFile ( const axdo_FichierXML : TALXMLDocument; const as_FileXML : String ): Boolean;
function fs_getLeonDir :String ;
function fs_getLeonInfo : String;
function fs_getLeonFiles : String;
function fs_getImagesDir : String;
function fs_getProjectDir : String;
function fs_LeonFilter ( const AString : String ): String;
function fb_GetMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const aff_FieldNodes : TFWMiniFieldColumns ):Boolean;
procedure p_CountMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const ab_IsTrue : Boolean;  var ai_Count : Integer );
function fb_GetCrossLinkNode( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
function fs_GetNodeAttribute( const anod_Node : TALXMLNode ; const as_Attribute : String ) : String ;
function fnod_GetClassFromRelation( const anod_Node : TALXMLNode ) : TALXMLNode ;
function fnod_GetNodeFromTemplate( const anod_Node : TALXMLNode ) : TALXMLNode ;

function fs_GetIdAttribute ( const anode : TALXMLNode ) : String;
function fb_getFieldOptions ( const afws_Source : TFWTable;
                              const anod_Field,anod_FieldProperties : TALXMLNode ;
                              const affd_ColumnFieldDef : TFWFieldColumn;
                              var   ab_isLocal : Boolean ;
                              const ab_isReference : Boolean = True ): Boolean;
function fb_getOptionalStructTable ( const afwt_Sources : TFWTables;
                                     const afwt_Source : TFWTable;
                                     var   afwt_Source2 : TFWTable;
                                     const affd_ColumnFieldDef : TFWFieldColumn;
                                     const anod_Field,anod_OriginalNode : TALXMLNode;
                                     const ab_createDS : Boolean = True ): Boolean;
function  fb_setFieldType ( const afws_Source : TFWTable ;
                            const af_FieldDefs : TFWFieldColumn;
                            const anod_Field : TALXMLNode;
                            const ai_counter : Integer;
                            const ab_createDS : Boolean;
                            const ab_FullTable : Boolean;
                            const acom_Owner : TComponent;
                            var   ab_isrelation : Boolean;
                            const ab_isreference : Boolean=True;
                            const ab_passIfNotId : Boolean = False;
                            const as_fieldname   : String = ''): Boolean;
function fb_setNodeField ( const anod_Field : TALXMLNode;
                           const affd_ColumnFieldDef : TFWMiniFieldColumn;
                           const ab_isreference : Boolean = True):Boolean;
procedure p_setNodesField ( const anod_FieldProperty : TALXMLNode;
                            const affd_ColumnFieldDef : TFWMiniFieldColumn;
                            const ab_isreference : Boolean = True);
function fb_getNodesField ( const anod_FieldProperty : TALXMLNode;
                            const ab_isreference : Boolean = True):Boolean;
procedure p_setNodeId ( const anod_FieldIsId : TALXMLNode;
                        const afws_Source : TFWTable ;
                        const affd_ColumnFieldDef : TFWMiniFieldColumn  );
procedure p_OnCreateFieldProperties ( const ADBSources : TFWTables; const ADBSource : TFWTable;
                                      const anod_Field: TALXMLNode;
                                      var ab_FieldFound, ab_column : Boolean ;
                                      var   ai_Fieldcounter : Longint  );
function fb_OpenClass ( const as_XMLClass : String ; const acom_owner : TComponent ;
                        var axml_SourceFile : TALXMLDocument ):Boolean;
function fb_createFieldID ( const ab_IsSourceTable : Boolean; const anod_Field: TALXMLNode ;
                            const affd_ColumnFieldDef : TFWFieldColumn;
                            const ai_Fieldcounter : Integer ):Boolean;
procedure p_SetFieldSelect ( const affd_ColumnFieldDef : TFWFieldColumn; const ab_IsLocal : Boolean  );
procedure p_CreateComponents ( const ADBSources : TFWTables ; const as_XMLClass, as_Name : String ;
                               const acom_owner : TComponent; const awin_Parent : TWinControl;
                               const axml_SourceFile : TALXMLDocument ;
                               const ae_OnFieldNode, ae_onActionNode : TOnExecuteFieldNode ;
                               const ae_onClassNameNode : TOnExecuteNode;
                               const ab_CreateDS : Boolean = True ;
                               const ab_ContinueIfLocal : Boolean = False);
function fb_GetCrossLinkFunction( const ADBSources : TFWTables ;
                                  const ADBSource : TFWTable ;
                                  const Aff_field : TFWFieldColumn ;
                                  const as_FunctionClep :String;
                                        as_Table : String; const arel_Relation : TFWRelation;
                                  const ab_createDS, ab_FullTable : Boolean;
                                  const acom_Owner : TComponent ): Boolean ;
function fb_FieldTypeProperties ( const afws_Source : TFWTable ;
                                  var   afr_Relation : TFWRelation;
                                  const anod_Field,anod_FieldProperties : TALXMLNode;
                                  const af_FieldDefs : TFWFieldColumn; var ab_islarge : Boolean;
                                  const ab_createDS, ab_FullTable : Boolean; const acom_Owner : TComponent):Boolean;

implementation

uses fonctions_init,
{$IFDEF FPC}
     FileUtil,
{$ELSE}
     Variants, StrUtils,
{$ENDIF}
     fonctions_Dialogs,
     ExtCtrls,
     u_multidata,
     u_multidonnees,
     fonctions_system,
     DbCtrls;

function fs_getLeonDir :String ;
Begin
  Result:=fs_getAppDir+gs_LeonardiSubDir;
end;


// function fb_createFieldID
// create and init a field from XML
function fb_createFieldID ( const ab_IsSourceTable : Boolean; const anod_Field: TALXMLNode ;
                            const affd_ColumnFieldDef : TFWFieldColumn;
                            const ai_Fieldcounter : Integer ):Boolean;
Begin
  Result := fb_setNodeField(anod_Field,affd_ColumnFieldDef);
  if result Then
    with affd_ColumnFieldDef do
      begin
        IsSourceTable := ab_IsSourceTable;
        NumTag      := ai_Fieldcounter + 1;
        ShowSearch  := -1;
        ColSelect:=False;
      end;
end;

// function fb_OpenClass
// Opens a class file from class name
// Returns true if ok
function fb_OpenClass ( const as_XMLClass : String ; const acom_owner : TComponent ;
                        var axml_SourceFile : TALXMLDocument ):Boolean;
var ls_ProjectFile : String ;
begin
  Result := False;
  if not assigned ( axml_SourceFile ) Then
    axml_SourceFile := TALXMLDocument.Create ( acom_owner );
  ls_ProjectFile := fs_getProjectDir ( ) + as_XMLClass + CST_LEON_File_Extension;
  // For actions at the end of xml file
  If ( FileExistsUTF8 ( ls_ProjectFile )) Then
   // reading the special XML form File
    try
      if fb_LoadXMLFile ( axml_SourceFile, ls_ProjectFile ) Then
         Result := True;
    Except
      On E: Exception do
        Begin
          MyShowMessage ( 'Erreur opening XML Class File : ' + E.Message );
        End;
    End ;

end;


// procedure p_OnCreateFieldProperties
// Creating the column components
// as_Table : Table Name
// anod_Field: Node field
// ai_FieldCounter : Field counter
//  ai_Counter : Column counter
// awin_Parent : Parent component
// ab_Column : Second editing column
// afws_Source : XML form Column
// afd_FieldsDefs : Field Definitions
procedure p_OnCreateFieldProperties ( const ADBSources : TFWTables; const ADBSource : TFWTable;
                                      const anod_Field: TALXMLNode;
                                      var ab_FieldFound, ab_column : Boolean ;
                                      var   ai_Fieldcounter : Longint  );
var lb_IsLocal,lb_relation  : Boolean;
    lffd_ColumnFieldDef : TFWFieldColumn;
    lnod_OriginalNode : TALXmlNode;


    // procedure p_CreateArrayStructComponents
    // Creating groupbox with controls
    procedure p_CreateArrayStructComponents ;
    var li_k, li_l, li_FieldCounter : LongInt ;
        lb_column : Boolean;
        lfwt_Source2 : TFWTable;
        lnod_FieldsNode,lnod_FieldsChildNode : TALXmlNode;
    begin
      lb_IsLocal := False;
      lnod_OriginalNode := fnod_GetNodeFromTemplate(anod_Field);
      lfwt_Source2 := nil;
      if anod_Field <> lnod_OriginalNode Then
        Begin
         if fb_getOptionalStructTable ( ADBSources,ADBSource,lfwt_Source2,lffd_ColumnFieldDef,anod_Field,lnod_OriginalNode, False )
          Then
            Exit;

         li_FieldCounter := 0 ;
        end;

      if lnod_OriginalNode.HasChildNodes then
        for li_k := 0 to lnod_OriginalNode.ChildNodes.Count - 1 do
          Begin
            lnod_FieldsNode := lnod_OriginalNode.ChildNodes [ li_k ];
            if lnod_FieldsNode.NodeName = CST_LEON_NAME then
                Continue;
            if (   lnod_OriginalNode.NodeName = CST_LEON_STRUCT )
            and lnod_OriginalNode.ChildNodes [ li_k ].HasChildNodes then
              Begin
                lb_column := False;
                if lnod_FieldsNode.NodeName = CST_LEON_FIELDS Then
                  Begin
                    for li_l := 0 to lnod_FieldsNode.ChildNodes.Count - 1 do
                      Begin
                        lnod_FieldsChildNode := lnod_FieldsNode.ChildNodes [ li_l ];
                        if anod_Field = lnod_OriginalNode Then
                          p_OnCreateFieldProperties ( ADBSources, ADBSource,
                                                    lnod_FieldsChildNode,
                                                    ab_FieldFound, lb_column,
                                                    ai_Fieldcounter)
                         else
                          p_OnCreateFieldProperties ( ADBSources, lfwt_Source2,
                                                    lnod_FieldsChildNode,
                                                    ab_FieldFound, lb_column,
                                                    li_FieldCounter);
                      end;
                  end
                 Else
                  // The parent parameter is a var : so do not want to change it in the function
                  if anod_Field = lnod_OriginalNode Then
                    p_OnCreateFieldProperties ( ADBSources, ADBSource,
                                              lnod_FieldsNode,
                                              ab_FieldFound, lb_column,
                                              ai_FieldCounter)
                   else
                    p_OnCreateFieldProperties ( ADBSources, lfwt_Source2,
                                              lnod_FieldsNode,
                                              ab_FieldFound, lb_column,
                                              li_FieldCounter);
                lb_IsLocal:=True;
              end;
          end;
      if anod_Field <> lnod_OriginalNode Then
        lffd_ColumnFieldDef.Assign(lfwt_Source2.FieldsDefs.FieldByName(lfwt_Source2.GetKey.Items [0].FieldName));
      p_SetFieldSelect( lffd_ColumnFieldDef, lb_IsLocal);
    end;

    var li_i : LongInt ;

begin
  if    anod_Field.HasAttribute(CST_LEON_FIELD_TYPE)  // compositions are not yet supported
  and ( anod_Field.Attributes[CST_LEON_FIELD_TYPE] = CST_LEON_FIELD_COMPOSITION ) Then
    Exit;
  ab_Column:=False;
  // Creating the properties and setting data link

   lffd_ColumnFieldDef := ADBSource.FieldsDefs.Add;
   if //( anod_Field.NodeName = CST_LEON_ARRAY ) // to do
    ( anod_Field.NodeName = CST_LEON_STRUCT )
    Then
     Begin
       p_CreateArrayStructComponents;
       fb_setNodeField (anod_Field,lffd_ColumnFieldDef);
       // Quitting because having created properties
       Exit;
     end;
   li_i := 0;
   lb_relation:=False;
   if not fb_createFieldID ( True, anod_Field, lffd_ColumnFieldDef, ai_Fieldcounter )
   or fb_setFieldType(ADBSource,lffd_ColumnFieldDef,anod_Field,li_i,False,True,nil,lb_relation)
    Then
     ADBSource.FieldsDefs.Delete(lffd_ColumnFieldDef.Index)
    Else
      inc ( ai_Fieldcounter );
end;

////////////////////////////////////////////////////////////////////////////////
// function fdoc_GetCrossLinkFunction
// Getting over side link of relationships
// as_FunctionClep    : String
// as_Table           : Table name and class name
// as_connection      : connect link key
// aanod_idRelation   : List to add link
// anod_NodeCrossLink : linked node in other file
////////////////////////////////////////////////////////////////////////////////
function fb_GetCrossLinkFunction( const ADBSources : TFWTables ;
                                  const ADBSource : TFWTable ;
                                  const Aff_field : TFWFieldColumn ;
                                  const as_FunctionClep :String;
                                        as_Table : String; const arel_Relation : TFWRelation;
                                  const ab_createDS, ab_FullTable : Boolean;
                                  const acom_Owner : TComponent ): Boolean ;
var li_i , li_j, li_k: Integer ;
    lnod_ClassProperties, lnod_id : TALXMLNode ;
    lnod_Node, lnod_NodeCrossLink : TALXMLNode;
    ls_ProjectFile ,
    ls_table       : String;
    li_FullFields ,
    li_CountFields : Integer;
    lds_Connection : TDSSource;
    lb_Column,
    lb_Relation,
    lb_fieldfound : Boolean;
    lfwt_Source,lfwt_Source2 : TFWTable;
    laxd_Document :TALXMLDocument;
begin
  laxd_Document := TALXMLDocument.Create ( Application );
  try
    ls_ProjectFile := fs_getProjectDir ( ) + as_Table + CST_LEON_File_Extension;
    Result := FileExistsUTF8 ( ls_ProjectFile );
    if Result Then
      try
        if fb_LoadXMLFile ( laxd_Document, ls_ProjectFile ) Then
         with laxd_Document do
          Begin
            lnod_NodeCrossLink := nil;
            lb_Column := False;
            for li_i := 0 to ChildNodes.Count -1 do
              Begin
                lnod_Node := ChildNodes [ li_i ];
                if not assigned ( lnod_NodeCrossLink )
                // search cross link node
                and fb_GetCrossLinkNode(as_FunctionClep,lnod_Node ) Then
                  lnod_NodeCrossLink := lnod_Node;
                if lnod_Node.NodeName = CST_LEON_CLASS then
                 with arel_Relation do
                  Begin
                    for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
                      Begin
                        lnod_ClassProperties := lnod_Node.ChildNodes [ li_j ];
                        if lnod_ClassProperties.NodeName = CST_LEON_CLASS_C_BIND Then
                          Begin
                           ls_table:=trim(lnod_ClassProperties.Attributes [ CST_LEON_VALUE ]);
                           if ls_table='' Then
                             ls_table:=as_Table;
                           if ab_FullTable Then
                            Begin
                             lfwt_Source2 := ADBSources.TableByName(ls_table);
                             if lfwt_Source2 = nil
                              Then
                               Begin // not found : create every tables
                                //      MyShowMessage(ls_Table + ' relation');
                                lfwt_Source2 := ADBSources.Add;
                                lfwt_Source2.Table:= ls_table;
                                lfwt_Source2.TableKey:= as_Table;
                                lfwt_Source2.IsMain := True
                               end
                               // found : recreate uneeded
                              Else lfwt_Source2 := nil;
                            End;
                           // create relation table
                           lfwt_Source := TablesDest.Add;
                           with lfwt_Source do
                            Begin
                              Table:= ls_table;
                              TableKey:= as_Table;
                              if ab_createDS Then
                               Begin
                                 MyShowMessage(Table+ '_' +IntToStr ( ADBSources.Count - 1 ) +'_' + IntToStr ( arel_Relation.Index ));
                                lds_Connection:=DMModuleSources.fds_FindConnection( lnod_ClassProperties.Attributes [ CST_LEON_LOCATION ], True );
                                with lds_Connection do
                                  Datasource := fds_CreateDataSourceAndTable ( Table, '_' +IntToStr ( ADBSources.Count - 1 ) +'_' + IntToStr ( arel_Relation.Index ),
                                                       IntToStr ( ADBSources.Count - 1 ), DatasetType, QueryCopy, acom_Owner);
                               end;
                            end;
                           as_Table:=ls_table;
                          end;
                        if  ( lnod_ClassProperties.NodeName = CST_LEON_FIELDS ) then
                          Begin
                            lb_Column:=False;
                            lb_fieldfound:=False;
                            li_CountFields := 0 ;
                            li_FullFields:=0;
                            for li_k := 0 to lnod_ClassProperties.ChildNodes.Count -1 do
                              Begin
                                lnod_id := lnod_ClassProperties.ChildNodes [ li_k ];
                                if ab_FullTable and Assigned(lfwt_Source2) Then
                                 Begin  // create every tables if demanded
                                  lb_fieldfound := True;
                                  p_OnCreateFieldProperties(ADBSources,lfwt_Source2,lnod_id,lb_fieldfound,lb_Column,li_FullFields);
                                 End;
                                lb_Relation:=False;
                                if fb_GetMarkFunction(lnod_id, CST_LEON_FIELD_id, FieldsFK ) Then
                                   fb_setFieldType(ADBSource, Aff_field, lnod_id, Aff_field.Index,False,ab_FullTable,nil,lb_Relation, False );
                                fb_GetMarkFunction(lnod_id, CST_LEON_FIELD_main, FieldsDisplay );
                                p_CountMarkFunction(lnod_id, CST_LEON_FIELD_optional, False, li_CountFields );
                              End;
                          End;
                      End;
                  End;
              End;
          End;
      Except
        On E: Exception do
          Begin
            MyShowMessage ( 'Error : ' + E.Message );
          End;
      End;
  finally
    laxd_Document.Destroy;
  end;
end;

// procedure p_CreateFormComponents
// Create a form from XML File
// as_XMLFile : XML File
// as_Name : Name of form
// awin_Parent : Parent component
// ai_Counter : The column counter for other XML File
procedure p_CreateComponents ( const ADBSources : TFWTables ; const as_XMLClass, as_Name : String ;
                               const acom_owner : TComponent; const awin_Parent : TWinControl;
                               const axml_SourceFile : TALXMLDocument ;
                               const ae_OnFieldNode, ae_onActionNode : TOnExecuteFieldNode ;
                               const ae_onClassNameNode : TOnExecuteNode;
                               const ab_CreateDS : Boolean = True ;
                               const ab_ContinueIfLocal : Boolean = False);
var li_i, li_j, li_k, li_NoField : LongInt ;
    lnod_Node, lnod_ClassNode : TALXMLNode ;
    lb_Column, lb_FieldFound, lb_Table : Boolean ;
    lxml_Class : TALXMLDocument ;
    lfwc_Column : TFWTable ;
  // procedure p_CreateXMLColumn
  // Creates the XML form column
  // as_Table : Table name
  // as_Connection : Connection name
  procedure p_CreateXMLColumn ( const as_Table, as_TableKey, as_Connection : String );
  Begin
    if ab_CreateDS or not Assigned(ADBSources.TableByName(as_Table)) Then
     Begin
     // MyShowMessage(as_Table + ' xmlcolumn');
      lfwc_Column := ffws_CreateSource ( ADBSources, as_Connection, as_Table, as_Connection, acom_owner, ab_CreateDS );
      lfwc_Column.IsMain:=True;
     end;
  end;

begin
  lxml_Class := nil;
  If fb_OpenClass ( as_XMLClass, acom_owner, lxml_Class ) Then
   // reading the special XML form File
    try
      li_NoField := 0;
      lb_FieldFound := False;
      lb_Column := False;
      for li_i := 0 to lxml_Class.ChildNodes.Count -1 do
        Begin
          lnod_Node := lxml_Class.ChildNodes [ li_i ];
          if ( lnod_Node.NodeName = CST_LEON_CLASS  )
          or ( lnod_Node.NodeName = CST_LEON_STRUCT ) then
            Begin
              if not lb_FieldFound Then
                Begin
                  lb_Table:=False;
                  for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
                    Begin
                      lnod_ClassNode:=lnod_Node.ChildNodes [ li_j ];
                      if lnod_ClassNode.NodeName = CST_LEON_CLASS_C_MARKS Then
                       if not ab_ContinueIfLocal Then
                         if lnod_ClassNode.HasAttribute(CST_LEON_FIELD_LOCAL)
                         and (lnod_ClassNode.Attributes[CST_LEON_FIELD_LOCAL]=CST_LEON_BOOL_TRUE)
                          Then
                           Exit;

                      if lnod_ClassNode.NodeName = CST_LEON_CLASS_C_BIND Then
                       with lnod_ClassNode do
                        Begin
                          p_CreateXMLColumn (Attributes [ CST_LEON_VALUE ], lnod_Node.Attributes [ CST_LEON_ID ], Attributes [ CST_LEON_LOCATION ]);
                          lb_Table := True;
                          Break;
                        end;
                    end;
                  if not lb_Table Then
                    p_CreateXMLColumn ( lnod_Node.Attributes [ CST_LEON_ID ], lnod_Node.Attributes [ CST_LEON_ID ], '' );
                end;
              for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
               Begin
                lnod_ClassNode:=lnod_Node.ChildNodes [ li_j ];
                if ( lnod_ClassNode.NodeName = CST_LEON_FIELDS  )
                and lnod_ClassNode.HasChildNodes then
                 for li_k := 0 to lnod_ClassNode.ChildNodes.Count-1 do
                  Begin
                    if Assigned(ae_OnFieldNode) Then
                     ae_OnFieldNode ( ADBSources,lfwc_Column, lnod_ClassNode.ChildNodes [ li_k ], lb_FieldFound, lb_Column, li_NoField);

                  End;
                 if ( lnod_ClassNode.NodeName = CST_LEON_ACTIONS  ) Then
                   if Assigned(ae_onActionNode) Then
                    ae_onActionNode ( ADBSources, lfwc_Column, lnod_ClassNode, lb_FieldFound, lb_Column, li_NoField );
                 if ( lnod_ClassNode.NodeName = CST_LEON_NAME  ) Then
                   if Assigned(ae_onClassNameNode) Then
                    ae_onClassNameNode ( ADBSources, lnod_ClassNode );
               end;
            End;
        End;
    finally
      lxml_Class.Destroy;
    End ;

end;


// procedure p_setNodeField
// set TFWTable Field name
function fb_setNodeField ( const anod_Field : TALXMLNode;
                           const affd_ColumnFieldDef : TFWMiniFieldColumn;
                           const ab_isreference : Boolean = True):Boolean;
Begin
  Result:=False;
   with affd_ColumnFieldDef,anod_Field do
    Begin
      if Attributes [CST_LEON_NAME] <> Null Then
        CaptionName := Attributes [CST_LEON_NAME];
      Result:=Attributes [CST_LEON_ID] <> Null;
      if ab_isreference and Result Then
       Begin
        FieldName := Attributes [CST_LEON_ID];
       end;
    End;
end;

// procedure p_setNodeField
// set TFWTable Field name
procedure p_setNodesField ( const anod_FieldProperty : TALXMLNode;
                            const affd_ColumnFieldDef : TFWMiniFieldColumn;
                            const ab_isreference : Boolean = True);
Begin
  if Assigned ( affd_ColumnFieldDef ) Then
  with affd_ColumnFieldDef,anod_FieldProperty do
   Begin
      if NodeName=CST_LEON_NAME Then
        CaptionName := Attributes [CST_LEON_VALUE];
      if ab_isreference and (NodeName = CST_LEON_FIELD_F_BIND) Then
        FieldName := Attributes [CST_LEON_VALUE];
    End;
end;

// procedure p_setNodeField
// set TFWTable Field name
function fb_getNodesField ( const anod_FieldProperty : TALXMLNode;
                            const ab_isreference : Boolean = True):Boolean;
Begin
  Result := anod_FieldProperty.NodeName = CST_LEON_FIELD_F_BIND;
end;

// procedure p_setNodeId
// set TFWTable key
procedure p_setNodeId ( const anod_FieldIsId : TALXMLNode;
                        const afws_Source : TFWTable ;
                        const affd_ColumnFieldDef : TFWMiniFieldColumn );
Begin
   with affd_ColumnFieldDef do
    if assigned ( afws_Source )
    and anod_FieldIsId.HasAttribute ( CST_LEON_ID )
    and not ( anod_FieldIsId.Attributes [ CST_LEON_ID ] = CST_LEON_BOOL_FALSE )
    and (afws_Source.GetKey.FieldByName(FieldName)=nil)
     then
      with afws_Source.GetKey.Add do
       Begin
        FieldName := affd_ColumnFieldDef.FieldName;
       end;
end;


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


////////////////////////////////////////////////////////////////////////////////
// procedure p_setFieldDefs
// getting CSV definitions and adding them from file
// adat_Dataset : CSV dataset
// alis_NodeFields : node of field nodes
////////////////////////////////////////////////////////////////////////////////


// function fs_LeonFilter
// special words replacing
// AString : Leon string
function fs_LeonFilter ( const AString : String ): String;
Begin
  Result := StringReplace ( AString, CST_LEON_DIR+DirectorySeparator, fs_getLeonDir, [rfReplaceAll] );
  Result := StringReplace ( AString, CST_LEON_DIR, fs_getLeonDir, [rfReplaceAll] );
End;

// procedure fb_GetMarkFunction
// Getting field marks
// anod_Field : Node Field
// as_MarkSearched : Mark searched
// aano_IdNodes : List to add scruted field node
function fb_GetMarkFunction(const anod_Field :TALXMLNode ; const as_MarkSearched : String ; const aff_FieldNodes : TFWMiniFieldColumns ):Boolean;
var lnod_FieldProperties  ,
    lnod_FieldPropertiesTemp : TALXMLNode ;
    lff_Field : TFWMiniFieldColumn;
    li_i : Integer ;
Begin
  Result:=False;
  lnod_FieldPropertiesTemp:=nil;
  if anod_Field.HasChildNodes then
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if fb_getNodesField(lnod_FieldProperties) Then
         Begin
          lnod_FieldPropertiesTemp:=lnod_FieldProperties;
          if Assigned(aff_FieldNodes.FieldByName(lnod_FieldPropertiesTemp.Attributes[CST_LEON_VALUE])) Then
           Exit;
         end;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_MARKS then
          Begin
            if (lnod_FieldPropertiesTemp=nil)
            and Assigned(aff_FieldNodes.FieldByName(anod_Field.Attributes[CST_LEON_ID])) Then
              Exit;
            if lnod_FieldProperties.HasAttribute ( as_MarkSearched )
            and ( lnod_FieldProperties.Attributes [ as_MarkSearched ] <> CST_LEON_BOOL_FALSE )
            and (  not lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_LOCAL )
                  or ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_LOCAL ] = CST_LEON_BOOL_FALSE )) then
             Begin
               lff_Field := aff_FieldNodes.Add;
               if Assigned(lnod_FieldPropertiesTemp) Then
                p_setNodesField(lnod_FieldPropertiesTemp,lff_Field);
               fb_setNodeField(anod_Field,lff_Field);
               Result:=True;
             end;
            Break;
          End;
      End;
End;

// search for relation and recursive create
function fb_FieldTypeRelation ( const afws_Source : TFWTable ;
                                var   afr_Relation : TFWRelation;
                                const anod_Field,anod_FieldProperties : TALXMLNode;
                                const af_FieldDefs : TFWFieldColumn;
                                const ab_createDS, ab_FullTable : Boolean;
                                const acom_Owner : TComponent):Boolean;
var lnod_FieldProperties : TALXMLNode;
    li_i : Integer;
    ls_ClassLink : String;
Begin
  if ( anod_Field.NodeName = CST_LEON_RELATION )
    Then Result:=True
    Else
     Begin
      Result:=False;
      Exit;
     End;
  // when there is no datasource created and no SQL table creation
//  if not ab_createDS and not ab_FullTable then
//   Exit; //quit bcause not needed
  // miltiple fields relation
  if  anod_FieldProperties.NodeName = CST_LEON_RELATION_JOIN Then
   Begin
    for li_i := 0 to anod_FieldProperties.ChildNodes.Count-1 do
      Begin
        lnod_FieldProperties := anod_FieldProperties.ChildNodes [ li_i ];
        if lnod_FieldProperties.NodeName = CST_LEON_CLASS_C_BIND Then
         Begin
           afr_Relation := afws_Source.Relations.Add;
           // grouping table
           with afr_Relation.TablesDest.Add do
             Begin
               Table:=fs_GetNodeAttribute( lnod_FieldProperties, CST_LEON_VALUE );
               // table can be on other database
               ls_ClassLink:=fs_GetNodeAttribute( lnod_FieldProperties, CST_LEON_LOCATION );
               if ls_ClassLink > ''
                Then Connection:=DMModuleSources.fds_FindConnection( ls_ClassLink, True )
                Else Connection:=afws_Source.Connection;
               TableKey:=Table;
             end;
         end;
        // ordered relation fields
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_BIND Then
           afr_Relation.FieldsFK.Add.FieldName:=fs_GetNodeAttribute( lnod_FieldProperties, CST_LEON_VALUE );
      end;

   end;
  if  anod_FieldProperties.NodeName = CST_LEON_NAME Then
   Begin
     if afr_Relation = nil Then
      afr_Relation := af_FieldDefs.Relation;
     afr_Relation.RelationName:=anod_FieldProperties.Attributes[CST_LEON_VALUE];
   end;
  ls_ClassLink:=''; // init
  if (  ( anod_FieldProperties.NodeName = CST_LEON_CLASSES )
     or ( anod_FieldProperties.NodeName = CST_LEON_CLASS ))
   Then
    Begin
     // Getting other class
      if ( ls_ClassLink = '' ) then
        ls_ClassLink := fs_GetNodeAttribute( anod_FieldProperties, CST_LEON_IDREFs );
      if ( ls_ClassLink = '' ) then
        ls_ClassLink := fs_GetNodeAttribute( anod_FieldProperties, CST_LEON_IDREF );
      // Getting the class finally
      if ( ls_ClassLink = '' ) then
        ls_ClassLink := fs_GetNodeAttribute( anod_FieldProperties, CST_LEON_ID );
      if ( ls_ClassLink = '' ) and anod_FieldProperties.HasChildNodes then
       for li_i := 0 to anod_FieldProperties.ChildNodes.Count-1 do
         Begin
           lnod_FieldProperties := anod_FieldProperties.ChildNodes [ li_i ];
           if lnod_FieldProperties.NodeName = CST_LEON_CLASS_REF Then
            Begin
              ls_ClassLink:=fs_GetNodeAttribute( lnod_FieldProperties, CST_LEON_IDREF );
              Break;
            end;
         end;
      fb_GetCrossLinkFunction( afws_Source.Collection as TFWTables,afws_Source, af_FieldDefs,'', ls_ClassLink, afr_Relation, ab_createDS, ab_FullTable, acom_Owner );
   End;
end;

// retrieve each properties of fields XML Node
// Return True if relationships found
function fb_FieldTypeProperties ( const afws_Source : TFWTable ;
                                  var   afr_Relation : TFWRelation;
                                  const anod_Field,anod_FieldProperties : TALXMLNode;
                                  const af_FieldDefs : TFWFieldColumn; var ab_islarge : Boolean;
                                  const ab_createDS, ab_FullTable : Boolean; const acom_Owner : TComponent):Boolean;
var ldo_Temp : Double;
Begin
  with af_FieldDefs do
   Begin
     // recursive ended here for XML Form : Need only near tables
    if  fb_FieldTypeRelation ( afws_Source, afr_Relation, anod_Field, anod_FieldProperties, af_FieldDefs, ab_createDS, ab_FullTable, acom_Owner ) Then
     Begin
      Result:=True;
      Exit;
     end;
    Result:=False;
    if ( anod_FieldProperties.NodeName = CST_LEON_FIELD_DECIMALS )then
      Begin
       Decimals:=StrToInt(anod_FieldProperties.Attributes[CST_LEON_VALUE]);
      end;
    if ( anod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS )
    or ( anod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS ) then
     Begin
      ab_IsLarge := True;
     end;
    if anod_FieldProperties.NodeName = CST_LEON_FIELD_NCHARS then
      FieldLength := StrToInt(anod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
    if anod_FieldProperties.NodeName = CST_LEON_FIELD_MAX then
       Begin
         if ( anod_Field.NodeName = CST_LEON_FIELD_TEXT ) then
           try
             FieldLength := StrToInt(anod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
           Except
           end
         else
           if ( anod_Field.NodeName = CST_LEON_FIELD_NUMBER ) then
           try
             FieldLength:= Length ( anod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
           Except
           end;
         try
           FieldSize := Trunc ( ldo_Temp );
         Except
         end;
       End;
     if anod_FieldProperties.NodeName = CST_LEON_FIELD_MIN then
       Begin
         if ( anod_Field.NodeName = CST_LEON_FIELD_TEXT ) then
           try
            FieldLength := StrToInt(anod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
           Except
           end
         else
           if ( anod_Field.NodeName = CST_LEON_FIELD_NUMBER ) then
           try
            FieldLength:= Length ( anod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
           Except
           end;
       End;
     if FieldLength < 256 Then
      ab_islarge:=False;
   end;
End;
////////////////////////////////////////////////////////////////////////////////
// fonction p_setFieldType
// creating CSV definition properties
// Création de la définition de champ pour les fichiers CSV
// anod_Field : Field node
// afd_FieldsDefs : CSV definitions to add definition
// Result : local
////////////////////////////////////////////////////////////////////////////////
function  fb_setFieldType ( const afws_Source : TFWTable ;
                            const af_FieldDefs : TFWFieldColumn;
                            const anod_Field : TALXMLNode;
                            const ai_counter : Integer;
                            const ab_createDS : Boolean;
                            const ab_FullTable : Boolean;
                            const acom_Owner : TComponent;
                            var   ab_isrelation : Boolean;
                            const ab_isreference : Boolean=True;
                            const ab_passIfNotId : Boolean = False;
                            const as_fieldname   : String = ''): Boolean;
var lb_isLarge : Boolean ;
    li_k : Integer;
    lnod_Prop : TALXMLNode;
    lb_pass : Boolean;
    lfr_Relation : TFWRelation;
begin
  Result:=False;
  lfr_Relation := nil;
  with af_FieldDefs, anod_Field do
   Begin
    if HasChildNodes then
     for li_k := 0 to ChildNodes.Count -1 do
      Begin
        lnod_Prop:=ChildNodes [ li_k ];
        // type properties of field
        fb_FieldTypeProperties ( afws_Source, lfr_Relation, anod_Field,lnod_Prop, af_FieldDefs, lb_isLarge,ab_createDS,ab_FullTable,acom_Owner );
        // options like local
        fb_getFieldOptions ( afws_Source,anod_Field,lnod_Prop,af_FieldDefs,Result,ab_isreference);
      End;

     // relation field set by relation's table
    if assigned( lfr_Relation )
     Then
      Begin
       ab_isrelation:=True;
       Exit;
      End;
    ab_isrelation:=False;

    if ab_passIfNotId and (afws_Source.GetKey.indexOf(as_FieldName) = -1)
     Then Exit;
    // data type of field
    FieldType := ftString;
    lb_isLarge:=False;
    if ( NodeName = CST_LEON_FIELD_NUMBER ) then
     begin
       if  HasAttribute(CST_LEON_FIELD_TYPE)
       and ( Attributes [ CST_LEON_FIELD_TYPE ] = CST_LEON_FIELD_DOUBLE )
        Then FieldType := ftFloat
        Else FieldType := ftInteger;
     end
    else if NodeName = CST_LEON_FIELD_FILE then
      Begin
        FieldType := ftString;
        Options:=Options+[foFile];
      End
    else if NodeName = CST_LEON_FIELD_DATE then
      Begin
        FieldType := ftDate;
      End
    else if NodeName = CST_LEON_FIELD_CHOICE then
      Begin
        FieldType := ftString;
        Options:=Options+[foChoice];
        FieldLength:=1;
      End;
    // after setting the choice component setting the height
    if NodeName = CST_LEON_FIELD_TEXT then
      Begin
        if lb_isLarge Then
          Begin
            FieldType := ftMemo;
          End
         Else
          Begin
            FieldType := ftString;
            ColSelect:=True;
          End
      End;
  End;
end;

function fb_getOptionalStructTable ( const afwt_Sources : TFWTables;
                                     const afwt_Source : TFWTable;
                                     var   afwt_Source2 : TFWTable;
                                     const affd_ColumnFieldDef : TFWFieldColumn;
                                     const anod_Field,anod_OriginalNode : TALXMLNode;
                                     const ab_createDS : Boolean ): Boolean;
var li_k : LongInt ;
    lb_column : Boolean;
    lnod_FieldsNode,lnod_FieldsChildNode : TALXmlNode;
    LField : TFWMiniFieldColumn;
    ls_Table, ls_base : String ;
Begin
  Result:=False;
  ls_Table:=anod_Field.Attributes[CST_LEON_TEMPLATE];
   if anod_OriginalNode.HasChildNodes then
     for li_k := 0 to anod_OriginalNode.ChildNodes.Count - 1 do
       Begin
         lnod_FieldsNode := anod_OriginalNode.ChildNodes [ li_k ];
         if lnod_FieldsNode.NodeName = CST_LEON_CLASS_C_BIND Then
          Begin
           ls_Table:=lnod_FieldsNode.Attributes[CST_LEON_VALUE];
           ls_base :=lnod_FieldsNode.Attributes[CST_LEON_LOCATION];
           Break;
          end;
       end;
   afwt_Source2 := afwt_Sources.TableByName(ls_Table);
   if afwt_Source2 = nil Then
    Begin
     if  ( ls_base = '')
     and ( ab_createDS ) Then
      ls_base:=afwt_Source.Connection.PrimaryKey;
         //  MyShowMessage(ls_Table + ' linked');

     afwt_Source2 := ffws_CreateSource( afwt_Sources, ls_base, ls_Table, Null, afwt_Sources.Owner as TComponent, ab_createDS );
     afwt_Source2.IsMain := True;
    End
    Else
     Begin
       if afwt_Source2.GetKey.Count> 0 Then;
        Begin
         LField := afwt_Source2.GetKey.Items [0];
         if afwt_Source2.FieldsDefs.FieldByName( LField.FieldName ) = nil
          Then affd_ColumnFieldDef.Assign(LField)
          Else affd_ColumnFieldDef.Assign(afwt_Source2.FieldsDefs.FieldByName(LField.FieldName));
        end;
       Result := True;
       Exit;
     end;
   with afwt_Source.Relations.Add do
     Begin
       TableLinked:=afwt_Source2.Index;
     end;
   with afwt_Source2.Relations.Add do
     Begin
       TableLinked:=afwt_Source.Index;
       FieldsFK.Assign(afwt_Source.GetKey);
     end;
End;


// Function fb_getFieldOptions
// setting some data properties
// Result : quitting
function fb_getFieldOptions ( const afws_Source : TFWTable;
                              const anod_Field,anod_FieldProperties : TALXMLNode ;
                              const affd_ColumnFieldDef : TFWFieldColumn;
                              var   ab_isLocal : Boolean ;
                              const ab_isReference : Boolean = True ): Boolean;
begin
  Result := False;
  with anod_FieldProperties, affd_ColumnFieldDef do
   Begin
    if NodeName = CST_LEON_FIELD_F_MARKS then
      Begin
        Result := True;
        if HasAttribute ( CST_LEON_FIELD_LOCAL )
        and ( Attributes [ CST_LEON_FIELD_LOCAL ] <> CST_LEON_BOOL_FALSE )  then
          Begin
           ColSelect:=False;
           ab_isLocal:=True;
          End
         Else
          ab_isLocal:=False;


       if ab_isReference then
        Begin
         if HasAttribute ( CST_LEON_FIELD_CREATE)
          then ColCreate  := Attributes [ CST_LEON_FIELD_CREATE ] = CST_LEON_BOOL_TRUE;
         if HasAttribute ( CST_LEON_FIELD_PROVIDER)
          then ColCreate  := Attributes [ CST_LEON_FIELD_PROVIDER ] = CST_LEON_BOOL_FALSE;
         if HasAttribute ( CST_LEON_FIELD_UNIQUE)
          then ColUnique  := Attributes [ CST_LEON_FIELD_UNIQUE ] = CST_LEON_BOOL_TRUE;
         if HasAttribute ( CST_LEON_FIELD_id)
          then ColUnique  := Attributes [ CST_LEON_FIELD_id ] = CST_LEON_BOOL_TRUE;
         if HasAttribute ( CST_LEON_FIELD_private)
          then ColPrivate  := Attributes [ CST_LEON_FIELD_private ] = CST_LEON_BOOL_TRUE;
         p_setNodeId(anod_FieldProperties,afws_Source,affd_ColumnFieldDef);
         if ( HasAttribute ( CST_LEON_FIELD_sort)
            and ( Attributes [ CST_LEON_FIELD_sort ] = CST_LEON_BOOL_TRUE ))
         or ( HasAttribute ( CST_LEON_FIELD_find)
              and ( Attributes [ CST_LEON_FIELD_find ] = CST_LEON_BOOL_TRUE ))  then
           Begin
             ShowSearch := affd_ColumnFieldDef.Index + 1;
           End
          else
           ShowCol := affd_ColumnFieldDef.Index + 1;
        end;

       if HasAttribute ( CST_LEON_FIELD_hidden )
       and not ( Attributes [ CST_LEON_FIELD_hidden ] = CST_LEON_BOOL_FALSE )  then
         Begin
           ShowCol := -1;
           ShowSearch := -1;
           ColHidden:=True;
           Exit;
         End;
       ShowCol := affd_ColumnFieldDef.Index + 1;
       if HasAttribute ( CST_LEON_FIELD_optional)
       and not ( Attributes [ CST_LEON_FIELD_optional ] = CST_LEON_BOOL_TRUE )  then
         Begin
           ColMain  := False;
           ShowCol := -1;
         End
        Else
         ColMain := True;
     End;
     p_setNodesField(anod_FieldProperties,affd_ColumnFieldDef,ab_isReference);
    End;

end;

// procedure fb_GetMarkFunction
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

function fb_GetCrossLinkNode( const as_ParentClass: String ; const anod_FieldProperties :TALXMLNode ): Boolean ;
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

// function fs_getLeonInfo
// getting info directory

function fs_getLeonInfo : String;
Begin
  Result := fs_getLeonFiles + 'info' + DirectorySeparator ;
End;

// function fs_getLeonFiles
// getting files directory
function fs_getLeonFiles : String;
Begin
  Result := fs_getLeonDir + 'files' + DirectorySeparator ;
End;

// function fs_getProjectDir
// getting main directory
function fs_getProjectDir : String;
Begin
  Result := fs_getLeonDir + ExtractFileDir ( gs_ProjectFile ) + DirectorySeparator ;
End;

// function fs_getImagesDir
// getting image directory
function fs_getImagesDir : String;
Begin
  Result := fs_getLeonDir + CST_IMAGES_DIR;
End;

// function fb_LoadXMLFile
// Loading XML File
// axdo_FichierXML : XML document loading
// as_FileXML : XML File Path to set
function fb_LoadXMLFile ( const axdo_FichierXML : TALXMLDocument; const as_FileXML : String ): Boolean;
  function fb_LoadXML (): Boolean;
    Begin
      if not FileExistsUTF8 ( as_FileXML ) Then
        Begin
          MyShowMessage ( 'File Not Found : ' + as_FileXML );
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

procedure p_SetFieldSelect ( const affd_ColumnFieldDef : TFWFieldColumn; const ab_IsLocal : Boolean  );
Begin
  affd_ColumnFieldDef.ColSelect:=not ab_IsLocal;
end;

initialization
  GS_Data_Extension := '.res';
{$IFDEF VERSIONS}
  p_ConcatVersion ( gVer_fonctions_XML );
{$ENDIF}
end.
