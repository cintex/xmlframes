unit fonctions_dbservice;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}
//////////////////////////////////////////////////////////////////////////////
// Author : Matthieu GIROUX
// no control in this unit
//////////////////////////////////////////////////////////////////////////////

interface

uses
  Classes,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils, ALXmlDoc,
  u_multidata,
  fonctions_manbase,
  fonctions_system,
  IniFiles;

const // Champs utilisés
  CST_INI_PROJECT_FILE = 'LY_PROJECT_FILE';
  CST_INI_LANGUAGE = 'LY_LANGUAGE';
  CST_DIR_LANGUAGE = 'properties'+ DirectorySeparator;
  CST_DB_PROTOCOL = 'Protocol';
  CST_DB_DATABASE = 'Database';
  CST_DIR_LANGUAGE_LAZARUS = 'LangFiles'+ DirectorySeparator;
  CST_SUBFILE_LANGUAGE =  'strings_';
  {$IFDEF VERSIONS}
  gver_fonctions_service : T_Version = (Component : 'XML Service Unit' ;
                                           FileUnit : 'fonctions_service' ;
              			           Owner : 'Matthieu Giroux' ;
              			           Comment : 'Centralizing service. No XML Form functions in this unit.'+#10 ;
              			           BugsStory : 'Version 0.9.0.0 : Centralized unit.';
              			           UnitType : 1 ;
              			           Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}
type
  TOnExecuteProjectNode = procedure ( const as_FileName : String; const ANode : TALXMLNode );
  TOnExecuteSQLScript = function ( const as_BaseName, as_user, as_password, as_host, as_sql1, as_sql2 : String ; const ads_connection : TDSSource ):Boolean;
  TActionTemplate          = (atmultiPageTable,atLogin);
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
                                  Mode     : Byte ;
                                  Functions : TLeonFunctions;
                             end;
  TStringLink = Record
                  Source ,
                  Destination : String;
                end;

  TStringLinkArray = array of TStringLink;

const ge_ExecuteSQLScript : TOnExecuteSQLScript = nil;
function fb_ReadServerIni ( var amif_Init : TIniFile ; const AApplication : TComponent ): Boolean;
procedure p_LoadData ( const axno_Node : TALXMLNode; const acom_owner : TComponent );
function fs_getIniOrNotIniValue ( const as_Value : String ) : String;
function fb_CreateProject ( var amif_Init : TIniFile; const AApplication : TComponent ) : Boolean;
function fb_ReadLanguage (const as_little_lang : String ) : Boolean;
function fs_BuildFromXML ( Level : Integer ; const aNode : TALXMLNode ; const AApplication : TComponent ):String;
procedure p_CopyLeonFunction ( const ar_Source : TLeonFunction ; var ar_Destination : TLeonFunction );
procedure p_LoadRootAction ( const ano_Node : TALXMLNode );
procedure p_LoadEntitites ( const axdo_FichierXML : TALXMLDocument );
procedure p_AddFunction (const AClep,AGroup,AName,AFileName,APrefix,AMode:String;const ATemplate : Variant);
function fs_getClassCaption ( const AClass : String ) : String;
function fs_BuildTreeFromXML ( Level : Integer ; const aNode : TALXMLNode ;
                               const aopn_OnProjectNode : TOnExecuteProjectNode ):String;
procedure p_AddStringLink (var AArray : TStringLinkArray;const ASource,ADestination:String);
function fstl_GetStringLink ( const AArray : TStringLinkArray; const ASource : String ):TStringLink;
function fs_GetDestination  ( const AArray : TStringLinkArray; const ASource : String ):String;
procedure p_CreateClassBinding ( const as_XMLClass : String ; const acom_owner : TComponent);

var gs_Language : String;
    CST_FILE_LANGUAGES : String =  'languages';
    gs_RootAction           : String;
    ga_Functions : Array of TLeonFunction;
    gas_ClassesBinding : TStringLinkArray;

implementation

uses u_multidonnees,
     fonctions_xml,
     fonctions_dbcomponents,
     fonctions_init, fonctions_proprietes,
     u_languagevars,
     unite_variables,
     fonctions_createsql,
     fonctions_file,
     FileUtil,
     Controls,
     strutils,
     {$IFDEF FPC}
     LazFileUtils,
     {$ENDIF}
     fonctions_dialogs,
     Dialogs,
     fonctions_string,
     fonctions_languages;

/////////////////////////////////////////////////////////////////////////
// procedure p_LoadEntitites
// Calling a recursive procedure loading entities from XML Document
// axdo_FichierXML : XML entities file
/////////////////////////////////////////////////////////////////////////
procedure p_LoadEntitites ( const axdo_FichierXML : TALXMLDocument );

Begin
  p_LoadRootAction ( axdo_FichierXML.node );
End;


procedure p_AddFunction (const AClep,AGroup,AName,AFileName,APrefix,AMode:String;const ATemplate : Variant);
Begin
  SetLength ( ga_Functions, high ( ga_Functions ) + 2 );
  with ga_Functions [ high ( ga_Functions )] do
    Begin
      Clep   := AClep;
      Groupe := AGroup;
      Name   := AName;
      AFile  := AFileName;
      Prefix := APrefix;
{                 if (  Name = '' ) then
        Begin
          MyShowMessage (  Gs_EmptyFunctionName +  Clep );
        End;   }
      if ATemplate = CST_LEON_TEMPLATE_MULTIPAGETABLE then
        Template := atMultiPageTable ;
      finalize ( Functions );
      if AMode =' '
        Then Mode := Byte(fsStayOnTop)
        Else if AMode = ' '
          Then Mode := Byte(fsNormal)
          Else Mode := Byte(fsMDIChild);
    End;
end;

procedure p_AddStringLink (var AArray : TStringLinkArray;const ASource,ADestination:String);
Begin
  SetLength ( AArray, high ( ga_Functions ) + 2 );
  with AArray [ high ( AArray )] do
    Begin
      Source   := ASource;
      Destination := ADestination;
    End;
end;

function fstl_GetStringLink ( const AArray : TStringLinkArray; const ASource : String ):TStringLink;
var li_i : Integer;
Begin
  for li_i := 0 to high ( AArray ) do
   if ASource = AArray [ li_i ].Source Then
     Begin
      Result:=AArray [ li_i ];
      Exit;
     end;
end;

function fs_GetDestination ( const AArray : TStringLinkArray; const ASource : String ):String;
Begin
  Result:=fstl_GetStringLink(AArray,ASource).Source;
end;



// procedure p_CreateFormComponents
// Create a form from XML File
// as_XMLFile : XML File
// as_Name : Name of form
// awin_Parent : Parent component
// ai_Counter : The column counter for other XML File
procedure p_CreateClassBinding ( const as_XMLClass : String ; const acom_owner : TComponent);
var li_i, li_j, li_k, li_NoField : LongInt ;
    lnod_Node, lnod_ClassNode : TALXMLNode ;
    lb_Column, lb_FieldFound, lb_Table : Boolean ;
    lxml_Class : TALXMLDocument ;
  // procedure p_CreateXMLColumn
  // Creates the XML form column
  // as_Table : Table name
  // as_Connection : Connection name
  procedure p_CreateClassBinding ( const as_Table, as_TableKey : String );
  Begin
     // MyShowMessage(as_Table + ' xmlcolumn');
    p_AddStringLink(gas_ClassesBinding,as_TableKey,as_Table);
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
                      if lnod_ClassNode.NodeName = CST_LEON_CLASS_C_BIND Then
                       with lnod_ClassNode do
                        Begin
                          p_CreateClassBinding (Attributes [ CST_LEON_VALUE ], lnod_Node.Attributes [ CST_LEON_ID ]);
                          Exit;
                        end;
                    end;
                  if not lb_Table Then
                   with lnod_ClassNode do
                    Begin
                      p_CreateClassBinding (Attributes [ CST_LEON_ID ], lnod_Node.Attributes [ CST_LEON_ID ]);
                      Exit;
                    end;
                end;
            End;
        End;
    finally
      lxml_Class.Destroy;
    End ;

end;



/////////////////////////////////////////////////////////////////////////
// procedure p_BuildFromXML
// recursive loading entities menu and data
// Level : recursive level
// aNode : recursive node
// abo_BuildOrder : entities to load
/////////////////////////////////////////////////////////////////////////
function fs_BuildTreeFromXML ( Level : Integer ; const aNode : TALXMLNode ;
                               const aopn_OnProjectNode : TOnExecuteProjectNode ):String;
var li_i : Integer ;
    lNode : TALXMLNode ;
Begin
   if ( aNode.HasChildNodes ) then
     for li_i := 0 to aNode.ChildNodes.Count - 1 do
      Begin
        lNode := aNode.ChildNodes [ li_i ];
//        if (  lNode.IsTextElement ) then
//          MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.NodeValue)
//         else
        // connects before build
        if ( UpperCase (copy ( lNode.NodeName, 1, 8 )) = CST_LEON_ENTITY )
        and (  lNode.HasAttribute ( CST_LEON_DUMMY ) ) then
          Begin
//            MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.Attributes [ 'DUMMY' ]);
            Result := lNode.Attributes [ CST_LEON_DUMMY ];
            {$IFDEF WINDOWS}
            Result := fs_RemplaceChar ( Result, '/', '\' );
            {$ENDIF}
            // Pas besoin du chemin complet
            gs_RootEntities := fs_WithoutFirstDirectory ( fs_WithoutFirstDirectory ( Result ));
            if pos ( '.', gs_RootEntities ) > 0 then
              Begin
                gs_RootEntities := copy ( gs_RootEntities, 1, pos ( '.', gs_RootEntities ) - 1 );
              End;

            Result := fs_getLeonDir + fs_WithoutFirstDirectory ( Result );
            if FileExistsUTF8 ( Result ) then
               aopn_OnProjectNode ( Result, lNode );
          End;
//         else
//          MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.ClassName);
        Result := fs_BuildTreeFromXML ( Level + 1, lNode, aopn_OnProjectNode );
      End;
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
      if not FileExistsUTF8(fs_getLeonDir + fs_GetNameSoft + CST_EXTENSION_INI) Then
        Begin
          raise Exception.Create ( 'No ini file of LEONARDI project !' );
          Exit;
        end;
      try
        lstl_FichierIni.LoadFromFile( fs_getLeonDir + fs_GetNameSoft + CST_EXTENSION_INI);
        if ( pos ( INISEC_PAR, lstl_FichierIni [ 0 ] ) <= 0 ) Then
          Begin
            lstl_FichierIni.Insert(0,'['+INISEC_PAR+']');
            lstl_FichierIni.SaveToFile(fs_getLeonDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI );
            lstl_FichierIni.Destroy;
            raise Exception.Create ( 'New INI in '+ fs_getLeonDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI + '.'+#13#10+#13#10 +
                          'Restart.');
            Exit;
          End;
      Except
        lstl_FichierIni.Free;
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
function fs_BuildFromXML ( Level : Integer ; const aNode : TALXMLNode ; const AApplication : TComponent ):String;
var li_i : Integer ;
    lNode : TALXMLNode ;
    lxdo_FichierXML : TALXMLDocument;
Begin
   if ( aNode.HasChildNodes ) then
     for li_i := 0 to aNode.ChildNodes.Count - 1 do
      Begin
        lNode := aNode.ChildNodes [ li_i ];
//        if (  lNode.IsTextElement ) then
//          MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.NodeValue)
//         else
        // connects before build
        if ( lNode.NodeName = CST_LEON_PROJECT ) Then
          Begin
            gNod_Classes:=lNode;
            if lNode.Attributes[CST_LEON_ROOT_ACTION] <> Null Then
              gs_RootAction := lNode.Attributes[CST_LEON_ROOT_ACTION];
            p_LoadData ( lNode, AApplication );
          end;
        if ( Uppercase (copy ( lNode.NodeName, 1, 8 )) = CST_LEON_ENTITY )
        and (  lNode.HasAttribute ( CST_LEON_DUMMY ) ) then
          Begin
//            MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.Attributes [ 'DUMMY' ]);
            Result := lNode.Attributes [ CST_LEON_DUMMY ];
            {$IFDEF WINDOWS}
            Result := fs_RemplaceChar ( Result, '/', '\' );
            {$ENDIF}

            Result := fs_getLeonDir + fs_WithoutFirstDirectory ( Result );
            if FileExistsUTF8 ( Result ) Then
              Begin
                if  ( pos ( CST_LEON_SYSTEM_LOCATION, Uppercase(lNode.NodeName) ) > 0 ) Then
                 Begin
                    lxdo_FichierXML := TALXMLDocument.Create(AApplication);
                    try
                      if fb_LoadXMLFile ( lxdo_FichierXML, Result )
                       then
                        Begin
                         p_LoadData ( lxdo_FichierXML.Node, AApplication );
                        end;

                    finally
                      lxdo_FichierXML.Destroy;
                    end;
                 End
                Else
                 if   ( pos ( CST_LEON_SYSTEM_ROOT      , Uppercase(lNode.NodeName) ) = 0 )
                 and  ( pos ( CST_LEON_SYSTEM_NAVIGATION, Uppercase(lNode.NodeName) ) = 0 )
                 and  ( pos ( CST_LEON_SYSTEM_LEON      , Uppercase(lNode.NodeName) ) = 0 )
                  Then
                   p_CreateClassBinding(Result,AApplication);
              end;
          End;
//         else
//          MyShowMessage('Level : ' + IntTosTr ( Level ) + 'Name : ' +lNode.NodeName + ' Classe : ' +lNode.ClassName);
        Result := fs_BuildFromXML ( Level + 1, lNode, AApplication );
      End;
End;

function fs_getClassCaption ( const AClass : String ) : String;
var lxdoc_Class   : TALXMLDocument;
    lNodeBase,lNodeClass   : TALXMLNode;
    li_i, li_j : Integer;
Begin
  lxdoc_Class:=TALXMLDocument.Create(nil);
  Result:='';
  try
    if fb_LoadXMLFile(lxdoc_Class,fs_getLeonInfo +AClass+CST_LEON_File_Extension)
     Then
      for li_i := 0 to lxdoc_Class.ChildNodes.Count-1 do
       Begin
         lNodeBase:=lxdoc_Class.ChildNodes[li_i];
         if lNodeBase.NodeName=CST_LEON_CLASS Then
          Begin
           for li_j := 0 to lNodeBase.ChildNodes.Count-1 do
            Begin
              lNodeClass:=lNodeBase.ChildNodes[li_i];
              if lNodeClass.NodeName=CST_LEON_NAME Then
               Begin
                Result:=fs_GetLabelCaption ( lNodeClass.Attributes[CST_LEON_VALUE] );
                Break;
               end;

            end;
           Break;
          end;
       end;
  finally
   lxdoc_Class.Destroy;
  end;
  if Result=''
   Then Result:=AClass;
end;

/////////////////////////////////////////////////////////////////////////
// function fb_ReadServerIni
// reading ini, creating and building server project
// Lecture du fichier INI
// Résultat : il y a un fichier projet.
// amif_Init : ini file
/////////////////////////////////////////////////////////////////////////
function fb_ReadServerIni ( var amif_Init : TIniFile ; const AApplication : TComponent ) : Boolean;
Begin
  if fb_CreateProject ( amif_Init, AApplication )
  and fb_LoadXMLFile ( gxdo_FichierXML, fs_getLeonDir + gs_ProjectFile ) Then
    Begin
      Result := True;
      fs_BuildFromXML ( 0, gxdo_FichierXML.Node, AApplication ) ;
    End
   Else
    Result := False;
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
  if  fb_LoadProperties ( fs_getLeonDir + CST_DIR_LANGUAGE, CST_SUBFILE_LANGUAGE + copy(gs_ProjectFile, 1, pos ( '/', gs_ProjectFile )-1),  as_little_lang ) then
    Begin
      if assigned ( FIniMain ) then
        Begin
          FIniMain.WriteString(INISEC_PAR,CST_INI_LANGUAGE,as_little_lang);
          fb_iniWriteFile( FIniMain, False );
        End;
      Result := True;
    End
  else fb_LoadProperties ( fs_getLeonDir + CST_DIR_LANGUAGE + CST_SUBFILE_LANGUAGE + copy(gs_ProjectFile, 1, pos ( '/', gs_ProjectFile )-1) + GS_EXT_LANGUAGES );
End;


/////////////////////////////////////////////////////////////////////////
// function fb_ReadIni
// reading ini and creating project
// Lecture du fichier INI
// Résultat : il y a un fichier projet.
// amif_Init : ini file
/////////////////////////////////////////////////////////////////////////
function fb_CreateProject ( var amif_Init : TIniFile ; const AApplication : TComponent ) : Boolean;
Begin
  if DMModuleSources = nil Then
    DMModuleSources := TDMModuleSources.Create ( AApplication );
  Result := False;
  gs_Language := 'en';
  gs_NomApp := fs_GetNameSoft;
  if not assigned ( amif_Init ) then
    if FileExistsUTF8(fs_getLeonDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI)
      Then amif_Init := TIniFile.Create(fs_getLeonDir + CST_INI_SOFT + fs_GetNameSoft+ CST_EXTENSION_INI)
      Else p_InitIniProjectFile;
  if assigned ( amif_Init ) Then
    Begin
      gs_ProjectFile := amif_Init.ReadString(INISEC_PAR,CST_INI_PROJECT_FILE,gs_ProjectFile);
      gs_Language    := amif_Init.ReadString(INISEC_PAR,CST_INI_LANGUAGE,'en');
      fb_ReadLanguage ( gs_Language );

      p_InitIniProjectFile;

      if not assigned ( gxdo_FichierXML ) then
        gxdo_FichierXML := TALXMLDocument.Create ( AApplication );
      Result := gs_ProjectFile <> '';
      if result Then
        Begin
          {$IFDEF WINDOWS}
          gs_ProjectFile := fs_RemplaceChar ( gs_ProjectFile, '/', '\' );
          {$ENDIF}
          gs_ProjectFile := fs_EraseNameSoft ( gs_NomApp, gs_ProjectFile );
//          MyShowMessage ( fs_getLeonDir + gs_ProjectFile );


        End;
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


/////////////////////////////////////////////////////////////////////////
// procedure p_LoadNodesEntities
// Searching some dashboard nodes in xml tree view
// ano_Node : A node
// ano_Parent  : Parent node
// ai_LastCFonction : Last compound function
/////////////////////////////////////////////////////////////////////////
procedure p_LoadNodesEntities ( const ano_Node,ano_Parent : TALXMLNode ; ai_LastCFonction  : Longint );
var li_j  : LongInt ;
    lNodeChild : TALXMLNode ;
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
            lParam2 :=  lnodeChild.Attributes [ CST_LEON_ACTION_VALUE ]
          else
            if ( lnodeChild.NodeName = CST_LEON_PARAMETER )
            and ( lnodeChild.Attributes [ CST_LEON_PARAMETER_NAME ]= CST_LEON_ACTION_CLASSINFO ) then
              lParam3 :=  lnodeChild.Attributes [ CST_LEON_ACTION_IDREF ];
      end;

    procedure p_setCompoundFunction ( const as_idName : String );
    Begin
      SetLength ( ga_Functions [ ai_LastCFonction ].Functions, high ( ga_Functions [ ai_LastCFonction ].Functions ) + 2 );
      ga_Functions [ ai_LastCFonction ].Functions [ high ( ga_Functions [ ai_LastCFonction ].Functions )] := ano_Node.Attributes [ as_idName ];
    end;

Begin
  if ( ano_Node.NodeName = CST_LEON_ACTION )
  or ( ano_Node.NodeName = CST_LEON_COMPOUND_ACTION ) then
    Begin
      ls_Mode := '' ;
      lParam1 := '' ;
      lParam2 := '' ;
      lParam3 := '' ;
      lPrefix := '' ;

      // On ajoute la fonction complémentaire
      if  ( ano_Node.HasChildNodes ) then
        for  li_j := 0 to ano_Node.ChildNodes.count - 1 do
          Begin
            lNodeChild := ano_Node.ChildNodes [ li_j ];
            p_SetAttributeValues;
          End;

      // On ajoute la fonction action
       SetLength ( ga_Functions, high ( ga_Functions ) + 2 );
       with ga_Functions [ high ( ga_Functions )] do
         Begin
           Clep := ano_Node.Attributes [ CST_LEON_ID ];
           Groupe := lParam2;
           Name   := lParam1;
           AFile  := lParam3;
           Prefix := lPrefix;
{                 if (  Name = '' ) then
             Begin
               MyShowMessage (  Gs_EmptyFunctionName +  Clep );
             End;   }
           if ano_Node.Attributes [ CST_LEON_ACTION_TEMPLATE ] = CST_LEON_TEMPLATE_MULTIPAGETABLE then
             Template := atMultiPageTable ;
           finalize ( Functions );
           if ls_Mode =' '
             Then Mode := Byte(fsStayOnTop)
             Else if ls_Mode = ' '
               Then Mode := Byte(fsNormal)
               Else Mode := Byte(fsMDIChild);
         End;

       if  ( ano_Parent <> nil )
       and ( ai_LastCFonction >= 0   )
       Then
         Begin
           p_setCompoundFunction ( CST_LEON_ID );
         end;

       if ( ano_Node.NodeName = CST_LEON_COMPOUND_ACTION ) then
         if  ( ano_Node.HasChildNodes ) then
           for  li_j := 0 to  ano_Node.ChildNodes.Count- 1 do
            Begin
              lNodeChild := ano_Node.ChildNodes [ li_j ];
              p_SetAttributeValues;
              finalize (ga_Functions [high ( ga_Functions )].Functions);
              if  ( lNodeChild.NodeName = CST_LEON_ACTION ) Then
                p_LoadNodesEntities ( lNodeChild, lNodeChild, high ( ga_Functions ) );
            End;
    End
   else
    if  ( ano_Node.NodeName = CST_LEON_ACTION_REF )
    and ( ano_Node.NodeName = CST_LEON_COMPOUND_ACTION ) then
      Begin
        p_setCompoundFunction ( CST_LEON_ACTION_IDREF );
      End;
End;

/////////////////////////////////////////////////////////////////////////
// procedure p_Loaddashboard
// Searching some dashboard in xml tree view
// ano_Node : A node
// ano_Parent  : Parent node
// ai_LastCFonction : Last compound function
/////////////////////////////////////////////////////////////////////////
procedure p_LoadRootAction ( const ano_Node : TALXMLNode );
var li_i, li_j  : LongInt ;
    lNode : TALXMLNode ;

Begin
  if gs_RootAction > '' Then
   if ano_Node.HasChildNodes Then
    for li_i := 0 to ano_Node.ChildNodes.Count - 1 do
      Begin
        lNode := ano_Node.ChildNodes [ li_i ];
        if  ( lnode.Attributes [ CST_LEON_ID ] =  gs_RootAction )
        or  ( lnode.Attributes [ CST_LEON_TEMPLATE ] =  CST_LEON_TEMPLATE_DASHBOARD ) then
          Begin
            if ( lnode.Attributes [ CST_LEON_TEMPLATE ] =  CST_LEON_TEMPLATE_DASHBOARD ) Then
              gnod_DashBoard := lnode
             else
              gNod_RootAction := lNode;
            if lnode.HasChildNodes Then
              for li_j := 0 to lnode.ChildNodes.Count -1 do
                if lnode.ChildNodes [ li_j ].NodeName = CST_LEON_ACTIONS Then
                  p_LoadRootAction ( lnode.ChildNodes [ li_j ] );
            Continue;
          End;
        p_LoadNodesEntities ( lNode, nil, -1 );
      end;


end;
/////////////////////////////////////////////////////////////////////////
// function fs_getIniOrNotIniValue
// Loading  from ini
// as_Value : Value to find from ini
/////////////////////////////////////////////////////////////////////////
function fs_getIniOrNotIniValue ( const as_Value : String ) : String;
Begin
  if  ( as_Value <> '' )
  and ( as_Value [1] = '$' )
  and Assigned(FIniMain)
   Then Result := FIniMain.ReadString( INISEC_PAR, copy ( as_Value, 2, Length(as_Value) -1 ), as_Value )
   else Result := as_Value;
End;

procedure p_onProjectInitNode ( const as_FileName : String ; const ANode : TALXMLNode );
Begin
  if  ( pos ( CST_LEON_SYSTEM_ROOT, Uppercase (aNode.NodeName) ) > 0 )
   then
     Begin
       if not assigned ( gxdo_MenuXML ) Then
         gxdo_RootXML := TALXMLDocument.Create(nil);
       if fb_LoadXMLFile ( gxdo_RootXML, as_FileName ) then
         p_LoadEntitites ( gxdo_RootXML );

     End
   else
    if  ( pos ( CST_LEON_ENTITY, Uppercase (aNode.NodeName) ) > 0 )
    and ( pos ( CST_LEON_SYSTEM, Uppercase (aNode.NodeName) ) > 0 )
    and ( pos ( CST_LEON_SYSTEM_NAVIGATION, Uppercase (aNode.NodeName) ) = 0 )
    and ( pos ( CST_LEON_SYSTEM_LOCATION, Uppercase (aNode.NodeName) ) = 0 )
     then
       Begin
        SetLength ( ga_Functions, high ( ga_Functions ) + 2 );
        with ga_Functions [ high ( ga_Functions )] do
          Begin
            Clep := ExtractFileNameOnly(ANode.Attributes [ CST_LEON_DUMMY ]);
            Groupe := '';
            Name   := Clep;
            AFile  := Clep;
            Prefix := '';
            finalize ( Functions );
          End;
      End;

End;


function fb_AutoCreateDatabase ( const as_BaseName, as_user, as_password, as_host : String ; const ab_DoItWithCommandLine : Boolean ; const acom_owner : TComponent ; const ads_connection : TDSSource = nil ):Boolean;
var li_i : Integer;
    LTables : TFWTables;
    ATemp1,
    ATemp2 : String;
Begin
  doShowWorking(gs_Message_Creating_database);
  try
    fs_BuildTreeFromXML ( 0, gxdo_FichierXML.Node, TOnExecuteProjectNode ( p_onProjectInitNode ) ) ;
    LTables := TFWTables.Create(TFWTable);
    try
      // create table objects
      for li_i := 0 to high ( ga_Functions ) do
       with ga_Functions [li_i] do
         Begin
           if AFile = ''
            Then ATemp1:=Name
            Else ATemp1:=AFile;
           if  ( ATemp1 > '' )
           and ( LTables.TableByName(ATemp1) = nil ) Then
             p_CreateComponents( LTables, ATemp1, Name, acom_owner, nil, gxdo_FichierXML, TOnExecuteFieldNode ( p_OnCreateFieldProperties), nil, nil, False, False );
         end;
      ATemp1:=fs_BeginAlterCreate+fs_CreateDatabase(as_BaseName,as_user,as_password, as_host);
      ATemp2:=fs_BeginAlterCreate;
      for li_i := 0 to LTables.Count - 1 do
       with LTables [ li_i ] do
        if IsMain Then
         Begin
           //MyShowMessage(Table+#10+GetSQLCreateCode);
           AppendStr(ATemp2,GetSQLCreateCode);
         end;
      AppendStr(ATemp2,fs_EndCreate(as_BaseName,as_user,as_password,as_host));
    finally
      LTables.destroy;
    end;
    try
      if ab_DoItWithCommandLine Then
        p_ExecuteSQLCommand(ATemp1+ATemp2)
      Else
       if Assigned(ge_ExecuteSQLScript)
        Then ge_ExecuteSQLScript ( as_BaseName, as_user, as_password,as_host, ATemp1, ATemp2, ads_connection );
      p_optimiseDatabase(nil,as_BaseName,as_user,as_password,fs_GetIniDir(False));
      Result := True;
    except
      Result := False;
    end;

  finally
    doCloseWorking;
  end;
End;

procedure p_LoadConnection ( const aNode : TALXMLNode ; const ads_connection : TDSSource ; const acom_owner : TComponent );
var li_Pos : LongInt ;
    AParams : Tstrings;
Begin
  with ads_connection do
   Begin
    DataLocal:=False;
    DataURL := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_URL ]);
    li_Pos := pos ( '//', DataURL );
    DataURL := copy ( DataURL , li_pos + 2, length ( DataURL ) - li_pos - 1 );
    DataPort := 0;
    li_Pos := pos ( ':', DataURL );
    if li_Pos > 0 Then
      DataURL := copy ( DataURL , li_pos + 1, length ( DataURL ) - li_pos );
    li_Pos := pos ( ':', DataURL );
    // Récupération du port
    if li_Pos > 0 Then
      try
        if pos ( '/', DataURL ) > 0
         Then  DataPort    := StrToInt ( copy ( DataURL, li_Pos + 1, pos ( '/', DataURL ) - li_pos - 1 ))
         Else  DataPort    := StrToInt ( copy ( DataURL, li_Pos + 1, length ( DataURL ) - li_pos ));
        // Finition de l'URL : Elle ne contient que l'adresse du serveur
        DataURL := copy ( DataURL , 1, li_Pos - 1 );
      Except
      end;
    li_Pos:=pos ( '=', DataURL );
    if ( li_Pos > 1 )
     Then
      Begin
       if pos ( fs_GetNameSoft, DataURL ) = li_pos+1 Then
         li_Pos:=posEx ( '/', DataURL, li_pos );
       DataBase:=fs_GetCorrectPath(copy(DataURL,li_Pos+1,Length(DataURL)-li_Pos));
       if not fb_IsFullPath(DataBase) Then
         DataBase:=GetDataDir+DataBase;
       if not fb_CreateDirectoryStructure(ExtractFilePath(DataBase)) Then
        Begin
         MyShowMessage(fs_RemplaceMsg(GS_CANNOT_CREATE_DIR_EXITING,[ExtractFilePath(DataBase)]));
         Exit;
        End;
       DataLocal:=True;
      end
     else
        Database := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_DATABASE ]);
    if ( DataURL [ length ( DataURL )] = '/' ) Then
      DataURL := copy ( DataURL , 1, length ( DataURL ) - 1 );
    if aNode.HasAttribute( CST_LEON_DATA_USER ) then
     Begin
      DataUser := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_USER ]);
      DataPassword :=fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_Password ]);
     end;
    DataDriver := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_DRIVER ]);
    InitConnection;
     p_setComponentProperty ( Connection, 'User', DataUser );
     p_setComponentProperty ( Connection, 'Password', DataPassword );
     if not DataLocal Then
       p_setComponentProperty ( Connection, 'Hostname', DataURL );
     p_setComponentProperty ( Connection, CST_DB_DATABASE, Database );
     p_setComponentProperty ( Connection, 'DatabaseName', Database );
     if DataPort > 0 Then
       p_setComponentProperty ( Connection, 'Port', DataPort );
     if ( pos ( CST_LEON_DATA_MYSQL, DataDriver ) > 0 ) Then
       Begin
        p_setComponentProperty ( Connection, CST_DB_PROTOCOL, CST_LEON_DRIVER_MYSQL );
        gbm_DatabaseToGenerate:=bmMySQL;
       end
     else if ( pos ( CST_LEON_DATA_FIREBIRD, DataDriver ) > 0 )
     and ( gbm_DatabaseToGenerate = bmFirebird ) Then
      Begin
        AParams := fobj_getComponentObjectProperty(Connection,'Params') as TStrings;
        if DataUser = '' Then
         Begin
          DataUser := 'SYSDBA';
          DataPassword:='masterkey';
         End;
        with AParams do
          Begin
           Add('user_name='+DataUser);
           Add('password='+DataPassword);
          end;
      end
     else if ( pos ( CST_LEON_DATA_SQLLITE, DataDriver ) > 0 ) Then
      Begin
       p_setComponentProperty ( Connection, CST_DB_PROTOCOL, CST_LEON_DRIVER_SQLLITE );
      end
     else if ( pos ( CST_LEON_DATA_ORACLE, DataDriver ) > 0 ) Then
      Begin
       p_setComponentProperty ( Connection, CST_DB_PROTOCOL, CST_LEON_DRIVER_ORACLE );
       gbm_DatabaseToGenerate:=bmOracle;
      end
     else if ( pos ( CST_LEON_DATA_POSTGRES, DataDriver ) > 0 ) Then
      Begin
       p_setComponentProperty ( Connection, CST_DB_PROTOCOL, CST_LEON_DRIVER_POSTGRES );
       gbm_DatabaseToGenerate:=bmPostgreSQL;
      end;
     if DataLocal Then
       if not FileExistsUTF8(DataBase) Then
         fb_AutoCreateDatabase ( DataBase, DataUser, DataPassword, DataURL, True, acom_owner );
     if not fb_OpenCloseDatabase ( Connection, True )
     and ( (MyMessageDlg('SQL',fs_RemplaceMsg(gs_Could_not_connect_Seems_you_have_not_created_database_Do_you,[fs_getComponentProperty(Connection,CST_DB_DATABASE),fs_getComponentProperty(Connection,'User')]),mtWarning,mbYesNo) = mrNo)
          or not fb_AutoCreateDatabase(DataBase,DataUser,DataPassword,DataURL,False,acom_owner,ads_connection)) Then
          halt;

   end;
end;

/////////////////////////////////////////////////////////////////////////
// Procédure p_Loaddata
// Loading data link
// Charge le lien de données
// axno_Node : xml data document
/////////////////////////////////////////////////////////////////////////
procedure p_LoadData ( const axno_Node : TALXMLNode; const acom_owner : TComponent );
var li_i : LongInt ;
    lds_connection,lds_connection2 : TDSSource;
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
        lds_connection:= DMModuleSources.fds_FindConnection(ls_ConnectionClep, False);
        if assigned ( lds_connection ) Then
          Continue;
        lds_connection := DMModuleSources.CreateConnection ( ls_ConnectionClep );
        with lds_connection do
          Begin
            case DatasetType of
              dtCSV : if ( lNode.NodeName = CST_LEON_DATA_FILE ) Then
                       Begin
                        dataURL := fs_LeonFilter ( fs_getIniOrNotIniValue ( lNode.Attributes [ CST_LEON_DATA_URL ])) +DirectorySeparator + lNode.Attributes [ CST_LEON_ID ] + '#';
                        {$IFDEF WINDOWS}
                        dataURL := fs_RemplaceChar ( DataURL, '/', '\' );
                        {$ENDIF}
                       End;
              {$IFDEF DBNET}
              dtDBNet : Begin
                         if Assigned(FIniMain)
                           Then Begin
                                  DataPort     := FIniMain.ReadInteger( INISEC_PAR, 'Port', 8080 );
                                  DataUser     := FIniMain.ReadString ( INISEC_PAR, CST_LEON_DATA_USER, '' );
                                  DataPassword := FIniMain.ReadString ( INISEC_PAR, CST_LEON_DATA_password, '' );
                                  DataURL      := FIniMain.ReadString ( INISEC_PAR, CST_LEON_DATA_URL, '127.0.0.1' );
                                  DataSecure   := FIniMain.ReadBool   ( INISEC_PAR, 'Secure', False );
                                End
                           else DataPort := 8080;
                         p_setComponentProperty ( Connection, 'Port', DataPort );
                         p_setComponentProperty ( Connection, 'Host', DataURL );
                         if DataUser <> '' Then
                           Begin
                            p_setComponentProperty ( Connection, 'Password', DataPassword );
                            p_setComponentProperty ( Connection, 'UserName', DataUser );
                            p_SetComponentBoolProperty( Connection, 'WithSSL', DataSecure );
                           End;
                         p_setComponentBoolProperty ( Connection, 'LoginPrompt', False );
                         if QueryCopy = nil Then
                           try
                             lds_connection2 := DMModuleSources.Sources.add;
                             lds_connection2.Connection := fobj_getComponentObjectProperty(Connection,CST_DBPROPERTY_ZEOSDB) as TComponent;
                             p_LoadConnection ( lNode , lds_connection2, acom_owner );
                             p_setComponentBoolProperty ( Connection, CST_DBPROPERTY_Active, True );
                             if not fb_getComponentBoolProperty( Connection, CST_DBPROPERTY_Active)
                                Then writeln ( 'Connection not active.')
                           Except
                             on E:Exception do
                               writeln ( 'Error : ' + e.ToString );
                           End;
                       End;
              {$ENDIF}
              else
                p_LoadConnection ( lNode , lds_connection, acom_owner );

            end;
         End;
       end;
    End;
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_service );
{$ENDIF}

end.
