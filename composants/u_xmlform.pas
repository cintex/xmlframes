unit u_xmlform;


{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

///////////////////////////////////////////////////////////////////////
// Nom Unite: U_FXMLForm
// Description : Création d'une fiche automatisée
// Créé par Matthieu GIROUX le 15/03/2009
///////////////////////////////////////////////////////////////////////

uses
 {$IFDEF FPC}
 LCLType,
 {$ELSE}
 Windows,
 {$ENDIF}
  Controls, Classes, Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls,
  ComCtrls, SysUtils,	TypInfo, Variants,
  U_CustomFrameWork, U_OnFormInfoIni,
  fonctions_string, ALXmlDoc, fonctions_xml, ExtCtrls,
  u_xmlfillcombobutton,
  U_ExtComboInsert,
  fonctions_manbase,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  u_framework_components, u_framework_dbcomponents,
  u_multidata, JvXPButtons, Menus,
  U_FormMainIni, fonctions_ObjetsXML,
  Graphics, u_multidonnees, U_GroupView;

{$IFDEF VERSIONS}
const

    gVer_TXMLForm : T_Version = ( Component : 'Composant TF_XMLForm' ;
                                  FileUnit  : 'U_XMLForm' ;
                                  Owner     : 'Matthieu Giroux' ;
                                  Comment   : 'Fiche personnalisée avec création de composant à partir du XML.' ;
                                  BugsStory : '0.9.1.5 : centralizing on ManFrames.'  + #13#10 +
                                              '0.9.1.4 : UTF 8.'  + #13#10 +
                                              '0.9.1.3 : Testing.'  + #13#10 +
                                              '0.9.1.2 : Forcing Not registered forms when searching form xml file.'  + #13#10 +
                                              '0.9.1.1 : Integrating TXMLFillCombo button.'  + #13#10 +
                                              '0.9.1.0 : Really integrating group view.'  + #13#10 +
                                              '0.9.0.2 : Childs Source for struct node.'  + #13#10 +
                                              '0.9.0.1 : Creating struct fields and components.'  + #13#10 +
                                              '0.9.0.0 : Reading a LEONARDI file and creating HMI.'  + #13#10 +
                                              '0.0.2.0 : Identification, more functionalities.'  + #13#10 +
                                              '0.0.1.0 : Working on weo.'   ;
                                  UnitType  : 3 ;
                                  Major : 0 ; Minor : 9 ; Release : 1; Build : 5 );
{$ENDIF}

type

  { TFWXMLColumn }
  { Special XML FWColumn}

  TFWXMLSource = class(TFWSource)
   private
    FPageControlDetails : TPageControl ;
    FPanelDetails : TPanel ;
   published
    property PageControlDetails  : TPageControl read FPageControlDetails write FPageControlDetails ;
    property PanelDetails : TPanel  read FPanelDetails write FPanelDetails ;
  end;

  TFWXMLColumnClass = class of TFWXMLSource;

 { TFWSources }
 {Collection of FWXMLColumn}

  TFWXMLColumns = class(TFWSources)
  public
    function Add: TFWXMLSource;
  end;

  { TF_XMLForm }
  { Form created from XML}

  TF_XMLForm = class(TF_CustomFrameWork)
  private
  { Déclarations privées }
    gfin_FormIni : TOnFormInfoIni ;
    FPageControl : TPageControl ;
    FMainPanel   ,
    FActionPanel : TPanel;
    gr_Function : TLeonFunction ;
    gfwe_Password, gfwe_Login : TFWEdit;
    function fpc_CreatePageControl(const awin_Parent: TWinControl;
      const as_Name: String; const apan_PanelOrigin: TWinControl): TPageControl;
    function fscb_CreateTabSheet(var apc_PageControl: TPageControl;
      const awin_ParentPageControl, awin_PanelOrigin: TWinControl;
      const as_Name, as_Caption: String): TScrollBox;
    procedure p_CloseLoginAction(AObject: TObject;
      var ACLoseAction: TCloseaction);
    procedure p_LoginCancelClick(AObject: TObject);
    procedure p_LoginOKClick(AObject: TObject);
    procedure p_printGrid(AObject: TObject);
    procedure p_setFunction ( const a_Value : TLeonFunction );
    procedure p_setNodeId(const anod_FieldId, anod_FieldIsId : TALXMLNode;  const afws_Source : TFWXMLSource);
  protected
    gxml_SourceFile : TALXMLDocument ;
    procedure p_ScruteComposantsFiche (); override;
    procedure p_setChoiceComponent(const argr_Control: TDBRadioGroup); virtual;
    procedure p_CreateCsvFile(const afd_FieldsDefs: TFieldDefs; const afws_Source : TFWXMLSource ); virtual;
    procedure p_setControl ( const as_BeginName : String ;
                             const awin_Control: TWinControl;
                             const awin_Parent: TWinControl;
                             const anod_Field: TALXMLNode;
                             const ai_FieldCounter, ai_counter: Longint ); virtual;
    function fdbc_CreateLookupCombo ( const awin_Parent: TWinControl;
                                      const ads_Connection : TDSSource;
                                      const as_Table, as_FieldsID,
                                            as_FieldsDisplay, as_Name : String;
                                      const alis_IdRelation : TList;
                                      const ai_FieldCounter, ai_Counter : Integer ;
                                      const OneFieldToFill : Boolean
                                      ): TXMLFillCombo; virtual;
    function fdbg_GroupViewComponents ( const afws_source : TFWXMLSource ;
                                        const awin_Parent : TWinControl ;
                                        const ai_Connection : Integer;
                                        const as_NameRelation, as_ConnectionBind,
                                              as_ClassRelation, as_ClassBind, as_OtherClass,
                                              as_fieldsId, as_fieldsDisplay : String;
                                        const aa_FieldsBind : TRelationBind;
                                        const aa_FieldsDisplayNames : Array of String;
                                        const ai_FieldCounter, ai_Counter : Integer
                                        ): TDBGroupView; virtual;
    function ffwc_getRelationComponent( const afws_source : TFWXMLSource ; const awin_Parent : TWinControl ;
                                        const anod_Field: TALXMLNode;
                                        const ai_FieldCounter, ai_Counter : Integer
                                        ) : TWinControl; virtual;
    procedure p_setComponentLeft(const awin_Control: TControl;
      const ab_Column: Boolean);
    procedure p_setFieldComponentTop(const awin_Control: TWinControl;
      const ab_Column: Boolean);
    procedure p_setFieldComponentData(const awin_Control: TWinControl; const afw_Source: TFWXMLSource; const afw_columnField: TFWFieldColumn; const ab_IsLocal : Boolean ); virtual;
    procedure p_setLabelComponent(const awin_Control : TWinControl ; const alab_Label : TFWLabel; const ab_Column : Boolean); virtual;
    function fb_setChoiceProperties(const anod_FieldProperty: TALXMLNode;
      const argr_Control : TDBRadioGroup): Boolean; virtual;
    function  CreateSources: TFWSources; override;
    function  fwin_CreateFieldComponent ( const afws_Source : TFWXMLSource; const awin_Parent : TWinControl ;
                                          const anod_Field : TALXMLNode ;
                                          const ab_isLarge, ab_IsLocal : Boolean ;
                                          const ai_FieldCounter, ai_counter : Longint ):TWinControl;
    function  fwin_CreateFieldComponentAndProperties(const as_Table :String; const anod_Field: TALXMLNode;
                                                  var  ai_FieldCounter : Longint ; const  ai_Counter : Longint ; var  awin_Parent, awin_Last : TWinControl ;
                                                  var ab_Column : Boolean ; const afws_Source : TFWXMLSource ; const afd_FieldsDefs : TFieldDefs ):TWinControl; virtual;
    function fpan_GridNavigationComponents(const awin_Parent: TWinControl; const as_Name : String ;
      const ai_Counter: Integer): TScrollBox; virtual;
    function flab_setFieldComponentProperties( const anod_Field: TALXMLNode; const awin_Control, awin_Parent : TWinControl; const afd_FieldDef : TFieldDef ;
      const ai_Counter: Integer ; const ab_Column : Boolean; const afcf_ColumnField : TFWFieldColumn ): TFWLabel; virtual;
    procedure p_SetFieldButtonsProperties(const anod_Action : TALXMLNode;
      const ai_Counter: Integer); virtual;
    procedure p_setControlName ( const as_FunctionName : String ; const anod_FieldProperty : TALXMLNode ;  const awin_Control : TControl; const ai_Counter : Longint ); virtual;
    function  fb_ChargementNomCol ( const AFWColumn : TFWSource ; const ai_NumSource : Integer ) : Boolean; override;
    procedure p_AfterColumnFrameShow( const aFWColumn : TFWSource ); override;
    procedure DoClose ( var CloseAction : TCloseAction ); override;
    function fb_ChargeDonnees : Boolean; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    function fb_InsereCompteur ( const adat_Dataset : TDataset ;
                                 const aslt_Cle : TStringlist ;
                                 const as_ChampCompteur, as_Table, as_PremierLettrage : String ;
                                 const ach_DebutLettrage, ach_FinLettrage : Char ;
                                 const ali_Debut, ali_LimiteRecherche : Int64 ): Boolean; override;

    {$IFDEF FPC}
    procedure DoShow; override;
    {$ENDIF}
    { Déclarations publiques }
    procedure p_setLogin ( const axml_Login : TALXMLDocument;
                           const axb_ident : TJvXPButton ;
                           const amen_MenuIdent : TMenuItem ;
                           const aiml_Images : TImageList ;
                           const abmp_DefaultImage : TBitmap ;
                           var ai_CountImages : Longint );
    procedure BeforeCreateFrameWork(Sender: TComponent);  override;
    procedure DestroyComponents ( const acom_Parent : TWinControl ); virtual;
    procedure p_CreateFormComponents ( const as_XMLFile, as_Name : String ;  awin_Parent : TWinControl ) ; virtual;
    constructor Create ( AOwner : TComponent ); override;
    property Fonction : TLeonFunction read gr_Function write p_setfunction;
  published
    property ActionPanel : TPanel read FActionPanel write FActionPanel;
    property MainPanel   : TPanel read FMainPanel write FMainPanel;
    property PageControl : TPageControl read FPageControl write FPageControl;
  end;

function fxf_ExecuteNoFonction ( const ai_Fonction                  : LongInt    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteFonction ( const as_Fonction                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteFonctionFile ( const as_FonctionFile                  : String    ; const ab_Ajuster : Boolean        ): TF_XMLForm;
function fxf_ExecuteAFonction ( const alf_Function                  : TLeonFunction    ; const ab_Ajuster : Boolean        ): TF_XMLForm;


implementation

uses u_languagevars, fonctions_proprietes, U_ExtNumEdits,
     fonctions_autocomponents, ALFcnString,
     u_extdbgrid, fonctions_images,
     fonctions_Objets_Dynamiques,
     fonctions_languages, fonctions_reports,
     u_buttons_defs,
     u_buttons_appli, unite_variables, StdCtrls;

var  gb_LoginFormLoaded : Boolean = False;
     gi_LastFormFieldsHeight, gi_LastFormColumnHeight : Longint;


// functions and procédures not methods


{ TFWXMLSource }




////////////////////////////////////////////////////////////////////////////////
// function Add
// Adding a column to form
////////////////////////////////////////////////////////////////////////////////
function TFWXMLColumns.Add: TFWXMLSource;
begin
  Result := TFWXMLSource(inherited Add);
end;

{ TF_XMLForm }

////////////////////////////////////////////////////////////////////////////////
//  Recherche du nom de l'executable pour aller
//  chercher la bonne fonction d'initialisation
////////////////////////////////////////////////////////////////////////////////
Constructor TF_XMLForm.Create(AOwner: TComponent);
Begin

  if not ( csDesigning in ComponentState ) Then
    Try
      GlobalNameSpace.BeginWrite;
      Include(FFormState, fsCreating);

      {$IFDEF FPC}
      CreateNew(AOwner, 1 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      Exclude(FFormState, fsCreating);
    Finally
      GlobalNameSpace.EndWrite;
      gstl_SQLWork := nil ;
      p_InitFrameWork ( AOwner );
      // Creating objects
      p_CreateColumns;

      {$IFDEF SFORM}
      InitSuperForm;
      {$ENDIF}
    End
  Else
   Begin
     inherited ;
     Exit ;
   end;

  DataCloseMessage := True;
  gfwe_Password := nil;
  gfwe_Login    := nil;

end;


// function CreateSources overrided
// Create The TFWXMLColumns into the inherited TF_XMLForm
// returns original and inherited TFWXMLColumns
function TF_XMLForm.CreateSources: TFWSources;
begin
  Result := TFWXMLColumns.Create(Self, TFWXMLSource);
end;

// procedure DestroyComponents
// Destroy all the visible components for the form to be re-used
// Initiate the XML Form
// Parameter : acom_Parent : If not nil destroy only the controls child of acom_Parent
procedure TF_XMLForm.DestroyComponents( const acom_Parent : TWinControl );
var li_i : Integer ;
begin
  for li_i := ComponentCount -1 downto 0 do
    if ( not assigned ( acom_Parent )
        or (( Components [ li_i ] is TWinControl ) and ( acom_Parent = ( Components [ li_i ] as TWinControl ).Parent ))) Then
      Begin
        Components [ li_i ].Free ;
      End ;
  gxml_SourceFile := nil ;
  p_InitFrameWork ( Self );
end;

// Function fb_ChargementNomCol
// Inherited function, just make it true
function TF_XMLForm.fb_ChargementNomCol(const AFWColumn: TFWSource;
  const ai_NumSource: Integer): Boolean;
begin
  Result := True;
end;


// function fpan_GridNavigationComponents
// Create a complete Grid navigation with Navigators returning the child created ScrollBox for the editing form
// awin_Parent : The grid navigation and editing parent
// const as_Name : name for caption
// const ai_Counter : Column counter
function TF_XMLForm.fpan_GridNavigationComponents ( const awin_Parent : TWinControl ; const as_Name : String ; const ai_Counter : Integer ): TScrollBox;
var lpan_ParentPanel : TPanel ;
    lpan_Panel : TPanel ;
    ldbn_Navigator : TExtDBNavigator ;
    ldbg_Grid      : TExtDBGrid ;
    lfwc_Column    : TFWXMLSource ;
    lcon_Control   : TControl ;
begin
  lfwc_Column := Sources [ ai_Counter ] as TFWXMLSource;
  lpan_ParentPanel := fpan_CreatePanel ( awin_Parent, CST_COMPONENTS_PANEL_MAIN + as_Name + IntToStr(ai_counter), Self, alClient );
  lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  lpan_ParentPanel.ShowHint := True;
  lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, alLeft );
  lpan_Panel.Width := CST_GRID_NAVIGATION_WIDTH;
  lpan_Panel.Constraints.MinWidth := CST_GRID_NAVIGATION_MIN_WIDTH;
  ldbn_Navigator := fdbn_CreateNavigation ( lpan_Panel, CST_COMPONENTS_NAVIGATOR_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, False, alTop );
  lfwc_Column.Navigator := ldbn_Navigator;
  ldbg_Grid      := fdbg_CreateGrid ( lpan_Panel, CST_COMPONENTS_DBGRID_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, False, alClient );
  lfwc_Column.Grid := ldbg_Grid;
  lcon_Control := fspl_CreateSplitter ( lpan_ParentPanel, CST_COMPONENTS_SPLITTER_BEGIN + CST_COMPONENTS_DBGRID + as_Name, Self, alLeft );
  lcon_Control.Left := lpan_Panel.Width;
  if ai_Counter = 0 then
    FMainPanel := lpan_ParentPanel;
  lpan_ParentPanel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + as_Name, Self, alClient );
  lfwc_Column.PanelDetails := lpan_ParentPanel;
  lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  lpan_ParentPanel.ShowHint := True;
  lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, alTop );
  ldbn_Navigator := fdbn_CreateNavigation ( lpan_Panel, CST_COMPONENTS_NAVIGATOR_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, True, alTop );
  lfwc_Column.NavEdit := ldbn_Navigator;
  Result := fscb_CreateScrollBox ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_CONTROLS + as_Name, Self, alClient );
  lfwc_Column.Panels.Add.Panel := Result ;
End;


///////////////////////////////////////////////////////////////////////////////////////////
// function TF_XMLForm.fdbc_CreateLookupCombo
// Create the lookup combo box from xml relation
///////////////////////////////////////////////////////////////////////////////////////////
function TF_XMLForm.fdbc_CreateLookupCombo ( const awin_Parent : TWinControl ;
                                             const ads_Connection : TDSSource;
                                             const as_Table, as_FieldsID,
                                                   as_FieldsDisplay, as_Name : String;
                                             const alis_IdRelation : TList;
                                             const ai_FieldCounter, ai_Counter : Integer;
                                             const OneFieldToFill : Boolean )
                                             :TXMLFillCombo;
Begin
  Result :=  TXMLFillCombo.Create(Self);
  if OneFieldToFill
   Then Result.Combo := TExtDBComboInsert.Create ( Self )
   Else Result.Combo := TFWDBLookupCombo.Create ( Self );
  Result.FormRegisteredName:=as_Table;
  p_SetComboProperties ( Result.Combo, Self, ads_Connection, as_Table, as_FieldsID, as_FieldsDisplay, as_Name, alis_IdRelation, ai_FieldCounter, ai_Counter, OneFieldToFill );
end;

// function ffwc_getRelationComponent
// Creates some relationships components, included the full Groupview relationships
// awin_Parent : Parent of all created components
// anod_Field : relationships node
// ab_IsLocal : is relationships not linked to data ?
// ai_FieldCounter : table counter
// ai_Counter : column counter
function TF_XMLForm.ffwc_getRelationComponent ( const afws_source : TFWXMLSource ; const awin_Parent : TWinControl ;
                                                const anod_Field : TALXMLNode ;
                                                const ai_FieldCounter, ai_Counter : Integer )
                                                :TWinControl;
var ldoc_XMlRelation : TALXMLDocument ;
    lnode, lnodeClass,
    lnod_CrossLinkRelation : TALXMLNode;
    ls_ClassLink, ls_ClassBind, ls_ClassBindDB, ls_Connection : String;
    llis_idRelation, llis_DisplayRelation         : TList;
    la_FieldsBind : TRelationBind;
    li_i : Integer;
    lds_Source : TDSSource;
    ls_FieldsID, ls_Name, ls_FieldsDisplay : String;
    lb_OneFieldToFill : boolean;

    //  function fb_ClassRef
    //  Joining a 1-n relationship
    // Parameter JOIN_DAEMON node
    // Returns continuing
    function fb_ClassRef ( const anodeClass : TALXMLNode ):Boolean;
    Begin
      Result := False;
      if ( anodeClass.NodeName = CST_LEON_CLASS_REF )
      and anodeClass.HasAttribute ( CST_LEON_IDREF ) Then
        Begin
          ls_ClassLink := anodeClass.Attributes [ CST_LEON_IDREF ];
          Result := True;
        end;
    end;

    //  function fb_Join_Daemon
    //  Joining a n-n relationship
    // Parameter JOIN_DAEMON and classed nodes
    // Returns continuing
    function fb_Join_Daemon ( const anod_Class : TALXMLNode ):Boolean;
    var li_j : Integer ;
        lnod_Bind : TALXMLNode;
    Begin
      Result := False;   
      if anod_Class.NodeName = CST_LEON_IDREFs Then
        Begin
          ls_ClassBind:=anod_Class.Attributes [ CST_LEON_VALUE ];
        End;
      if anod_Class.NodeName = CST_LEON_RELATION_JOIN Then
        Begin
         for li_j := 0 to anod_Class.ChildNodes.Count - 1 do
           Begin
             lnod_Bind := anod_Class.ChildNodes [ li_j ];
             if lnod_Bind.NodeName =  CST_LEON_RELATION_C_BIND Then
               Begin
                ls_ClassBind   := lnod_Bind.Attributes[CST_LEON_VALUE   ];
                ls_ClassBindDB := lnod_Bind.Attributes[CST_LEON_LOCATION];
                Continue;
               end;
             if lnod_Bind.NodeName =  CST_LEON_RELATION_F_BIND Then
               Begin
                SetLength ( la_FieldsBind, high ( la_FieldsBind) + 2);
                la_FieldsBind [  high ( la_FieldsBind ) ].GroupField := lnod_Bind.Attributes[CST_LEON_VALUE];
                la_FieldsBind [  high ( la_FieldsBind ) ].ClassName  := lnod_Bind.Attributes[CST_LEON_RELATION_CBIND];
                Continue;
               end;
           end;
          Result := True;
          Exit;
        end;
      if anod_Class.NodeName = CST_LEON_NAME Then
        Begin
          ls_Name := anod_Class.Attributes [ CST_LEON_VALUE ];
          Result := True;
        end;
    end;

Begin
  Result := nil;
  if ( anod_Field.NodeName = CST_LEON_RELATION ) then
    Begin
      ls_Connection := '';
      lnode := fnod_GetClassFromRelation(anod_Field);
      llis_IdRelation        := TList.Create;
      llis_DisplayRelation   := TList.Create;
      lnod_CrossLinkRelation := nil;
      ldoc_XMlRelation       := nil;
      try
        // Searching for a probably a N-N relationship
       if lnode.HasChildNodes Then
        for li_i := 0 to lnode.ChildNodes.Count -1 do
          Begin
            lnodeClass := lnode.ChildNodes [ li_i ];
            if fb_ClassRef    ( lnodeClass ) Then Break;
          end;
       if anod_Field.HasChildNodes Then
        for li_i := 0 to anod_Field.ChildNodes.Count -1 do
          Begin
            lnodeClass := anod_Field.ChildNodes [ li_i ];
            if fb_Join_Daemon ( lnodeClass ) Then Continue;
          end;
       // Getting other class
        if ( ls_ClassLink = '' ) then
          ls_ClassLink := fs_GetNodeAttribute( lnode, CST_LEON_IDREFs );
        if ( ls_ClassLink = '' ) then
          ls_ClassLink := fs_GetNodeAttribute( lnode, CST_LEON_IDREF );
        // Getting the class finally
        if ( ls_ClassLink = '' ) then
          ls_ClassLink := fs_GetNodeAttribute( lnode, CST_LEON_ID );
        lb_OneFieldToFill := False;
        /// getting other xml file info
        ldoc_XMlRelation := fdoc_GetCrossLinkFunction( gr_Function.Clep, ls_ClassBind, ls_ClassLink, ls_Connection, llis_IdRelation, llis_DisplayRelation, lnod_CrossLinkRelation, lb_OneFieldToFill );
        ls_FieldsID := fs_GetStringFields  ( llis_IdRelation , '', True );
        lds_Source := DMModuleSources.fds_FindConnection(ls_Connection, True );

        if high ( la_FieldsBind ) < 0 Then
         // 1-N relationships
          Begin
            ls_FieldsDisplay := fs_GetStringFields  ( llis_DisplayRelation, '', True );
            Result := fdbc_CreateLookupCombo ( awin_Parent, lds_Source, ls_ClassLink,
                                               ls_FieldsID, ls_FieldsDisplay,
                                               ls_Name,
                                               llis_idRelation,
                                               ai_FieldCounter, ai_Counter, lb_OneFieldToFill );
          end
         else
           Begin
             ls_FieldsDisplay := fs_GetStringFields  ( llis_DisplayRelation, '', False );
           // N-N N-1 relationships
             Result := fdbg_GroupViewComponents ( afws_source,
                                                  awin_Parent, li_i,
                                                  ls_Name,
                                                  ls_ClassBindDB, ls_ClassLink,
                                                  ls_ClassBind,
                                                  ls_ClassLink,
                                                  ls_FieldsID, ls_FieldsDisplay,
                                                  la_FieldsBind,
                                                  fa_GetArrayFields(llis_DisplayRelation),
                                                  ai_FieldCounter, ai_Counter );

           end;
      finally
        llis_IdRelation.free;
        llis_DisplayRelation.Free;
        lnod_CrossLinkRelation.free;
        ldoc_XMlRelation.free;
      end;
    End;

end;

// function fwin_CreateFieldComponent
// Creates some field components from  anod_Field
// awin_Parent : Parent of created components
// anod_Field : Node which wants a component
// ab_isLarge : Large field
// ab_IsLocal : Not linked to data
// ai_FieldCounter : field counter
// ai_counter : Column counter
function TF_XMLForm.fwin_CreateFieldComponent ( const afws_Source : TFWXMLSource; const awin_Parent : TWinControl ; const anod_Field : TALXMLNode ; const ab_isLarge, ab_IsLocal : Boolean ; const ai_FieldCounter, ai_counter : Longint ):TWinControl;
begin
  // No comment node to create the Control
  if anod_Field is TALXmlCommentNode then
    Begin
      Result := nil;
      Exit;
    End;

  Result := fwin_CreateAFieldComponent ( anod_Field.NodeName, Self, ab_isLarge, ab_IsLocal, ai_counter );

  if  ( Result = nil ) Then
    Result := ffwc_getRelationComponent ( afws_Source, awin_Parent, anod_Field, ai_FieldCounter, ai_counter );

  if ( Result = nil ) then
    Begin
      Showmessage ( Gs_NoComponentToCreate + anod_Field.NodeName +'.' );
      gb_Unload := True;
    End;

end;
procedure TF_XMLForm.p_setControl  ( const as_BeginName : String ; const awin_Control : TWinControl ; const awin_Parent : TWinControl ; const anod_Field : TALXMLNode ; const ai_FieldCounter, ai_counter : Longint );
begin
  awin_Control.Name := as_BeginName + anod_Field.NodeName + IntToStr(ai_counter) + anod_Field.Attributes[CST_LEON_ID] + IntToStr(ai_FieldCounter);
  awin_Control.Parent := awin_Parent ;
  awin_Control.Tag := ai_FieldCounter + 1;
End;

procedure TF_XMLForm.p_setFieldComponentData ( const awin_Control : TWinControl ; const afw_Source : TFWXMLSource ; const afw_columnField : TFWFieldColumn ; const ab_IsLocal : Boolean );
begin
  if not ab_IsLocal Then
    Begin
      p_setComponentProperty       ( awin_Control, 'DataField' , afw_columnField.FieldName );
      p_setComponentObjectProperty ( awin_Control, 'Datasource', afw_Source.Datasource );
    end;
end;
procedure TF_XMLForm.p_setComponentLeft  ( const awin_Control : TControl ; const ab_Column : Boolean );
begin
  if ab_Column then
    awin_Control.Left := CST_XML_SEGUND_COLUMN_MIN_POSWIDTH
   Else
    awin_Control.Left := CST_XML_FIELDS_INTERLEAVING ;
end;

// procedure p_setLabelComponent
// after having fully read the field nodes last setting of label component
// awin_Control : Field Component
// alab_Label : Label to set
// ab_Column : Second editing column
procedure TF_XMLForm.p_setLabelComponent (const awin_Control : TWinControl ; const alab_Label : TFWLabel; const ab_Column : Boolean);
begin
  if assigned ( alab_Label ) then
    Begin
      alab_Label.Top  := awin_Control.Top + ( awin_Control.Height - alab_Label.Height ) div 2 ;
      alab_label.Width := CST_XML_FIELDS_CAPTION_SPACE - CST_XML_FIELDS_LABEL_INTERLEAVING;
      p_setComponentLeft  ( alab_Label, ab_Column );
    End;
end;
// overrided procedure p_AfterColumnFrameShow
// aFWColumn : Column showing
procedure TF_XMLForm.p_AfterColumnFrameShow( const aFWColumn : TFWSource );
begin
end;

// overrided procedure DoClose
// Free the XML Form
// Setting CloseAction to cafree
procedure TF_XMLForm.DoClose(var CloseAction: TCloseAction);
begin
  inherited DoClose(CloseAction);
  CloseAction := caFree;
end;

function TF_XMLForm.fb_ChargeDonnees: Boolean;
begin
  Result:= True;
end;

function TF_XMLForm.fb_InsereCompteur(const adat_Dataset: TDataset;
  const aslt_Cle: TStringlist; const as_ChampCompteur, as_Table,
  as_PremierLettrage: String; const ach_DebutLettrage, ach_FinLettrage: Char;
  const ali_Debut, ali_LimiteRecherche: Int64): Boolean;
begin
  Result:=False;
end;

procedure TF_XMLForm.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if ( Key = VK_RETURN )
  and assigned ( gfwe_Password ) Then
   p_LoginOKClick (Self );
end;

{$IFDEF FPC}
procedure TF_XMLForm.Doshow;
var li_i : Integer;
    lcom_Component : TComponent;
begin
  // No LFM Bug
  for li_i := 0 to ComponentCount - 1 do
    Begin
      lcom_Component := Components [ li_i ];
      {$IFDEF FPC}
      if lcom_Component is TJvXPButton Then
       Begin
        (lcom_Component as TJvXPButton).Loaded;
        Continue;
       end;
      if lcom_Component is TDBGroupView Then
       Begin
         (lcom_Component as TDBGroupView).Loaded;
         Continue;
       end;
      {$ENDIF}
      if ( lcom_Component is TExtDBNumEdit )
      and (( lcom_Component as TExtDBNumEdit ).Field is TIntegerField )   then
        Begin
          ( lcom_Component as TExtDBNumEdit ).NbAfterComma:=0;
        end;

    end;
  inherited;
end;
{$ENDIF}

// procedure p_setLogin
// Special Login model
// axml_Login : XML Document of login form
procedure TF_XMLForm.p_setLogin ( const axml_Login: TALXMLDocument;
                                  const axb_ident : TJvXPButton ;
                                  const amen_MenuIdent : TMenuItem ;
                                  const aiml_Images : TImageList ;
                                  const abmp_DefaultImage : Graphics.TBitmap ;
                                  var ai_CountImages : Longint );
var
    li_i, li_j, li_Counter : Longint;
    lnod_Node, lnod_NodeChild : TALXMLNode ;
    ls_location   : String;
    lwin_Control  : TWinControl;
    lfwl_Label    : TFWLabel;
    lfwc_Column   : TFWXMLSource ;
begin
  DisableAlign ;
  Screen.Cursor := Self.Cursor;
  for li_i := 0 to axml_Login.ChildNodes.Count - 1 do
    Begin
      lnod_Node := axml_Login.ChildNodes [ li_i ];
      if lnod_Node.NodeName = CST_LEON_ACTION Then
        Begin
          lfwc_Column := nil;
          Width  := 350;
          Height := 250 ;
          // Creating Sources
          if lnod_Node.HasChildNodes Then
          for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
            Begin
              lnod_NodeChild := lnod_Node.ChildNodes [ li_j ];
              if  ( lnod_NodeChild.NodeName = CST_LEON_ACTION_PREFIX )
              and not gb_LoginFormLoaded then
               Begin
                 p_setPrefixToMenuAndXPButton ( lnod_NodeChild.Attributes [ CST_LEON_VALUE ], axb_ident, amen_MenuIdent, aiml_Images );
                 gb_LoginFormLoaded := True;
               end;
              if lnod_NodeChild.NodeName = CST_LEON_NAME Then
                Caption := fs_GetLabelCaption(lnod_NodeChild.Attributes [ CST_LEON_VALUE ]);
              if  ( lnod_NodeChild.NodeName = CST_LEON_PARAMETER )
              and lnod_NodeChild.HasAttribute ( CST_LEON_PARAMETER_NAME )
              and ( lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_USER_CLASS )
               Then
                 Begin
                   if lnod_NodeChild.HasAttribute ( CST_LEON_LOCATION ) Then
                     ls_location := lnod_NodeChild.Attributes [ CST_LEON_LOCATION ]
                    else
                     ls_location := '';

                   lfwc_Column := TFWXMLSource ( ffws_CreateSource ( lnod_NodeChild.Attributes [ CST_LEON_IDREF ], ls_location ));
                 end;
            end;
          li_Counter := 0 ;
          // Setting login parameters
          for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
            Begin
              lnod_NodeChild := lnod_Node.ChildNodes [ li_j ];
              if  ( lnod_NodeChild.NodeName = CST_LEON_PARAMETER )
              and lnod_NodeChild.HasAttribute ( CST_LEON_PARAMETER_NAME )
              and (  ( lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_LOGIN_INFO    )
                  or ( lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_PASSWORD_INFO ))
               Then
                Begin
                   Begin
                     lwin_Control := fwin_CreateAEditComponent ( Self, False, True );
                     lwin_Control.Parent := Self;
                     lwin_Control.Left := CST_XML_FIELDS_CAPTION_SPACE;
                     lwin_Control.Width := 120 ;
                     lfwl_Label   := ffwl_CreateALabelComponent ( Self, Self, lwin_Control, lfwc_Column.FieldsDefs.Add, lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ], li_Counter, False );
                     if ( lnod_NodeChild.Attributes [ CST_LEON_PARAMETER_NAME ] = CST_LEON_LOGIN_INFO ) Then
                       Begin
                         li_counter := 0;
                         lwin_Control.Top := 50 ;
                         lfwl_Label  .Top := 50 ;
                         lfwl_Label  .Caption := GS_LOGIN;
                         gfwe_Login := lwin_Control as TFWEdit;
                       end
                      Else
                       Begin
                         li_counter := 1;
                         lwin_Control.Top := 100 ;
                         lfwl_Label  .Top := 100 ;
                         lfwl_Label  .Caption := GS_PASSWORD;
                         gfwe_Password := lwin_Control as TFWEdit;
                         gfwe_Password.PasswordChar:='*';
                       End;
                     p_setLabelComponent ( lwin_Control, lfwl_Label, False );
                     with lfwc_Column.FieldsDefs [ lfwc_Column.FieldsDefs.Count - 1 ] do
                       Begin
                         FieldName:= lnod_NodeChild.Attributes [ CST_LEON_IDREF ];
                         NumTag:= li_counter + 1 ;
                       end;
                   end;
                end;
            end;
          // Setting buttons
          lwin_Control := TFWOK.Create(Self);
          lwin_Control.Parent := Self;
          lwin_Control.Width  := 90;
          lwin_Control.Height := 25;
          lwin_Control.Left:= Width div 2 - ( lwin_Control.Width * 2 ) div 2;
          lwin_Control.Top := 150 ;
          ( lwin_Control as TFWOK ).OnClick := p_LoginOKClick;
          lwin_Control := TFWCancel.Create(Self);
          lwin_Control.Parent := Self;
          lwin_Control.Width  := 90;
          lwin_Control.Height := 25;
          lwin_Control.Left:= Width div 2 + lwin_Control.Width div 2;
          lwin_Control.Top := 150 ;
          ( lwin_Control as TFWCancel ).OnClick := p_LoginCancelClick;
        end;
    end;
  if not gb_LoginFormLoaded Then
    Begin
      gb_LoginFormLoaded := True;
      p_setImageToMenuAndXPButton(abmp_DefaultImage,axb_ident,amen_MenuIdent,aiml_Images);
    end;
  ai_CountImages:=aiml_Images.Count;
  OnClose:=p_CloseLoginAction;
  Name := CST_COMPONENTS_FORM_BEGIN + 'AutoLoginForm' ;
  // Initiate data and showing
  EnableAlign ;
  FormCreate ( Self );
  Position := poDesktopCenter;
//  FormStyle:=fsNoStayOnTop;
  {$IFDEF FPC}
  Visible := True;
  {$ELSE}
  Show;
  {$ENDIF}
end;
// procedure p_CloseLoginAction
// Login close event
procedure TF_XMLForm.p_CloseLoginAction( AObject : TObject; var ACLoseAction : TCloseaction );
Begin
  ACloseAction := caFree;
  gf_users := nil;
end;

// procedure p_LoginOKClick
// Login OK Button event
// AObject : Needed for event
procedure TF_XMLForm.p_LoginOKClick( AObject : TObject );
var lb_ok : Boolean;
Begin
  if assigned ( gNod_DashBoard ) Then
  with Sources [ 0 ] do
   if Datasource.DataSet.Active Then
    Begin
      // no user so can enter
      if Datasource.DataSet.IsEmpty Then
        Begin
          p_CreeAppliFromNode ( '' );
          Close;
          Exit;
        end;
      // Verifying form
      if  not assigned ( gfwe_Password )
      and not Assigned( gfwe_Login ) Then
        Exit;
      lb_ok := False;
      // verifying password
      if FieldsDefs [ 0 ].NumTag = 1 Then
        Begin
          Datasource.DataSet.Locate(FieldsDefs [ 0 ].FieldName,gfwe_Login.Text,[loCaseInsensitive]);
          if Datasource.DataSet.FieldByName(FieldsDefs [ 1 ].FieldName).AsString = gfwe_Password.Text Then
            lb_ok := True;
        end
       Else
        Begin
         Datasource.DataSet.Locate(FieldsDefs [ 1 ].FieldName,gfwe_Login.Text,[loCaseInsensitive]);
         if Datasource.DataSet.FieldByName(FieldsDefs [ 0 ].FieldName).AsString = gfwe_Password.Text Then
           lb_ok := True;
        end;
      if lb_ok Then
        Begin
          gs_user := gfwe_Login.Text;
          p_CreeAppliFromNode ( '' );
          Close;
          Exit;
        end
       Else
        ShowMessage(GS_LOGIN_FAILED);
    end;
end;

// procedure p_LoginCancelClick
// Cancel Click event
procedure TF_XMLForm.p_LoginCancelClick( AObject : TObject );
Begin
  Close;
end;

// procedure p_setControlName
// Setting control name from node
procedure TF_XMLForm.p_setControlName (  const as_FunctionName : String ; const anod_FieldProperty : TALXMLNode ;  const awin_Control : TControl; const ai_Counter : Longint );
Begin
  awin_Control.Name := fs_EraseSpecialChars( awin_Control.ClassName + as_FunctionName + trim ( anod_FieldProperty.Attributes [ CST_LEON_VALUE ] ) + IntToStr ( ai_Counter ));

End;

// procedure p_setFunction
// Creating the components of the form from TLeonFunction into array
// a_Value : Menu function
procedure TF_XMLForm.p_setFunction(const a_Value: TLeonFunction);
var li_i : Integer ;
    li_Action : Longint ;
    lpan_Panel : TPanel;
begin
  with a_Value do
    Begin
      p_CopyLeonFunction ( a_Value, gr_Function );
    End;
 if a_value.AFile = ''
  then Name := a_value.Name
  Else Name := a_value.AFile;
 DisableAlign ;
 try
   Caption := fs_GetLabelCaption ( gr_Function.Name );
   with gr_Function do
     Begin
       // Simple function
      if (high ( Functions ) < 0 ) then
        Begin
          DestroyComponents ( nil );
          p_CreateFormComponents ( gr_Function.AFile,gr_Function.Name, fpan_CreateActionPanel ( Self, Self, FActionPanel ) );
        End
      else
        Begin
          // Compound function
          DestroyComponents ( nil );
          lpan_Panel := fpan_CreateActionPanel ( Self, Self, FActionPanel );
          for li_i := 0 to ( high ( Functions )) do
            Begin
              li_Action := fi_FindAction ( Functions [ li_i ] );
              p_CreateFormComponents ( ga_Functions [ li_Action ].AFile, ga_Functions [ li_Action ].Name, lpan_Panel );
            End;
         End;
     End;
   FormCreate ( Self );

   gfin_FormIni.p_ExecuteLecture(Self);
 finally
   EnableAlign ;
 end;
end;

// procedure p_setChoiceComponent
// After having read child node from choice node setting the height of choice node
// argr_Control : Choice component

procedure TF_XMLForm.p_setChoiceComponent( const argr_Control : TDBRadioGroup );
var li_Size : Integer;
Begin
  with argr_Control do
    begin
      Height:= Items.Count  * gi_FontHeight + flin_getComponentProperty ( argr_Control, 'BorderWidth' )  * 2 ;
    end;
end;


// function fb_setChoiceProperties
// After having read child nodes from component node setting the values of choice node
// anod_FieldProperty : Component Node
// argr_Control : Choice component
function TF_XMLForm.fb_setChoiceProperties ( const anod_FieldProperty : TALXMLNode ; const argr_Control : TDBRadioGroup ): Boolean;
var li_i : LongInt ;
    lnod_ChoiceProperty : TALXMLNode ;
Begin
  Result := False;
  if  ( anod_FieldProperty.NodeName = CST_LEON_CHOICE_OPTIONS )
  and   anod_FieldProperty.HasChildNodes  then
    for li_i := 0 to anod_FieldProperty.ChildNodes.Count -1 do
      Begin
        lnod_ChoiceProperty := anod_FieldProperty.ChildNodes [ li_i ];
        if lnod_ChoiceProperty.NodeName = CST_LEON_CHOICE_OPTION then
          Begin
            argr_Control.Items .Add ( fs_getLabelCaption ( lnod_ChoiceProperty.Attributes [ CST_LEON_OPTION_NAME ]));
            argr_Control.Values.Add ( lnod_ChoiceProperty.Attributes [ CST_LEON_OPTION_VALUE ]);
            Result := True;
            Continue;
          End;
      End;
End;


// Function flab_setFieldComponentProperties
// creating the label component and setting the field component from child nodes
// anod_Field : component node
// awin_Control : created field component
// awin_Parent : Parent component
// afd_FieldDef : Field definitions
// ai_Counter : Field Counter
// afws_Source : XML Form Column
// ab_Column : Segund editing column
// afcf_ColumnField : Field Form column definitions

function TF_XMLForm.flab_setFieldComponentProperties ( const anod_Field : TALXMLNode ; const awin_Control, awin_Parent : TWinControl; const afd_FieldDef : TFieldDef ; const ai_Counter : Longint ; const ab_Column : Boolean ; const afcf_ColumnField : TFWFieldColumn ): TFWLabel;
var li_i : LongInt ;
    ldo_Temp : Double ;
    lnod_FieldProperties : TALXMLNode ;
Begin
  Result := nil;
  if anod_Field.HasChildNodes then
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        ldo_Temp := 0 ;
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if awin_Control is TDBRadioGroup then
          Begin
            fb_setChoiceProperties ( lnod_FieldProperties, awin_Control as TDBRadioGroup );
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_NAME then
          Begin
            if ( awin_Control is TCustomRadioGroup ) Then
              Begin
                p_setComponentProperty ( awin_Control, 'Caption', fs_GetLabelCaption(lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]));
              end
             Else
               REsult := ffwl_CreateALabelComponent ( Self, awin_Parent, awin_Control, afcf_ColumnField, lnod_FieldProperties.Attributes [ CST_LEON_VALUE ], ai_Counter, ab_Column );
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS then
          Begin
            p_setComponentProperty ( awin_Control, 'Rows', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_TIP then
          Begin
            awin_Control.Hint := fs_GetLabelCaption ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            awin_Control.ShowHint := True;
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS then
          Begin
            p_setComponentProperty ( awin_Control, 'Cols', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_MAX then
          Begin
            if ( awin_Control is TDBEdit ) then
              try
                ldo_Temp := lnod_FieldProperties.Attributes [ CST_LEON_VALUE ];
                p_setComponentProperty ( awin_Control, 'MaxLength', ldo_Temp);
                awin_Control.Width := CST_XML_FIELDS_CHARLENGTH * StrToInt ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
              Except
              end
            else if ( awin_Control is TExtNumEdit ) then
              try
                DecimalSeparator := '.' ;
                ldo_Temp := Abs ( StrToFloat ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]));

                if awin_Control.Width < ldo_Temp * CST_XML_FIELDS_CHARLENGTH then
                  awin_Control.Width := length ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ] ) * CST_XML_FIELDS_CHARLENGTH;
                p_setComponentProperty ( awin_Control, 'Max', lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
                p_setComponentBoolProperty ( awin_Control, 'HasMax', True);
              Except
              end;
            try
              if assigned ( afd_FieldDef )
              and ( afd_FieldDef.DataType = ftBlob ) then
                afd_FieldDef.Size := Trunc ( ldo_Temp );
            Except
            end;
            DecimalSeparator := gchar_DecimalSeparator ;
            Continue;
          End;
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_MIN then
          Begin
            if ( awin_Control is TDBEdit ) then
              try
                ldo_Temp := lnod_FieldProperties.Attributes [ CST_LEON_VALUE ];
                p_setComponentProperty ( awin_Control, 'MinLength', ldo_Temp);
              Except
              end
            else if ( awin_Control is TExtNumEdit ) then
              try
                DecimalSeparator := '.' ;
                ldo_Temp := StrToFloat ( lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
                if awin_Control.Width < ldo_Temp * CST_XML_FIELDS_CHARLENGTH then
                  awin_Control.Width := Round ( ldo_Temp * CST_XML_FIELDS_CHARLENGTH );
                p_setComponentProperty ( awin_Control, 'Min', ldo_Temp);
                p_setComponentBoolProperty ( awin_Control, 'HasMin', True);
              Except
              end;
            DecimalSeparator := gchar_DecimalSeparator ;
            Continue;
          End;
      End;
  // after setting the choice component setting the height
  if awin_Control is TDBRadioGroup then
    Begin
      p_setChoiceComponent ( awin_Control as TDBRadioGroup );
    End;

End;

procedure TF_XMLForm.p_printGrid ( AObject : TObject );
Begin
  if Sources.count >  0 Then
   fb_CreateGridReport(Sources [ 0 ].Grid,caption,[]);
end;

// procedure p_SetFieldButtonsProperties
// Setting the editing buttons
// anod_Action : Action node for buttons
// ai_Counter : column counter
// awin_Parent : Parent component
procedure TF_XMLForm.p_SetFieldButtonsProperties ( const anod_Action : TALXMLNode ; const ai_Counter : Longint );
var ls_Action   : String ;
    lbut_Button : TFWXPButton;
begin
  with Sources [ ai_Counter ] do
    if  ( anod_Action.NodeName = CST_LEON_ACTION_REF )
    and assigned ( NavEdit ) then
      Begin
        ls_Action :=  anod_Action.Attributes [ CST_LEON_ACTION_IDREF ];
        if ls_Action = CST_LEON_ACTION_REF_SET then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEPost,nbECancel];
            Exit;
          End;

        if ls_Action = CST_LEON_ACTION_REF_DELETE then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEDelete];
            Exit;
          End;
        if ( ls_Action = CST_LEON_ACTION_REF_ADD   )
        or ( ls_Action = CST_LEON_ACTION_REF_CLONE ) then
          Begin
            NavEdit.VisibleButtons := NavEdit.VisibleButtons + [nbEInsert];
            Exit;
          End;
        if ls_Action = CST_LEON_ACTION_REF_PRINT then
          Begin
            lbut_Button := TFWPrint.Create ( Self );
            fpan_CreateAction ( lbut_Button, CST_COMPONENTS_BUTTON_PRINT, Self, FActionPanel );
            lbut_Button.OnClick:=p_printGrid;
            Exit;
          End;
      End;


end;

procedure TF_XMLForm.p_setNodeId ( const anod_FieldId, anod_FieldIsId : TALXMLNode;  const afws_Source : TFWXMLSource);
Begin
  if anod_FieldIsId.HasAttribute ( CST_LEON_ID)
  and not ( anod_FieldIsId.Attributes [ CST_LEON_ID ] = CST_LEON_BOOL_FALSE )  then
    Begin
      if afws_Source.Key  = '' then
        afws_Source.Key := anod_FieldId.Attributes [CST_LEON_ID]
       else
        afws_Source.Key := afws_Source.Key + FieldDelimiter + anod_FieldId.Attributes [CST_LEON_ID];
    End;
end;

procedure TF_XMLForm.p_ScruteComposantsFiche();
begin
end;

// procedure p_CreateFieldComponentAndProperties
// Creating the column components
// as_Table : Table Name
// anod_Field: Node field
// ai_FieldCounter : Field counter
//  ai_Counter : Column counter
// awin_Parent : Parent component
// ab_Column : Second editing column
// afws_Source : XML form Column
// afd_FieldsDefs : Field Definitions
function TF_XMLForm.fwin_CreateFieldComponentAndProperties (const as_Table :String; const anod_Field: TALXMLNode; var  ai_FieldCounter : Longint ; const ai_Counter : Longint ; var awin_Parent, awin_Last : TWinControl ; var ab_Column : Boolean ; const afws_Source : TFWXMLSource ; const afd_FieldsDefs : TFieldDefs ):TWinControl;
var lnod_FieldProperties : TALXMLNode ;
    llab_Label  : TFWLabel;
    lb_IsLarge, lb_IsLocal  : Boolean;
    lfd_FieldDef : TFieldDef;
    lffd_ColumnFieldDef : TFWFieldColumn;
    lwin_Last : TWinControl;
    lnod_OriginalNode : TALXmlNode;
    lxfc_ButtonCombo : TXMLFillCombo;

    // Function fb_getFieldOptions
    // setting some data properties
    // Result : quitting
    function fb_getFieldOptions: Boolean;
    begin
      Result := False;
      if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_MARKS then
        Begin
          if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_local )
          and not ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_local ] = CST_LEON_BOOL_FALSE )  then
            Begin
              lb_IsLocal := True;
            End;
          if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_CREATE)
           then lffd_ColumnFieldDef.ColCree  := lnod_FieldProperties.Attributes [ CST_LEON_FIELD_CREATE ] = CST_LEON_BOOL_TRUE;
          if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_UNIQUE)
           then lffd_ColumnFieldDef.ColUnique  := lnod_FieldProperties.Attributes [ CST_LEON_FIELD_UNIQUE ] = CST_LEON_BOOL_TRUE;
          p_setNodeId ( anod_Field, lnod_FieldProperties, afws_Source );
          if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_hidden )
          and not ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_hidden ] = CST_LEON_BOOL_FALSE )  then
            Begin
              lffd_ColumnFieldDef.AffiCol := -1;
              lffd_ColumnFieldDef.AffiRech := -1;
              Result := True;
              Exit;
            End;
          lffd_ColumnFieldDef.AffiCol := ai_counter + 1;
          if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_optional)
          and not ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_optional ] = CST_LEON_BOOL_TRUE )  then
            Begin
              lffd_ColumnFieldDef.ColObl  := False;
              lffd_ColumnFieldDef.AffiCol := -1;
            End
           Else
            lffd_ColumnFieldDef.ColObl := True;
          if ( lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_sort)
               and ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_sort ] = CST_LEON_BOOL_TRUE ))
          or ( lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_find)
               and ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_find ] = CST_LEON_BOOL_TRUE ))  then
            Begin
              lffd_ColumnFieldDef.AffiRech := ai_counter + 1;
            End
        End;

    end;

    // procedure p_CreateArrayStructComponents
    // Creating groupbox with controls
    procedure p_CreateArrayStructComponents ;
    var li_k, li_l, li_FieldCounter : LongInt ;
        lb_column : Boolean;
        ls_NodeId : String;
        lwin_Parent : TWinControl;
        lnod_FieldsNode : TALXmlNode;
        ls_Table : String ;
        lfwc_Column : TFWXMLSource ;
        lfd_FieldsDefs : TFieldDefs ;
    begin
      ls_NodeId := anod_Field.Attributes[CST_LEON_ID];
      Result := fgrb_CreateGroupBox(awin_Parent,CST_COMPONENTS_GROUPBOX_BEGIN + ls_NodeId + IntToStr(ai_FieldCounter),Self,alNone);
      lb_IsLocal := False;
      lnod_OriginalNode := fnod_GetNodeFromTemplate(anod_Field);
      if anod_Field <> lnod_OriginalNode Then
       Begin
        ls_Table:=lnod_OriginalNode.Attributes[CST_LEON_ID];
        lfwc_Column  := TFWXMLSource ( ffws_CreateSource(ls_Table,lnod_OriginalNode.Attributes[CST_LEON_LOCATION] ));
        lfd_FieldsDefs := fobj_GetcomponentObjectProperty ( lfwc_Column.Datasource.Dataset, 'FieldDefs' ) as TFieldDefs;
        li_FieldCounter := 0 ;
        with afws_Source.Linked.Add do
          Begin
            Source:=lfwc_Column;
            LookupFields := ls_NodeId;
          end;
        with lfwc_Column.Linked.Add do
          Begin
            Source:=afws_Source;
          end;
       end;
      if lnod_OriginalNode.HasChildNodes then
        for li_k := 0 to lnod_OriginalNode.ChildNodes.Count - 1 do
          Begin
            lnod_FieldsNode := lnod_OriginalNode.ChildNodes [ li_k ];
            if lnod_FieldsNode.NodeName = CST_LEON_NAME then
              Begin
                p_SetComponentProperty(Result,'Caption',fs_GetLabelCaption(lnod_FieldsNode.Attributes[CST_LEON_VALUE]));
                Continue;
              End;
            if (   lnod_OriginalNode.NodeName = CST_LEON_STRUCT )
            and lnod_OriginalNode.ChildNodes [ li_k ].HasChildNodes then
              Begin
                lb_column := False;
                lwin_Parent := Result ;
                lwin_Last := nil;
                if lnod_FieldsNode.NodeName = CST_LEON_FIELDS Then
                  Begin
                    for li_l := 0 to lnod_FieldsNode.ChildNodes.Count - 1 do
                      Begin
                        if anod_Field <> lnod_OriginalNode Then
                          fwin_CreateFieldComponentAndProperties ( ls_Table   , lnod_FieldsNode.ChildNodes [ li_l ], li_FieldCounter, Sources.Count - 1,
                                                                   lwin_Parent, lwin_Last, lb_column, lfwc_Column, lfd_FieldsDefs )
                         else
                          fwin_CreateFieldComponentAndProperties ( as_Table   , lnod_FieldsNode.ChildNodes [ li_l ], ai_FieldCounter, ai_Counter,
                                                                   lwin_Parent, lwin_Last, ab_column, afws_Source, afd_FieldsDefs );
                      end;
                  end
                 Else
                  // The parent parameter is a var : so do not want to change it in the function
                  if anod_Field <> lnod_OriginalNode Then
                    fwin_CreateFieldComponentAndProperties ( ls_Table   , lnod_OriginalNode.ChildNodes [ li_k ], li_FieldCounter, Sources.Count - 1,
                                                             lwin_Parent, lwin_Last, lb_column, lfwc_Column, lfd_FieldsDefs )
                   else
                    fwin_CreateFieldComponentAndProperties ( as_Table   , lnod_FieldsNode.ChildNodes [ li_k ], ai_FieldCounter, ai_Counter,
                                                             lwin_Parent, lwin_Last, ab_column, afws_Source, afd_FieldsDefs );
                inc ( li_FieldCounter );
                lb_IsLocal:=True;
              end;
          end;
      p_setFieldComponentTop ( Result, ab_Column );
      p_setComponentLeft  ( Result, ab_Column );

    end;

    // procedure p_CreateComponents
    // Creating the component and setting data link

    function fb_CreateComponents ( var awin_Control : TWinControl ) : Boolean ;
    var li_k : LongInt ;
    Begin
      Result := False;
      if ( anod_Field.NodeName = CST_LEON_ARRAY )
      or ( anod_Field.NodeName = CST_LEON_STRUCT )
       Then
        Begin
          p_CreateArrayStructComponents;
          // Quitting because having created component
          Result := True;
          Exit;
        end;
      if ( anod_Field.Attributes [ CST_LEON_ID ] <> Null ) then
        Begin
          lffd_ColumnFieldDef := afws_Source.FieldsDefs.Add ;
          with lffd_ColumnFieldDef do
            begin
              NomTable    := as_Table;
              NumTag      := ai_Fieldcounter + 1;
              FieldName   := anod_Field.Attributes [ CST_LEON_ID ];
              AffiRech    := -1;
            end;
        End
       else
         Begin
    //      lffd_ColumnFieldDef := nil;
          Exit;
         End;

      lb_IsLocal := False;

      lb_IsLarge := False;
      if anod_Field.HasChildNodes then
        for li_k := 0 to anod_Field.ChildNodes.Count -1 do
          Begin
            lnod_FieldProperties := anod_Field.ChildNodes [ li_k ];
            if fb_getFieldOptions Then
              Exit;
            if ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS )
            or ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS ) then
              lb_IsLarge := True;
          End;
      if afws_Source.Connection.DatasetType = dtCSV then
        Begin
          lfd_FieldDef := ffd_CreateFieldDef ( anod_Field, lb_IsLarge, afd_FieldsDefs );
        End
       Else
        lfd_FieldDef := nil ;

      awin_Control := fwin_CreateFieldComponent ( afws_Source, awin_Parent, anod_Field, lb_IsLarge, lb_IsLocal, ai_FieldCounter, ai_counter );

      if not assigned ( awin_Control )
      or ( awin_Control is TDBGroupView ) then
        Exit;

      // The created control must be set and placed

      Result := True;

      if awin_Control is TXMLFillCombo
       then
         Begin
           lxfc_ButtonCombo := awin_Control as TXMLFillCombo;
           p_setControl( 'xfc_', awin_Control, awin_Parent, anod_Field, ai_FieldCounter, ai_Counter);
           awin_Control := ( awin_Control as TXMLFillCombo ).Combo;
         end;

      p_setControl( 'con_', awin_Control,awin_Parent, anod_Field, ai_FieldCounter, ai_Counter);

      p_setFieldComponentTop ( awin_Control, ab_Column );

      p_setFieldComponentData ( awin_Control, afws_Source, lffd_ColumnFieldDef, lb_IsLocal );

      llab_Label := flab_setFieldComponentProperties ( anod_Field, awin_Control, awin_Parent, lfd_FieldDef, ai_Counter, ab_Column, lffd_ColumnFieldDef );

      if assigned ( llab_Label ) Then
        p_setLabelComponent ( awin_Control, llab_Label, ab_Column )
       Else
        p_setComponentLeft  ( awin_Control, ab_Column );
    end;

    // procedure p_SetParentWidth
    // Setting parent component width
    procedure p_SetParentWidth ;
    Begin
      if Result.Left + Result.Width + CST_XML_FIELDS_INTERLEAVING > awin_Parent.ClientWidth Then
        awin_Parent.ClientWidth := Result.Left + Result.Width + CST_XML_FIELDS_INTERLEAVING;
      awin_Parent.ClientHeight := Result.Top + Result.Height + CST_XML_FIELDS_INTERLEAVING;
    end;

begin
   Result := nil;
   // create eventually a tabsheet if too many controls
   If  ( gi_LastFormFieldsHeight > CST_XML_DETAIL_MINHEIGHT)
   and not ( awin_Parent is TGroupBox ) Then
     with afws_Source do
       Begin
         gi_LastFormFieldsHeight := 0;
         gi_LastFormColumnHeight := 0;
         ab_Column:=False;
         awin_Parent := fscb_CreateTabSheet ( FPageControlDetails, FPanelDetails, awin_Parent,
                          CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter )+ '_' +IntToStr ( ai_Counter ),
                          {$IFNDEF FPC}UTF8Decode{$ENDIF}( Gs_DetailsSheet ));
         afws_Source.Panels.add.Panel := awin_Parent;
       End;

  // Initing fb_CreateComponents
  lxfc_ButtonCombo := nil;

  // Placing the created control
  if fb_CreateComponents ( Result )  Then
    if assigned ( Result ) Then
      Begin
        if awin_Last <> nil then
          Begin
            Result.Top := awin_Last.Top + awin_Last.Height + CST_XML_FIELDS_INTERLEAVING;
            if Assigned(llab_Label) Then
              llab_Label.Top:=Result.Top;
            p_SetParentWidth ;
            awin_Last := Result;
          end
         Else
          if ( awin_Parent is TGroupBox )
           Then
             Begin
               Result.Top:=CST_XML_FIELDS_INTERLEAVING;
               if Assigned(llab_Label) Then
                 llab_Label.Top:=CST_XML_FIELDS_INTERLEAVING;
               p_SetParentWidth ;
               awin_Last := Result;
             end
            Else
            Begin
              ab_Column := Result.Width + Result.Left < CST_XML_SEGUND_COLUMN_MIN_POSWIDTH;
              if FMainPanel.Left + Sources [ 0 ].Grid.Width + Result.Left + Result.Width > Width then
                Width := FMainPanel.Left + Sources [ 0 ].Grid.Width + Result.Left + Result.Width;
              gi_LastFormColumnHeight := gi_LastFormFieldsHeight;
              if gi_LastFormFieldsHeight < Result.Top + Result.Height then
                Begin
                  gi_LastFormFieldsHeight := Result.Top + Result.Height ;
                  if FMainPanel.Top + FActionPanel.Height + Result.Top + Result.Height > Height then
                    Height := FMainPanel.Top + Result.Top + FActionPanel.Height + Result.Height;

                End;
            end ;
      end;
  if assigned ( lxfc_ButtonCombo ) Then
    Begin
      lxfc_ButtonCombo.AutoPlace;
    end;
end;

// procedure p_CreateCsvFile
// Creating CSV file
// afd_FieldsDefs : field definition
//  afws_Source   : Column definition
procedure TF_XMLForm.p_CreateCsvFile ( const afd_FieldsDefs : TFieldDefs ; const afws_Source : TFWXMLSource );
var lstl_File : TStringList;
    ls_FileInside : String ;
    li_i : Longint;
Begin
  if  ( afws_Source.Connection.DatasetType = dtCSV )
  and not FileExists ( fs_getFileNameOfTableColumn ( afws_Source ))
  and ( afd_FieldsDefs.count > 0 )
   Then
    Begin
      lstl_File := TStringList.create ;
      try
        ls_FileInside := '' ;
        for li_i := 0 to afd_FieldsDefs.count -1 do
          Begin
            if li_i = 0 then
              ls_FileInside := afd_FieldsDefs [ li_i ].Name
             else
              ls_FileInside := ls_FileInside + gch_SeparatorCSV + afd_FieldsDefs [ li_i ].Name
          End;
        lstl_File.text := ls_FileInside ;
        lstl_File.SaveToFile ( fs_getFileNameOfTableColumn ( afws_Source ));
      finally
        lstl_File.free;
      end;
    End;
End;

// procedure p_CreateFormComponents
// Create a form from XML File
// as_XMLFile : XML File
// as_Name : Name of form
// awin_Parent : Parent component
// ai_Counter : The column counter for other XML File
procedure TF_XMLForm.p_CreateFormComponents ( const as_XMLFile, as_Name : String ; awin_Parent : TWinControl );
var li_i, li_j, li_NoField : LongInt ;
    lnod_Node : TALXMLNode ;
    ls_ProjectFile : String ;
    lb_Column, lb_FieldFound, lb_Table : Boolean ;
    lfwc_Column : TFWXMLSource ;
    lfd_FieldsDefs : TFieldDefs ;
    lwin_Last : TWinControl;
    li_Counter : Integer;
  // child procedure p_CreateParentAndFieldsComponent
  // Creates the navigation grid and fields components
  // anod_ANode : current node
  procedure p_CreateParentAndFieldsComponent ( const anod_ANode : TALXMLNode );
  Begin
    if not lb_FieldFound Then
      Begin
        if ( Sources.Count = 1 ) Then
            Begin
              awin_Parent := fpan_GridNavigationComponents ( awin_Parent, as_Name, Sources.Count - 1 );
              Hint := fs_GetLabelCaption ( as_Name );
              ShowHint := True;
            End
         else
          Begin
            awin_Parent := fscb_CreateTabSheet ( FPageControl, Self, FMainPanel, as_Name, as_Name );
            awin_Parent := fpan_GridNavigationComponents ( awin_Parent, as_Name , Sources.Count - 1);
          End;
        lb_FieldFound := True;
      end;
    lwin_Last := nil;
    if lnod_Node.Attributes [ CST_LEON_ID ] = Null then
      fwin_CreateFieldComponentAndProperties ( '', anod_ANode, li_NoField, li_Counter, awin_Parent, lwin_Last, lb_Column, lfwc_Column, lfd_FieldsDefs )
     else
      fwin_CreateFieldComponentAndProperties ( lnod_Node.Attributes [ CST_LEON_ID ], anod_ANode, li_NoField, li_Counter, awin_Parent, lwin_Last, lb_Column, lfwc_Column, lfd_FieldsDefs );
    inc ( li_NoField );

  end;

  // procedure p_CreateFieldsButtonsComponents
  // Creates the Fields and buttons
  // anod_ANode : current node
  procedure p_CreateFieldsButtonsComponents ( const anod_ANode : TALXMLNode );
  var li_k : Longint;
  Begin
    if  ( anod_ANode.NodeName = CST_LEON_FIELDS ) then
      Begin
        lb_Column := False ;
        for li_k := 0 to anod_ANode.ChildNodes.Count -1 do
          Begin
            p_CreateParentAndFieldsComponent ( anod_ANode.ChildNodes [ li_k ] );
          End;
       p_CreateCsvFile ( lfd_FieldsDefs, lfwc_Column );
      End;
    if  ( anod_ANode.NodeName = CST_LEON_ACTIONS ) then
        Begin
          for li_k := 0 to anod_ANode.ChildNodes.Count -1 do
            Begin
              p_SetFieldButtonsProperties ( anod_ANode.ChildNodes [ li_k ], li_Counter );
            End;
        End;
  End;
  // procedure p_CreateXMLColumn
  // Creates the XML form column
  // as_Table : Table name
  // as_Connection : Connection name
  procedure p_CreateXMLColumn ( const as_Table, as_Connection : String );
  Begin
    lfd_FieldsDefs := nil;
    lfwc_Column := TFWXMLSource ( ffws_CreateSource ( as_Table, as_Connection ));
    ConnectionName := as_Connection;
    if lfwc_Column.Connection.DatasetType = dtCSV then
      Begin
        lfd_FieldsDefs := fobj_GetcomponentObjectProperty ( lfwc_Column.Datasource.Dataset, 'FieldDefs' ) as TFieldDefs;
      End;
  end;

begin
  if not assigned ( gxml_SourceFile ) Then
    gxml_SourceFile := TALXMLDocument.Create ( Self );
  ls_ProjectFile := fs_getProjectDir ( ) + as_XMLFile + CST_LEON_File_Extension;
  // For actions at the end of xml file
  li_Counter := Sources.Count;
  If ( FileExists ( ls_ProjectFile )) Then
   // reading the special XML form File
    try
      gi_LastFormFieldsHeight := 0;
      li_NoField := 0;
      if fb_LoadXMLFile ( gxml_SourceFile, ls_ProjectFile ) Then
        Begin
          lb_FieldFound := False;
          for li_i := 0 to gxml_SourceFile.ChildNodes.Count -1 do
            Begin
              lnod_Node := gxml_SourceFile.ChildNodes [ li_i ];
              if ( lnod_Node.NodeName = CST_LEON_CLASS  )
              or ( lnod_Node.NodeName = CST_LEON_STRUCT ) then
                Begin
                  if not lb_FieldFound Then
                    Begin
                      lb_Table:=False;
                      for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
                        Begin
                          if lnod_Node.ChildNodes [ li_j ].NodeName = CST_LEON_CLASS_BIND Then
                           with lnod_Node.ChildNodes [ li_j ] do
                            Begin
                              p_CreateXMLColumn (Attributes [ CST_LEON_VALUE ], Attributes [ CST_LEON_LOCATION ]);
                              lb_Table := True;
                              Break;
                            end;
                        end;
                      if not lb_Table Then
                        p_CreateXMLColumn ( lnod_Node.Attributes [ CST_LEON_ID ], '' );
                    end;
                  for li_j := 0 to lnod_Node.ChildNodes.Count -1 do
                    Begin
                      p_CreateFieldsButtonsComponents ( lnod_Node.ChildNodes [ li_j ]);

                    End;
                End;
              if ( lnod_Node.NodeName = CST_LEON_FIELD_NUMBER   )
              or ( lnod_Node.NodeName = CST_LEON_FIELD_DATE     )
              or ( lnod_Node.NodeName = CST_LEON_RELATION       )
              or ( lnod_Node.NodeName = CST_LEON_FIELD_TEXT     )
              or ( lnod_Node.NodeName = CST_LEON_FIELD_CHOICE   )
              or ( lnod_Node.NodeName = CST_LEON_FIELD_FILE     )
                Then
                  Begin
{                    if not lb_FieldFound Then
                      Begin
                        p_CreateXMLColumn ( lnod_Node );
                      end;
                    p_CreateFieldComponent ( lnod_Node );
                    lb_FieldFound := True;               }
                  end;
              if ( lnod_Node.NodeName = CST_LEON_ACTION  ) Then
                 p_SetFieldButtonsProperties ( lnod_Node, li_Counter );
            End;
        End;
    Except
      On E: Exception do
        Begin
          ShowMessage ( 'Erreur : ' + E.Message );
        End;
    End ;

end;


// function fdbg_GroupViewComponents
// Creates a full N-N or N-1 relationships management
// awin_Parent : the parent component of the created components
// anod_NodeRelation : The relationships node
// const alis_ListCrossLink : The other side relationships
// ai_FieldCounter : Table counter
// ai_Counter : Column Counter
// returns the main list

function TF_XMLForm.fdbg_GroupViewComponents ( const afws_source : TFWXMLSource ;
                                               const awin_Parent : TWinControl ;
                                               const ai_Connection : Integer;
                                               const as_NameRelation,as_ConnectionBind,
                                                     as_ClassRelation, as_ClassBind,
                                                     as_OtherClass,
                                                     as_fieldsId, as_fieldsDisplay : String;
                                               const aa_FieldsBind : TRelationBind;
                                               const aa_FieldsDisplayNames : Array of String;
                                               const ai_FieldCounter, ai_Counter : Integer ):TDBGroupView;
var lpan_ParentPanel   : TWinControl;
    lpan_GroupViewRight,
    lpan_PanelActions,
    lpan_Panel : TPanel ;
    ldgv_GroupViewRight : TDBGroupView ;
    lcon_Control   : TControl;

    procedure p_setGroupmentfields ( const adgv_GroupView : TDBGroupView );
    Begin
      with adgv_GroupView do
        if pos ( as_OtherClass, aa_FieldsBind [ 0 ].GroupField ) = 0 Then
         Begin
           DataFieldGroup := aa_FieldsBind [ 0 ].GroupField;
           DataFieldUnit  := aa_FieldsBind [ 1 ].GroupField;
         end
        Else
        Begin
          DataFieldGroup := aa_FieldsBind [ 1 ].GroupField;
          DataFieldUnit  := aa_FieldsBind [ 0 ].GroupField;
        end
    end;

    procedure p_setLeftFromPanel ( const acon_Control : TWinControl );
    Begin
      acon_Control.Left := lpan_panel.Left + lpan_panel.Width + 1;
    end;

    procedure p_setLeftToPanel ( const acon_Control : TWinControl );
    Begin
      lpan_panel.Left := acon_Control.Left + acon_Control.Width + 1;
    end;

    procedure p_setTopFromPanel ( const acon_Control : TWinControl );
    Begin
      acon_Control.Top := lpan_panel.Top + lpan_panel.Height + 1;
    end;

    procedure p_setTopToPanel ( const acon_Control : TWinControl );
    Begin
      lpan_panel.Top := acon_Control.Top + acon_Control.Height + 1;
    end;

    // procedure p_setAndCreateButtons;
    // Create The buttons of the main group view
    procedure p_CreateAndSetButtonsActions;
    Begin
      with Result do
        Begin
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_ACTIONS + as_ClassRelation + '1', Self, alLeft );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonRecord := TFWRecord.Create ( Self );
          lpan_PanelActions.Height := ButtonRecord.Height;
          ButtonRecord.Name := CST_COMPONENTS_RECORD_BEGIN + as_ClassRelation;
          ButtonRecord.Parent := lpan_PanelActions;
          ButtonRecord.Align := alLeft ;
          p_setLeftFromPanel ( ButtonRecord );
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_ACTIONS + as_ClassRelation + '2', Self, alLeft );
          p_setLeftToPanel ( ButtonRecord );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonCancel := TFWCancel.Create ( Self );
          ButtonCancel.Parent := lpan_PanelActions;
          ButtonCancel.Name := CST_COMPONENTS_ABORT_BEGIN + as_ClassRelation;
          ButtonCancel.Align := alLeft ;
          ButtonCancel.Width := ButtonRecord.Width;
          p_setLeftFromPanel ( ButtonCancel );
        end;
    end;

    // procedure p_setAndCreateButtons;
    // Create The buttons of the main group view
    procedure p_CreateAndSetButtonsMoving;
    Begin
      with Result do
        Begin
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + as_ClassRelation + '1', Self, alTop );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonIn := TFWInSelect.Create ( Self );
          ButtonIn.Name := CST_COMPONENTS_IN_BEGIN + as_ClassRelation;
          ( ButtonIn as TFWGroupButtonMoving ).Caption := '' ;
          lpan_PanelActions.Width := ButtonIn.Width;
          ButtonIn.Parent := lpan_PanelActions;
          p_setTopFromPanel ( ButtonIn );
          ButtonIn.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + as_ClassRelation + '2', Self, alTop );
          p_setTopToPanel ( ButtonIn );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonOut := TFWOutSelect.Create ( Self );
          ButtonOut.Name := CST_COMPONENTS_OUT_BEGIN + as_ClassRelation;
          ( ButtonOut as TFWGroupButtonMoving ).Caption := '' ;
          ButtonOut.Parent := lpan_PanelActions;
          p_setTopFromPanel ( ButtonOut );
          ButtonOut.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + as_ClassRelation + '3', Self, alTop );
          p_setTopToPanel ( ButtonOut );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonTotalIn := TFWInAll.Create ( Self );
          ButtonTotalIn.Name := CST_COMPONENTS_INALL_BEGIN + as_ClassRelation;
          ( ButtonTotalIn as TFWGroupButtonMoving ).Caption := '' ;
          ButtonTotalIn.Parent := lpan_PanelActions;
          p_setTopFromPanel ( ButtonTotalIn );
          ButtonTotalIn.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + as_ClassRelation + '4', Self, alTop );
          p_setTopToPanel ( ButtonTotalIn );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonTotalOut := TFWOutAll.Create ( Self );
          ButtonTotalOut.Name := CST_COMPONENTS_OUTALL_BEGIN + as_ClassRelation;
          ( ButtonTotalOut as TFWGroupButtonMoving ).Caption := '' ;
          ButtonTotalOut.Parent := lpan_PanelActions;
          p_setTopFromPanel ( ButtonTotalOut );
          ButtonTotalOut.Align := alTop ;
        end;
    end;

    // procedure p_setButtons;
    // sets The buttons of the segund group view
   procedure p_setButtons;
    Begin
      with ldgv_GroupViewRight do
        Begin
          DataListPrimary := False;
          DataListOpposite := Result;
          ButtonRecord   := Result.ButtonRecord;
          ButtonCancel   := Result.ButtonCancel;
          ButtonIn       := Result.ButtonOut;
          ButtonTotalIn  := Result.ButtonTotalOut;
          ButtonOut      := Result.ButtonIn;
          ButtonTotalOut := Result.ButtonTotalIn;
        end;
    end;
   procedure p_setGroupView ( const adgv_GroupView : TDBGroupView; const ab_Primary : Boolean );
   var li_i : Integer;
   Begin
     with adgv_GroupView do
       Begin
         FieldDelimiter    := ',';
         DataKeyOwner      := afws_source.Key;
         DataKeyUnit       := as_fieldsId;
         DataFieldsDisplay := as_fieldsDisplay;
         DataTableGroup    := as_ClassBind;
         DataTableOwner    := afws_source.Table;
         DataTableUnit     := as_OtherClass;
         if ab_Primary Then
           Begin
             DataListPrimary  := True;
             DataListOpposite := ldgv_GroupViewRight;
           end
          else
           Begin
             DataListPrimary  := False;
             DataListOpposite := Result;
           end;
         DataSourceOwner := afws_source.Datasource;
         for li_i := 0 to high ( aa_FieldsDisplayNames ) do
           with Columns.Add do
             begin
               Caption := fs_GetLabelCaption(aa_FieldsDisplayNames [ li_i ]);
             end;
         ShowColumnHeaders:=True;
       end;

   end;

begin
  with afws_source do
    Begin
      lpan_ParentPanel := fscb_CreateTabSheet ( FPageControlDetails, FPanelDetails, awin_Parent, CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter ), as_NameRelation );
      {$IFDEF FPC}
      lpan_ParentPanel.BeginUpdateBounds;
      {$ENDIF}
      try
  //      lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  //      lpan_ParentPanel.ShowHint := True;
        Result := fdgv_CreateGroupView ( lpan_ParentPanel, CST_COMPONENTS_GROUPVIEW_BEGIN + as_ClassRelation + CST_COMPONENTS_LEFT, Self, alLeft );
        Result.Width := CST_GROUPVIEW_WIDTH;
        p_setGroupmentfields ( Result );
        p_AddGroupView ( Result );
        lpan_PanelActions := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_ACTIONS + as_ClassRelation, Self, alTop );
        lpan_GroupViewRight := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + as_ClassRelation + CST_COMPONENTS_RIGHT, Self, alClient );
        // Creating and setting buttons
        p_CreateAndSetButtonsActions;
        lpan_PanelActions := fpan_CreatePanel ( lpan_GroupViewRight, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_MIDDLE + as_ClassRelation, Self, alLeft );
        lpan_Panel.width := CST_GROUPVIEW_INOUT_WIDTH + CST_XML_FIELDS_INTERLEAVING * 2;
        ldgv_GroupViewRight := fdgv_CreateGroupView ( lpan_GroupViewRight, CST_COMPONENTS_GROUPVIEW_BEGIN + as_ClassRelation + CST_COMPONENTS_RIGHT, Self, alClient );
        p_CreateAndSetButtonsMoving;
        p_setGroupmentfields ( ldgv_GroupViewRight );
        p_AddGroupView ( ldgv_GroupViewRight );
        p_setButtons;
        lcon_Control := fspl_CreateSplitter ( lpan_ParentPanel, CST_COMPONENTS_SPLITTER_BEGIN + as_ClassRelation + CST_COMPONENTS_MIDDLE, Self, alLeft );
        lcon_Control.Left := Result.Width;
        p_setGroupView ( Result, True );
        p_setGroupView ( ldgv_GroupViewRight, False );
      finally
      {$IFDEF FPC}
        lpan_ParentPanel.EndUpdateBounds;
      {$ENDIF}
      end;
    end;

End;


// function fscb_CreateTabSheet
// Create a tabsheet and so a pagecontrol
// apc_PageControl : Page control to eventually create
// awin_ParentPageControl : Parent of pagecontrol
//  awin_PanelOrigin    : Panel not in a pagecontrol
// as_Name              : Pagecontrol name
// as_Caption : old caption
// ai_Counter : COlumn counter
function TF_XMLForm.fscb_CreateTabSheet(
  var apc_PageControl: TPageControl; const awin_ParentPageControl,
  awin_PanelOrigin: TWinControl; const as_Name, as_Caption: String
    ): TScrollBox;
var ltbs_Tabsheet : TTabSheet ;
begin
  if apc_PageControl = nil then
    apc_PageControl := fpc_CreatePageControl ( awin_ParentPageControl, as_Name, awin_PanelOrigin );
  ltbs_Tabsheet := TTabSheet.Create ( Self );
  ltbs_Tabsheet.Align := alClient;
  ltbs_Tabsheet.PageControl := apc_PageControl;
  ltbs_Tabsheet.Caption := fs_getlabelCaption ( as_Caption );
  Result := fscb_CreateScrollBox ( ltbs_Tabsheet, CST_COMPONENTS_TABSHEET_BEGIN +as_Name, Self, alClient );

end;



// fonction fpc_CreatePageControl
// Creating a pagecontrol
// awin_Parent : Parent component
// as_Name : name of pagecontrol
// apan_PanelOrigin : Changing The non pagecontrol panel and adding it to the tabsheet getting 2 tabsheet
function TF_XMLForm.fpc_CreatePageControl (const awin_Parent : TWinControl ; const  as_Name : String; const  apan_PanelOrigin : TWinControl ): TPageControl;
var ltbs_Tabsheet : TTabSheet ;
begin
  Result := TPageControl.Create ( Self );
  Result.Name := CST_COMPONENTS_PAGECONTROL_BEGIN + as_Name;
  // Le parent du pagecontrol
  Result.Parent := awin_Parent;
  gi_MainFieldsHeight := gi_LastFormFieldsHeight;
  Result.Align := alClient;
  ltbs_Tabsheet := TTabSheet.Create ( Self );
  ltbs_Tabsheet.PageControl := Result;
  ltbs_Tabsheet.Align := alClient;
  ltbs_Tabsheet.Caption := awin_Parent.Hint;
  ltbs_Tabsheet.Name := CST_COMPONENTS_TABSHEET_BEGIN + awin_Parent.Name;
  // Le panneau d'origine change de parent
  apan_PanelOrigin.Parent := ltbs_Tabsheet;
End;


//procedure p_setFieldComponent
// after having fully read the field nodes last setting of field component
// awin_Control : Component to set
// afw_Source : Form Column
// afw_columnField : Field Column
// ab_IsLocal : Not linked to data
// ab_Column : Second editing column
procedure TF_XMLForm.p_setFieldComponentTop  ( const awin_Control : TWinControl ; const ab_Column : Boolean );
begin
  if ab_Column Then
   // Intervalle entre les champs
    awin_Control.Top := gi_LastFormColumnHeight + CST_XML_FIELDS_INTERLEAVING
   Else
    awin_Control.Top := gi_LastFormFieldsHeight + CST_XML_FIELDS_INTERLEAVING ;
end;


// overrided procedure BeforeCreateFrameWork
// Creating invisible component and setting it
// Sender : needed
procedure TF_XMLForm.BeforeCreateFrameWork(Sender: TComponent);
begin
  gfin_FormIni := TOnFormInfoIni.Create(Self);
  gfin_FormIni.SaveForm    := [sfSameMonitor,sfSavePos,sfSaveSizes];
  gfin_FormIni.Name := CST_COMPONENTS_FORMINI;
  gfin_FormIni.Options := [loAutoUpdate,loFreeIni];
  DataCloseMessage := True;
end;

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
      lb_Unload := fb_getComponentBoolProperty ( Result, 'DataUnload' );
     // Initialisation de l'ouverture de fiche
      lfs_newFormStyle := alf_Function.Mode ;
      if not lb_Unload Then
        Begin
          if  ( Application.MainForm is TF_FormMainIni )
            Then
              ( Application.MainForm as TF_FormMainIni ).fb_setNewFormStyle( Result, lfs_newFormStyle, ab_Ajuster)
        End
      else
        Result.Free ;
    End ;
End ;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TXMLForm );
{$ENDIF}
end.


