unit u_xmlform;


{$I ..\extends.inc}
{$I ..\Compilers.inc}

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
  Graphics, Controls, Classes, Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls, Grids,
  ComCtrls, SysUtils,	TypInfo, Variants,
  U_CustomFrameWork, U_OnFormInfoIni,
  fonctions_string, ALXmlDoc, fonctions_xml, ExtCtrls,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  u_framework_components, u_framework_dbcomponents,
  u_multidonnees,
  U_FormMainIni, fonctions_ObjetsXML, U_GroupView;

{$IFDEF VERSIONS}
const

    gVer_TXMLForm : T_Version = ( Component : 'Composant TF_XMLForm' ;
                                  FileUnit  : 'U_XMLForm' ;
                                  Owner     : 'Matthieu Giroux' ;
                                  Comment   : 'Fiche personnalisée avec création de composant à partir du XML.' ;
                                  BugsStory : '0.9.0.0 : Reading a LEONARDI file and creating HMI.'  +
                                              '0.0.2.0 : Identification, more functionalities.'  +
                                              '0.0.1.0 : Working on weo.'   ;
                                  UnitType  : 3 ;
                                  Major : 0 ; Minor : 9 ; Release : 0; Build : 0 );
{$ENDIF}


type
  {CSV Counters}
  {Data record counter}
  TFWCounter = Record
                 FieldName : String ;
                 MinInt,MaxInt : Int64;
                 MinString,MaxString : String;
               End;
  {Added CSV file Definition}
  TFWCsvDef  = Record
                 FieldName : String ;
                 Min,Max : Double;
               End;

  { TFWXMLColumn }
  { Special XML FWColumn}

  TFWXMLColumn = class(TFWColumn)
  private
    ga_Counters : Array of TFWCounter;
    ga_CsvDefs : Array of TFWCsvDef;
    FPageControlDetails : TPageControl ;
    FPanelDetails : TPanel ;
    gr_Connection : TAConnection;
    function GetCounter( Index: Integer): TFWCounter;
    procedure SetCounter( Index: Integer; Value: TFWCounter);
    function GetCsvDef( Index: Integer): TFWCsvDef;
    function fli_GetHighCsvDefs: Longint ;
    procedure SetCsvDef( Index: Integer; Value: TFWCsvDef);
    procedure p_setConnection ( const AValue : TAConnection );
  public
    procedure AddCounter(const AFieldName : String; const AMinInt, AMaxInt : Int64; const AMinString, AMaxString : String );
    property Counters [Index: Integer] : TFWCounter read GetCounter write SetCounter ;
    property CSVDefs  [Index: Integer] : TFWCsvDef read GetCsvDef write SetCsvDef ;
    property PageControlDetails  : TPageControl read FPageControlDetails write FPageControlDetails ;
    property HighCsvDefs : Longint read fli_GetHighCsvDefs ;
    property PanelDetails : TPanel  read FPanelDetails write FPanelDetails ;
    property Connection : TAConnection read gr_Connection write p_setConnection;
  end;

  TFWXMLColumnClass = class of TFWXMLColumn;

 { TFWColumns }
 {Collection of FWXMLColumn}

  TFWXMLColumns = class(TFWColumns)
  public
    function Add: TFWXMLColumn;
    constructor Create(Form: TF_CustomFrameWork; ColumnClass: TFWXMLColumnClass); virtual;
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
    gi_MainFieldsHeight : Longint ;
    gfwe_Password, gfwe_Login : TFWEdit;
    procedure p_CloseLoginAction(AObject: TObject;
      var ACLoseAction: TCloseaction);
    procedure p_LoginCancelClick(AObject: TObject);
    procedure p_LoginOKClick(AObject: TObject);
    procedure p_setFunction ( const a_Value : TLeonFunction );
  protected
    gxml_SourceFile : TALXMLDocument ;
    procedure p_setChoiceComponent(const argr_Control: TDBRadioGroup); virtual;
    procedure p_CreateCsvFile(const afd_FieldsDefs: TFieldDefs; const afwc_Column : TFWXMLColumn ); virtual;
    function fpc_CreatePageControl(const awin_Parent : TWinControl ; const  as_Name : String; const  apan_PanelOrigin : TWinControl): TPageControl; virtual;
    function fdbg_GroupViewComponents(const awin_Parent : TWinControl ;
      const anod_NodeRelation: TALXMLNode; const alis_ListCrossLink: TList ; const ai_FieldCounter, ai_Counter : Integer
      ): TDBGroupView; virtual;
    function ffwc_getRelationComponent( const awin_Parent : TWinControl ; const anod_Field: TALXMLNode;
      const ab_IsLocal: Boolean; const ai_FieldCounter, ai_Counter : Integer ): TWinControl; virtual;
    procedure p_setFieldComponent(const awin_Control: TWinControl; const afw_column: TFWColumn; const afw_columnField: TFWFieldColumn; const ab_IsLocal, ab_Column : Boolean ); virtual;
    procedure p_setLabelComponent(const awin_Control : TWinControl ; const alab_Label : TFWLabel; const ab_Column : Boolean); virtual;
    function fb_setChoiceProperties(const anod_FieldProperty: TALXMLNode;
      const argr_Control : TDBRadioGroup): Boolean; virtual;
    function ffwc_CreateColumn(const as_Class, as_Connection: String;
      const ai_Counter: Integer): TFWXMLColumn;
    function  CreateColumns: TFWColumns; override;
    function  fwin_CreateFieldComponent ( const awin_Parent : TWinControl ; const anod_Field : TALXMLNode ; const ab_isLarge, ab_IsLocal : Boolean ; const ai_FieldCounter, ai_counter : Longint ):TWinControl;
    procedure p_CreateFieldComponentAndProperties(const as_Table :String; const anod_Field: TALXMLNode;
                                                  const ai_FieldCounter, ai_Counter : Longint ;
                                                  var awin_Parent : TWinControl ; var ab_Column : Boolean ; const afwc_Column : TFWXMLColumn ; const afd_FieldsDefs : TFieldDefs ); virtual;
    function fpan_GridNavigationComponents(const awin_Parent: TWinControl; const as_Name : String ;
      const ai_Counter: Integer): TScrollBox; virtual;
    function flab_setFieldComponentProperties( const anod_Field: TALXMLNode; const awin_Control, awin_Parent : TWinControl; const afd_FieldDef : TFieldDef ;
      const ai_Counter: Integer ; const afwc_Column : TFWXMLColumn ; const ab_Column : Boolean; const afcf_ColumnField : TFWFieldColumn ): TFWLabel; virtual;
    procedure p_SetFieldButtonsProperties(const anod_Action : TALXMLNode;
      const ai_Counter: Integer; const awin_Parent: TWinControl); virtual;
    procedure p_setControlName ( const as_FunctionName : String ; const anod_FieldProperty : TALXMLNode ;  const awin_Control : TControl; const ai_Counter : Longint ); virtual;
    function fscb_CreateTabSheet ( var apc_PageControl : TPageControl ;const awin_ParentPageControl,  awin_PanelOrigin : TWinControl ;
                                   const as_Name, as_Caption : String  ; const ai_Counter : Integer): TScrollBox; virtual;
    function  fb_ChargementNomCol ( const AFWColumn : TFWColumn ; const ai_NumSource : Integer ) : Boolean; override;
    procedure p_AfterColumnFrameShow( const aFWColumn : TFWColumn ); override;
    procedure DoClose ( var CloseAction : TCloseAction ); override;
    function fb_ChargeDonnees : Boolean; override;
  public
    procedure p_setLogin ( const axml_Login : TALXMLDocument );
		{ Déclarations publiques }
    procedure BeforeCreateFrameWork(Sender: TComponent);  override;
    procedure DestroyComponents ( const acom_Parent : TWinControl ); virtual;
    procedure p_CreateFormComponents ( const as_XMLFile, as_Name : String ;  awin_Parent : TWinControl ; var ai_Counter : Longint ) ; virtual;
    constructor Create ( AOwner : TComponent ); override;
    property ActionPanel : TPanel read FActionPanel write FActionPanel;
    property MainPanel   : TPanel read FMainPanel write FMainPanel;
    property PageControl : TPageControl read FPageControl write FPageControl;
    property Fonction : TLeonFunction read gr_Function write p_setfunction;
  end;

function fs_getFileNameOfTableColumn ( const afwc_Column    : TFWXMLColumn ): String;

implementation

uses u_languagevars, fonctions_proprietes, U_ExtNumEdits,
     fonctions_autocomponents, ALFcnString,
     u_buttons_appli, unite_variables;
var gi_LastFormFieldsHeight, gi_LastFormColumnHeight : Longint;

// functions and procédures not methods

// Function fs_getFileNameOfTableColumn
// return the XML file name from the table column name
function fs_getFileNameOfTableColumn ( const afwc_Column    : TFWXMLColumn ): String;
begin
  Result := afwc_Column.Connection.s_dataURL + afwc_Column.Table + CST_LEON_Data_Extension ;
end;


{ TFWXMLColumn }

{ AddCounter Procedure
  Creating a counter and adding it to array
   AFieldName: FieldName
   AMinInt : begining integer
   AMaxInt : ending integer
   AMinString : If counter is string Minimum value
   AMaxString : If counter is string Maximum value
}

procedure TFWXMLColumn.AddCounter(const AFieldName: String; const AMinInt,
  AMaxInt: Int64; const AMinString, AMaxString: String);
begin
  SetLength ( ga_Counters, high ( ga_Counters ) + 2 );
  with ga_Counters [ high ( ga_Counters ) ] do
    Begin
      FieldName :=  AFieldName ;
      MinInt    :=  AMinInt ;
      MaxInt    :=  AMaxInt ;
      MinString :=  AMinString ;
      MaxString :=  AMaxString ;
    
    End;
end;

{ fli_GetHighCsvDefs function
  getting the high frontier of CSV definition array}
function TFWXMLColumn.fli_GetHighCsvDefs: Longint;
begin
  Result := high ( ga_CSVDefs );
end;

{ GetCounter function
  getting the counter of the array
  Index : Number of counter}
function TFWXMLColumn.GetCounter(Index: Integer): TFWCounter;
begin
  if  ( Index >= 0 )
  and ( Index <= high ( ga_Counters ))
   then
    Result := ga_Counters [ Index ] ;
end;

////////////////////////////////////////////////////////////////////////////////
// function GetCsvDef
// Getting a more CSV definition
////////////////////////////////////////////////////////////////////////////////
function TFWXMLColumn.GetCsvDef(Index: Integer): TFWCsvDef;
begin
  if  ( Index >= 0 )
  and ( Index <= high ( ga_CsvDefs ))
   then
    Result := ga_CsvDefs [ Index ] ;
end;

// SetCounter procedure
// setting a more counter definition
// Index: index of counter in the array
// Value : New Index definition
procedure TFWXMLColumn.SetCounter(Index: Integer; Value: TFWCounter);
begin
  if ( Index > high ( ga_Counters ))
   then
     SetLength ( ga_Counters, Index + 1 );
  with ga_Counters [ Index ] do
    Begin
      FieldName :=  Value.FieldName ;
      MinInt    :=  Value.MinInt ;
      MaxInt    :=  Value.MaxInt ;
      MinString :=  Value.MinString ;
      MaxString :=  Value.MaxString ;
    End;
end;

////////////////////////////////////////////////////////////////////////////////
// procedure SetCsvDef
// CSV Management
////////////////////////////////////////////////////////////////////////////////
procedure TFWXMLColumn.SetCsvDef(Index: Integer; Value: TFWCsvDef);
begin
  if ( Index > high ( ga_CsvDefs ))
   then
     SetLength ( ga_CsvDefs, Index + 1 );
  with ga_CsvDefs [ Index ] do
    Begin
      Min    :=  Value.Min ;
      Max    :=  Value.Max ;
    End;

end;

// procedure p_setConnection
// Setting XML Column Form connection
// AValue : The data module connection
procedure TFWXMLColumn.p_setConnection(const AValue: TAConnection);
begin
  p_setMiniConnectionTo ( AValue, gr_Connection );
end;


////////////////////////////////////////////////////////////////////////////////
// function Add
// Adding a column to form
////////////////////////////////////////////////////////////////////////////////
function TFWXMLColumns.Add: TFWXMLColumn;
begin
  Result := TFWXMLColumn(inherited Add);
end;

// Overrided constructor Create
// Setting the constructor to TFWXMLColumnClass type
// Form: TF_CustomFrameWork
// ColumnClass : TFWXMLColumnClass
constructor TFWXMLColumns.Create(Form: TF_CustomFrameWork; ColumnClass: TFWXMLColumnClass);
begin
  inherited Create(Form, ColumnClass);
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
      gstl_SQLWork := nil ;
      GlobalNameSpace.BeginWrite;

      p_InitFrameWork ( AOwner );
      // Creating objects
      p_CreateColumns;

      {$IFDEF FPC}
      CreateNew(AOwner, 1 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      {$IFDEF SFORM}
      InitSuperForm;
      {$ENDIF}
    Finally
      GlobalNameSpace.EndWrite;
    End
  Else
   Begin
     inherited ;
     Exit ;
   end;

  DataCloseMessage := True;

end;


// function CreateColumns overrided
// Create The TFWXMLColumns into the inherited TF_XMLForm
// returns original and inherited TFWXMLColumns
function TF_XMLForm.CreateColumns: TFWColumns;
begin
  Result := TFWXMLColumns.Create(Self, TFWXMLColumn);
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
//        ShowMessage ( Components[li_i].Name );
        Components [ li_i ].Free ;
      End ;
  gxml_SourceFile := nil ;
  p_InitFrameWork ( Self );
end;

// Function fb_ChargementNomCol
// Inherited function, just make it true
function TF_XMLForm.fb_ChargementNomCol(const AFWColumn: TFWColumn;
  const ai_NumSource: Integer): Boolean;
begin
  Result := True;
end;

function TF_XMLForm.ffwc_CreateColumn(const as_Class, as_Connection: String;
  const ai_Counter: Integer): TFWXMLColumn;
var li_Connection : Integer;
begin
  li_Connection:=fi_FindConnection( as_Connection, True );
  if ( Columns.Count <= ai_Counter ) then
   with ga_Connections [ li_Connection ] do
    Begin
      Result := Columns.Add as TFWXMLColumn;
      Result.Datasource := fds_CreateDataSourceAndTable ( as_Class, s_dataURL, IntToStr ( ai_Counter ), dtt_DatasetType, dat_QueryCopy, Self);
      Result.Table := as_Class;
      if dtt_DatasetType = dtCSV Then
        Begin
          p_setComponentProperty ( Result.Datasource.dataset, 'Filename', fs_getFileNameOfTableColumn ( Result ));
        End;
    End
   Else
    Result := Columns [ ai_Counter ] as TFWXMLColumn;
End;

// function fpan_GridNavigationComponents
// Create a complete Grid navigation with Navigators returning the child created ScrollBox for the editing form
// awin_Parent : The grid navigation and editing parent
// const as_Name : name for caption
// const ai_Counter : Column counter
function TF_XMLForm.fpan_GridNavigationComponents ( const awin_Parent : TWinControl ; const as_Name : String ; const ai_Counter : Integer ): TScrollBox;
var lpan_ParentPanel : TPanel ;
    lpan_Panel : TPanel ;
    ldbn_Navigator : TExtDBNavigator ;
    ldbg_Grid      : TFWDBGrid ;
    lfwc_Column    : TFWXMLColumn ;
    lcon_Control   : TControl ;
begin
  lfwc_Column := Columns [ ai_Counter ] as TFWXMLColumn;
  lpan_ParentPanel := fpan_CreatePanel ( awin_Parent, CST_COMPONENTS_PANEL_MAIN + as_Name, Self, alClient );
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
  lfwc_Column.FPanelDetails := lpan_ParentPanel;
  lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  lpan_ParentPanel.ShowHint := True;
  lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, alTop );
  ldbn_Navigator := fdbn_CreateNavigation ( lpan_Panel, CST_COMPONENTS_NAVIGATOR_BEGIN + CST_COMPONENTS_EDIT + as_Name, Self, True, alTop );
  lfwc_Column.NavEdit := ldbn_Navigator;
  Result := fscb_CreateScrollBox ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_CONTROLS + as_Name, Self, alClient );
  lfwc_Column.Panels.Add.Panel := Result ;
End;

// function fdbg_GroupViewComponents
// Creates a full N-N or N-1 relationships management
// awin_Parent : the parent component of the created components
// anod_NodeRelation : The relationships node
// const alis_ListCrossLink : The other side relationships
// ai_FieldCounter : Table counter
// ai_Counter : Column Counter
// returns the main list

function TF_XMLForm.fdbg_GroupViewComponents ( const awin_Parent : TWinControl ; const anod_NodeRelation : TALXMLNode ; const alis_ListCrossLink : TList ; const ai_FieldCounter, ai_Counter : Integer ):TDBGroupView;
var lpan_ParentPanel   : TWinControl;
    lpan_GroupViewRight,
    lpan_Panel : TPanel ;
    ldgv_GroupViewRight : TDBGroupView ;
    lfwc_Column    : TFWXMLColumn ;
    lcon_Control   : TControl ;
    ls_ClassName : String;
begin
  lfwc_Column := Columns [ ai_Counter ] as TFWXMLColumn;
  with lfwc_Column do
    Begin
      ls_ClassName := anod_NodeRelation.Attributes[CST_LEON_ID];
      lpan_ParentPanel := fscb_CreateTabSheet ( FPageControlDetails, lfwc_Column.Panels [ lfwc_Column.Panels.Count -1 ].panel, awin_Parent, CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter ), Gs_DetailsSheet, ai_FieldCounter );
//      lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
//      lpan_ParentPanel.ShowHint := True;
      Result := fdgv_CreateGroupView ( lpan_ParentPanel, CST_COMPONENTS_GROUPVIEW_BEGIN + ls_ClassName + CST_COMPONENTS_LEFT, Self, alLeft );
      Result.Width := CST_GROUPVIEW_WIDTH;
      lpan_Panel := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_ACTIONS + ls_ClassName, Self, alTop );
      with Result do
        Begin
          ButtonRecord := TFWRecord.Create ( Self );
          ButtonRecord.Name := CST_COMPONENTS_RECORD_BEGIN + ls_ClassName;
          lpan_Panel.Height := ButtonRecord.Height;
          ButtonRecord.Parent := lpan_Panel;
          ButtonRecord.Align := alRight ;
          ButtonCancel := TFWAbort .Create ( Self );
          ButtonCancel.Parent := lpan_Panel;
          ButtonCancel.Name := CST_COMPONENTS_ABORT_BEGIN + ls_ClassName;
          lpan_Panel := fpan_CreatePanel ( lpan_Panel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_ACTIONS + ls_ClassName, Self, alRight );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          lpan_Panel.Left := ButtonRecord.Width;
        end;
      lpan_GroupViewRight := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + ls_ClassName + CST_COMPONENTS_RIGHT, Self, alClient );
      lpan_Panel := fpan_CreatePanel ( lpan_GroupViewRight, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_MIDDLE + ls_ClassName, Self, alRight );
      lpan_Panel.width := CST_GROUPVIEW_INOUT_WIDTH + CST_XML_FIELDS_INTERLEAVING * 2;
      with Result do
        Begin
          ButtonIn   := TFWInSelect.Create ( Self );
          ButtonIn.Name :=  CST_COMPONENTS_IN_BEGIN + ls_ClassName;
          ButtonIn.Parent := lpan_Panel;
          ButtonIn.Top  := CST_XML_FIELDS_INTERLEAVING;
          ButtonIn.Left := CST_XML_FIELDS_INTERLEAVING;
          ButtonTotalIn   := TFWInAll.Create ( Self );
          ButtonTotalIn.Name :=  CST_COMPONENTS_INALL_BEGIN + ls_ClassName;
          ButtonTotalIn.Parent := lpan_Panel;
          ButtonTotalIn.Top  := CST_XML_FIELDS_INTERLEAVING + ButtonIn.Height;
          ButtonTotalIn.Left := CST_XML_FIELDS_INTERLEAVING;
          ButtonOut   := TFWInSelect.Create ( Self );
          ButtonOut.Parent := lpan_Panel;
          ButtonOut.Name :=  CST_COMPONENTS_OUT_BEGIN + ls_ClassName;
          ButtonOut.Top  := CST_XML_FIELDS_INTERLEAVING * 3 + ButtonTotalIn.Height;
          ButtonOut.Left := CST_XML_FIELDS_INTERLEAVING;
          ButtonTotalOut   := TFWInAll.Create ( Self );
          ButtonTotalOut.Parent := lpan_Panel;
          ButtonTotalOut.Name :=  CST_COMPONENTS_OUTALL_BEGIN + ls_ClassName;
          ButtonTotalOut.Top  := CST_XML_FIELDS_INTERLEAVING + ButtonOut.Height;
          ButtonTotalOut.Left := CST_XML_FIELDS_INTERLEAVING;
        end;
      ldgv_GroupViewRight := fdgv_CreateGroupView ( lpan_GroupViewRight, CST_COMPONENTS_GROUPVIEW_BEGIN + ls_ClassName + CST_COMPONENTS_RIGHT, Self, alClient );
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
      Result.DataListOpposite :=  ldgv_GroupViewRight;
      lcon_Control := fspl_CreateSplitter ( lpan_ParentPanel, CST_COMPONENTS_SPLITTER_BEGIN + ls_ClassName + CST_COMPONENTS_MIDDLE, Self, alLeft );
      lcon_Control.Left := Result.Width;
    end;
End;

// function ffwc_getRelationComponent
// Creates some relationships components, included the full Groupview relationships
// awin_Parent : Parent of all created components
// anod_Field : relationships node
// ab_IsLocal : is relationships not linked to data ?
// ai_FieldCounter : table counter
// ai_Counter : column counter
function TF_XMLForm.ffwc_getRelationComponent (  const awin_Parent : TWinControl ; const anod_Field : TALXMLNode ; const ab_IsLocal : Boolean  ; const ai_FieldCounter, ai_Counter : Integer ):TWinControl;
var ldoc_XMlRelation : TALXMLDocument ;
    lnode, lnodeClass,
    anod_CrossLinkRelation : TALXMLNode;
    ls_Class, ls_Connection : String;
    alis_idRelation        : TList;
    li_i : Integer;
    ls_Fields : String;
Begin
  Result := nil;
  if ( anod_Field.NodeName = CST_LEON_FIELD_RELATION ) then
    Begin
      lnode := fnod_GetClassFromRelation(anod_Field);
      alis_IdRelation        := TList.Create;
      anod_CrossLinkRelation := nil;
      ldoc_XMlRelation       := nil;
      try
        // Getting other class
        ls_Class := fs_GetNodeAttribute( lnode, CST_LEON_IDREFs );
        if ( ls_Class = '' ) then
          ls_Class := fs_GetNodeAttribute( lnode, CST_LEON_IDREF );
        if ( ls_Class = '' ) then                                       
           if lnode.HasChildNodes Then
            for li_i := 0 to lnode.ChildNodes.Count -1 do
              Begin
                lnodeClass := lnode.ChildNodes [ li_i ];
                if ( lnodeClass.NodeName = CST_LEON_CLASS_REF )
                and lnodeClass.HasAttribute ( CST_LEON_IDREF ) Then
                  Begin
                    ls_Class := lnodeClass.Attributes [ CST_LEON_IDREF ];
                    Break;
                  end;
              end;
        /// getting other xml file info
        ldoc_XMlRelation := fdoc_GetCrossLinkFunction( gr_Function.Clep, ls_Class, ls_Connection, alis_IdRelation, anod_CrossLinkRelation );
        li_i := fi_FindConnection(ls_Connection, True );
        if anod_CrossLinkRelation = nil Then
         // 1-N relationships
          Begin
            Result := TFWDBLookupCombo.Create ( Self );
            ls_Fields := fs_GetStringFields  ( alis_IdRelation , '' );
            if li_i <> -1 Then
              ( Result as TFWDBLookupCombo ).{$IFDEF FPC}ListSource{$ELSE}LookupSource{$ENDIF}:= fds_CreateDataSourceAndOpenedQuery ( ls_Class, ls_Fields, IntToStr ( ai_FieldCounter ) + '_' + IntToStr ( ai_Counter ), ga_Connections [ li_i ], alis_IdRelation, Self );
            ( Result as TFWDBLookupCombo ).{$IFDEF FPC}KeyField{$ELSE}LookupField{$ENDIF}:= ls_Fields;
          end
         else
         // N-N N-1 relationships
           fdbg_GroupViewComponents ( awin_Parent, anod_Field, alis_IdRelation, ai_FieldCounter, ai_Counter );
      finally
        alis_IdRelation.free;
        anod_CrossLinkRelation.free;
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
function TF_XMLForm.fwin_CreateFieldComponent ( const awin_Parent : TWinControl ; const anod_Field : TALXMLNode ; const ab_isLarge, ab_IsLocal : Boolean ; const ai_FieldCounter, ai_counter : Longint ):TWinControl;
begin
  Result := fwin_CreateAFieldComponent ( anod_Field.NodeName, Self, ab_isLarge, ab_IsLocal, ai_counter );

  if  ( Result = nil ) Then
    Result := ffwc_getRelationComponent ( awin_Parent, anod_Field, ab_IsLocal, ai_FieldCounter, ai_counter );

  if anod_Field is TALXmlCommentNode then
    Begin
      Exit;
    End;

  if ( Result = nil ) then
    Begin
      Showmessage ( Gs_NoComponentToCreate + anod_Field.NodeName +'.' );
      gb_Unload := True;
      Exit;
    End;

  Result.Parent := awin_Parent ;
  Result.Tag := ai_Counter + 1;
end;
//procedure p_setFieldComponent
// after having fully read the field nodes last setting of field component
// awin_Control : Component to set
// afw_column : Form Column
// afw_columnField : Field Column
// ab_IsLocal : Not linked to data
// ab_Column : Second editing column
procedure TF_XMLForm.p_setFieldComponent ( const awin_Control : TWinControl ; const afw_column : TFWColumn ; const afw_columnField : TFWFieldColumn ; const ab_IsLocal, ab_Column : Boolean );
begin
  if ab_Column Then
   // Intervalle entre les champs
    awin_Control.Top := gi_LastFormColumnHeight + CST_XML_FIELDS_INTERLEAVING
   Else
    awin_Control.Top := gi_LastFormFieldsHeight + CST_XML_FIELDS_INTERLEAVING ;

  if not ab_IsLocal Then
    Begin
      p_setComponentProperty       ( awin_Control, 'DataField' , afw_columnField.FieldName );
      p_setComponentObjectProperty ( awin_Control, 'Datasource', afw_column.Datasource );
    end;
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
      if ab_Column then
        alab_Label.Left := CST_XML_SEGUND_COLMUN_MIN_POSWIDTH
       Else
        alab_Label.Left := 0 ;
    End;
end;
// overrided procedure p_AfterColumnFrameShow
// aFWColumn : Column showing
procedure TF_XMLForm.p_AfterColumnFrameShow( const aFWColumn : TFWColumn );
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

// procedure p_setLogin
// Special Login model
// axml_Login : XML Document of login form
procedure TF_XMLForm.p_setLogin(const axml_Login: TALXMLDocument);
var
    li_i, li_j, li_Counter : Longint;
    lnod_Node, lnod_NodeChild : TALXMLNode ;
    ls_location : String;
    lwin_Control  : TWinControl;
    lfwl_Label    : TFWLabel;
    lfwc_Column     : TFWColumn ;
begin
  gfwe_Password := nil;
  gfwe_Login    := nil;
  for li_i := 0 to axml_Login.ChildNodes.Count - 1 do
    Begin
      lnod_Node := axml_Login.ChildNodes [ li_i ];
      if lnod_Node.NodeName = CST_LEON_ACTION Then
        Begin
          lfwc_Column := nil;
          Width  := 350;
          Height := 250 ;
          // Creating columns
          if lnod_Node.HasChildNodes Then
          for li_j := 0 to lnod_Node.ChildNodes.Count - 1 do
            Begin
              lnod_NodeChild := lnod_Node.ChildNodes [ li_j ];
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

                   lfwc_Column := ffwc_createColumn ( lnod_NodeChild.Attributes [ CST_LEON_IDREF ], ls_location, 0 );
                 end;
            end;
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
          lwin_Control.Left:= Width div 2 - ( lwin_Control.Width * 2 ) div 2;
          lwin_Control.Top := 150 ;
          ( lwin_Control as TFWOK ).OnClick := p_LoginOKClick;
          lwin_Control := TFWCancel.Create(Self);
          lwin_Control.Parent := Self;
          lwin_Control.Left:= Width div 2 + lwin_Control.Width div 2;
          lwin_Control.Top := 150 ;
          ( lwin_Control as TFWCancel ).OnClick := p_LoginCancelClick;
        end;
    end;
  OnClose:=p_CloseLoginAction;
  Name := CST_COMPONENTS_FORM_BEGIN + 'AutoLoginForm' ;
  // Initiate data and showing
  FormCreate ( Self );
  Position:=poMainFormCenter;
  FormStyle:=fsStayOnTop;
  Show;
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
  with Columns [ 0 ] do
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
var li_NumSource,
    li_i : Integer ;
    li_Action : Longint ;
    lpan_Panel : TPanel;
begin
  with a_Value do
    Begin
      p_CopyLeonFunction ( a_Value, gr_Function );
    End;
 Name := CST_COMPONENTS_FORM_BEGIN + a_value.Clep;
 Caption := fs_GetLabelCaption ( gr_Function.Name );
 li_NumSource := 0 ;
 with gr_Function do
   Begin
     // Simple function
    if (high ( Functions ) < 0 ) then
      Begin
        DestroyComponents ( nil );
        p_CreateFormComponents ( gr_Function.AFile,gr_Function.Name, fpan_CreateActionPanel ( Self, Self, FActionPanel ), li_NumSource );
      End
    else
      Begin
        // Compound function
        DestroyComponents ( nil );
        lpan_Panel := fpan_CreateActionPanel ( Self, Self, FActionPanel );
        for li_i := 0 to ( high ( Functions )) do
          Begin
            li_Action := fi_FindAction ( Functions [ li_i ] );
            p_CreateFormComponents ( ga_Functions [ li_Action ].AFile, ga_Functions [ li_Action ].Name, lpan_Panel, li_NumSource );
            inc ( li_NumSource );
          End;
       End;
   End;
 FormCreate ( Self );
 gfin_FormIni.p_ExecuteLecture(Self);
end;

// procedure p_setChoiceComponent
// After having read child node from choice node setting the height of choice node
// argr_Control : Choice component

procedure TF_XMLForm.p_setChoiceComponent( const argr_Control : TDBRadioGroup );
Begin
  argr_Control.Height:=argr_Control.Items.Count  * gi_FontHeight + flin_getComponentProperty ( argr_Control, 'BorderWidth' )  * 2 ;
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
// afwc_Column : XML Form Column
// ab_Column : Segund editing column
// afcf_ColumnField : Field Form column definitions

function TF_XMLForm.flab_setFieldComponentProperties ( const anod_Field : TALXMLNode ; const awin_Control, awin_Parent : TWinControl; const afd_FieldDef : TFieldDef ; const ai_Counter : Longint ; const afwc_Column : TFWXMLColumn ; const ab_Column : Boolean ; const afcf_ColumnField : TFWFieldColumn ): TFWLabel;
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

// procedure p_SetFieldButtonsProperties
// Setting the editing buttons
// anod_Action : Action node for buttons
// ai_Counter : column counter
// awin_Parent : Parent component
procedure TF_XMLForm.p_SetFieldButtonsProperties ( const anod_Action : TALXMLNode ; const ai_Counter : Longint ; const awin_Parent : TWinControl );
var ls_Action   : String ;
begin
  with Columns [ ai_Counter ] do
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
      End;


end;

// procedure p_CreateFieldComponentAndProperties
// Creating the column components
// as_Table : Table Name
// anod_Field: Node field
// ai_FieldCounter : Field counter
//  ai_Counter : Column counter
// awin_Parent : Parent component
// ab_Column : Second editing column
// afwc_Column : XML form Column
// afd_FieldsDefs : Field Definitions
procedure TF_XMLForm.p_CreateFieldComponentAndProperties (const as_Table :String; const anod_Field: TALXMLNode; const  ai_FieldCounter, ai_Counter : Longint ; var awin_Parent : TWinControl ; var ab_Column : Boolean ; const afwc_Column : TFWXMLColumn ; const afd_FieldsDefs : TFieldDefs );
var li_i : LongInt ;
    lnod_FieldProperties : TALXMLNode ;
    llab_Label  : TFWLabel;
    lwin_Control : TWInControl ;
    lb_IsLarge, lb_IsLocal  : Boolean;
    lfd_FieldDef : TFieldDef;
    lffd_ColumnFieldDef : TFWFieldColumn;

begin
   If  ( gi_LastFormFieldsHeight > CST_XML_DETAIL_MINHEIGHT) Then
     with afwc_Column do
       Begin
         gi_LastFormFieldsHeight := 0;
         awin_Parent := fscb_CreateTabSheet ( FPageControlDetails, FPanelDetails, awin_Parent,
                          CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter )+ '_' +IntToStr ( ai_Counter ),
                          Gs_DetailsSheet, ai_FieldCounter );
         afwc_Column.Panels.add.Panel := awin_Parent;
       End;

  if ( anod_Field.Attributes [ CST_LEON_ID ] <> Null ) then
    Begin
      lffd_ColumnFieldDef := afwc_Column.FieldsDefs.Add ;
      with lffd_ColumnFieldDef do
        begin
          NomTable    := as_Table;
          NumTag      := ai_counter + 1;
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
    for li_i := 0 to anod_Field.ChildNodes.Count -1 do
      Begin
        lnod_FieldProperties := anod_Field.ChildNodes [ li_i ];
        if lnod_FieldProperties.NodeName = CST_LEON_FIELD_F_MARKS then
          Begin
            if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_local )
            and not ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_local ] = CST_LEON_BOOL_FALSE )  then
              Begin
                lb_IsLocal := True;
              End;
            if lnod_FieldProperties.HasAttribute ( CST_LEON_FIELD_hidden )
            and not ( lnod_FieldProperties.Attributes [ CST_LEON_FIELD_hidden ] = CST_LEON_BOOL_FALSE )  then
              Begin
                lffd_ColumnFieldDef.AffiCol := -1;
                lffd_ColumnFieldDef.AffiRech := -1;
                Exit;
              End;
            lffd_ColumnFieldDef.AffiCol := ai_counter + 1;
            if lnod_FieldProperties.HasAttribute ( CST_LEON_ID)
            and not ( lnod_FieldProperties.Attributes [ CST_LEON_ID ] = CST_LEON_BOOL_FALSE )  then
              Begin
                if afwc_Column.Key  = '' then
                  afwc_Column.Key := anod_Field.Attributes [CST_LEON_ID]
                 else
                  afwc_Column.Key := afwc_Column.Key + FieldDelimiter + anod_Field.Attributes [CST_LEON_ID];
              End;
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
        if ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NROWS )
        or ( lnod_FieldProperties.NodeName = CST_LEON_FIELD_NCOLS ) then
          lb_IsLarge := True;
      End;
  if afwc_Column.gr_Connection.dtt_DatasetType = dtCSV then
    Begin
      lfd_FieldDef := ffd_CreateFieldDef ( anod_Field, lb_IsLarge, afd_FieldsDefs );
    End
   Else
    lfd_FieldDef := nil ;

  lwin_Control := fwin_CreateFieldComponent ( awin_Parent, anod_Field, lb_IsLarge, lb_IsLocal, ai_FieldCounter, ai_counter );

  if not assigned ( lwin_Control ) then
    Exit;

  p_setFieldComponent ( lwin_Control, afwc_Column, lffd_ColumnFieldDef, lb_IsLocal, ab_Column );

  llab_Label := flab_setFieldComponentProperties ( anod_Field, lwin_Control, awin_Parent, lfd_FieldDef, ai_Counter, afwc_Column, ab_Column, lffd_ColumnFieldDef );

  p_setLabelComponent ( lwin_Control, llab_Label, ab_Column );

  ab_Column := lwin_control.Width + lwin_Control.Left < CST_XML_SEGUND_COLMUN_MIN_POSWIDTH;
  gi_LastFormColumnHeight := gi_LastFormFieldsHeight;
  if gi_LastFormFieldsHeight < lwin_Control.Top + lwin_Control.Height then
    gi_LastFormFieldsHeight := lwin_Control.Top + lwin_Control.Height ;
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

// function fscb_CreateTabSheet
// Create a tabsheet and so a pagecontrol
// apc_PageControl : Page control to eventually create
// awin_ParentPageControl : Parent of pagecontrol
//  awin_PanelOrigin    : Panel not in a pagecontrol
// as_Name              : Pagecontrol name
// as_Caption : old caption
// ai_Counter : COlumn counter
function TF_XMLForm.fscb_CreateTabSheet ( var apc_PageControl : TPageControl ;const awin_ParentPageControl,  awin_PanelOrigin : TWinControl ;
                                          const as_Name, as_Caption : String  ; const ai_Counter : Integer) : TScrollBox;
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

// procedure p_CreateCsvFile
// Creating CSV file
// afd_FieldsDefs : field definition
//  afwc_Column   : Column definition
procedure TF_XMLForm.p_CreateCsvFile ( const afd_FieldsDefs : TFieldDefs ; const afwc_Column : TFWXMLColumn );
var lstl_File : TStringList;
    ls_FileInside : String ;
    li_i : Longint;
Begin
  if  ( afwc_Column.gr_Connection.dtt_DatasetType = dtCSV )
  and not FileExists ( fs_getFileNameOfTableColumn ( afwc_Column ))
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
        lstl_File.SaveToFile ( fs_getFileNameOfTableColumn ( afwc_Column ));
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
procedure TF_XMLForm.p_CreateFormComponents ( const as_XMLFile, as_Name : String ; awin_Parent : TWinControl ; var ai_Counter : Longint );
var li_i, li_j, li_NoField : LongInt ;
    lnod_Node, lnod_ClassProperties : TALXMLNode ;
    ls_ProjectFile : String ;
    lb_Column, lb_FieldFound, lb_Table : Boolean ;
    lfwc_Column : TFWXMLColumn ;
    lfd_FieldsDefs : TFieldDefs ;
    li_Counter : Integer;
    ls_Temp : String;
  // child procedure p_CreateParentAndFieldsComponent
  // Creates the navigation grid and fields components
  // anod_ANode : current node
  procedure p_CreateParentAndFieldsComponent ( const anod_ANode : TALXMLNode );
  Begin
    if not lb_FieldFound Then
      Begin
        if ( ai_Counter = 0 ) Then
            Begin
              awin_Parent := fpan_GridNavigationComponents ( awin_Parent, as_Name, ai_Counter );
              Hint := fs_GetLabelCaption ( as_Name );
              ShowHint := True;
            End
         else
          Begin
            awin_Parent := fscb_CreateTabSheet ( FPageControl, Self, FMainPanel, as_Name, as_Name, ai_Counter );
            awin_Parent := fpan_GridNavigationComponents ( awin_Parent, as_Name, ai_Counter );
          End;
        lb_FieldFound := True;
      end;
    if lnod_Node.Attributes [ CST_LEON_ID ] = Null then
      p_CreateFieldComponentAndProperties ( '', anod_ANode, ai_counter, li_NoField, awin_Parent, lb_Column, lfwc_Column, lfd_FieldsDefs )
     else
      p_CreateFieldComponentAndProperties ( lnod_Node.Attributes [ CST_LEON_ID ], anod_ANode, ai_counter, li_NoField, awin_Parent, lb_Column, lfwc_Column, lfd_FieldsDefs );
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
        ls_Temp := '';
        inc ( ai_counter );
       p_CreateCsvFile ( lfd_FieldsDefs, lfwc_Column );
      End;
    if  ( li_Counter < Columns.Count )
    and ( anod_ANode.NodeName = CST_LEON_ACTIONS ) then
        Begin
          for li_k := 0 to anod_ANode.ChildNodes.Count -1 do
            Begin
              p_SetFieldButtonsProperties ( anod_ANode.ChildNodes [ li_k ], li_Counter, ActionPanel );
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
    lfwc_Column :=ffwc_createColumn ( as_Table, as_Connection, ai_Counter );
    if lfwc_Column.gr_Connection.dtt_DatasetType = dtCSV then
      Begin
        lfd_FieldsDefs := fobj_GetcomponentObjectProperty ( lfwc_Column.Datasource.Dataset, 'FieldDefs' ) as TFieldDefs;
      End;
  end;

begin
  if not assigned ( gxml_SourceFile ) Then
    gxml_SourceFile := TALXMLDocument.Create ( Self );
  ls_ProjectFile := fs_getProjectDir ( ) + as_XMLFile + CST_LEON_File_Extension;
  li_Counter := ai_Counter ;
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
              or ( lnod_Node.NodeName = CST_LEON_FIELD_RELATION )
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
                 p_SetFieldButtonsProperties ( lnod_Node, li_Counter, awin_Parent );
            End;
        End;
    Except
      On E: Exception do
        Begin
          ShowMessage ( 'Erreur : ' + E.Message );
        End;
    End ;
  if   li_Counter < ai_Counter  then
    dec ( ai_Counter );
  
end;

// overrided procedure BeforeCreateFrameWork
// Creating invisible component and setting it
// Sender : needed
procedure TF_XMLForm.BeforeCreateFrameWork(Sender: TComponent);
begin
  gfin_FormIni := TOnFormInfoIni.Create(Self);
  gfin_FormIni.SauvePosForm    := True;
  gfin_FormIni.SauvePosObjects := True;
  gfin_FormIni.Name := CST_COMPONENTS_FORMINI;
  gfin_FormIni.AutoUpdate := True;
  gfin_FormIni.AutoLoad   := False;
end;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_TXMLForm );
{$ENDIF}
end.


