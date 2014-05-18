////////////////////////////////////////////////////////////////////////////////
//
//	Nom Unité :  fonctions_autocomponents
//	Description :	Création automatisée de composants, sans gestion XML
//	Créée par Matthieu GIROUX liberlog.fr en 2010
//
////////////////////////////////////////////////////////////////////////////////
unit fonctions_autocomponents;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

uses
  Controls, Classes, DB,
  U_ExtDBNavigator, Forms, DBCtrls,
  SysUtils,ComCtrls,
  u_framework_dbcomponents,
  fonctions_manbase, StdCtrls,
  u_xmlfillcombobutton,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  U_CustomFrameWork, u_framework_components,
  u_buttons_defs, u_extdbgrid,
  u_multidata,U_GroupView, ExtCtrls ;


const CST_GRID_NAVIGATION_WIDTH         = 200 ;
      CST_GRID_NAVIGATION_MIN_WIDTH     = 15 ;
      CST_GRID_FORM_FIELDS_HEIGHT       = 12 ;
      CST_BUTTONS_INTERLEAVING          = 10;
      CST_GROUPVIEW_WIDTH               = 200;
      CST_GROUPVIEW_INOUT_WIDTH         = 70;
      CST_GROUPVIEW_BUTTONS_WIDTH       = 80;
      CST_CONTROLS_INTERLEAVING       = 4;
      CST_XML_FIELDS_CAPTION_SPACE      = 150;
      CST_XML_SEGUND_COLUMN_MIN_POSWIDTH= 320;
      CST_XML_DETAIL_MINHEIGHT          = 560;
      CST_XML_FIELDS_LABEL_INTERLEAVING = 15;
      CST_XML_FIELDS_CHARLENGTH         = 10;

      CST_COMPONENTS_GROUPBOX_BEGIN     = 'grb_' ;    // Debut du Nom du panel
      CST_COMPONENTS_PANEL_BEGIN        = 'pan_' ;    // Debut du Nom du panel
      CST_COMPONENTS_DBGRID_BEGIN       = 'dbg_' ;
      CST_COMPONENTS_TABSHEET_BEGIN     = 'tbs_' ;
      CST_COMPONENTS_PAGECONTROL_BEGIN  = 'pco_' ;
      CST_COMPONENTS_NAVIGATOR_BEGIN    = 'nav_' ;
      CST_COMPONENTS_BUTTON_BEGIN       = 'but_' ;
      CST_COMPONENTS_SPLITTER_BEGIN     = 'spl_' ;
      CST_COMPONENTS_FILLCOMBO_BEGIN    = 'fcb_' ;
      CST_COMPONENTS_COMBO_BEGIN        = 'cbx_' ;
      CST_COMPONENTS_LABEL_BEGIN        = 'lb_' ;
      CST_COMPONENTS_EDIT_BEGIN         = 'ed_' ;
      CST_COMPONENTS_GROUPVIEW_BEGIN    = 'grv_' ;
      CST_COMPONENTS_RECORD_BEGIN       = 'fwr_Record' ;
      CST_COMPONENTS_ABORT_BEGIN        = 'fwa_Abort' ;
      CST_COMPONENTS_IN_BEGIN           = 'fwi_In' ;
      CST_COMPONENTS_INALL_BEGIN        = 'fwi_InAll' ;
      CST_COMPONENTS_OUT_BEGIN          = 'fwo_Out' ;
      CST_COMPONENTS_OUTALL_BEGIN       = 'fwo_OutAll' ;
      CST_COMPONENTS_FORM_BEGIN         = 'f_' ;

      CST_COMPONENTS_BUTTON_CLOSE       = 'Close' ;
      CST_COMPONENTS_BUTTON_PRINT       = 'Print' ;

      CST_COMPONENTS_PANEL_MAIN         = 'pan_Main' ;
      CST_COMPONENTS_FORMINI            = 'gfin_FormIni';

      CST_COMPONENTS_DETAILS            = 'Detail' ;
      CST_COMPONENTS_MIDDLE             = 'Middle' ;
      CST_COMPONENTS_EDIT               = 'Edit' ;
      CST_COMPONENTS_INTERLEAVING       = 'Inter' ;
      CST_COMPONENTS_LEFT               = 'Left' ;
      CST_COMPONENTS_RELATION           = 'Link' ;
      CST_COMPONENTS_RIGHT              = 'Right' ;
      CST_COMPONENTS_DBGRID             = 'Grid' ;
      CST_COMPONENTS_BUTTONS            = 'Buttons' ;
      CST_COMPONENTS_CONTROLS           = 'Controls' ;
      CST_COMPONENTS_ACTIONS            = 'Actions' ;


var  gi_FontHeight : Integer = 24 ;
     gb_DoubleColumn : Boolean = True;

{$IFDEF VERSIONS}
const
  gver_fonctions_autocomponents : T_Version = ( Component : 'Creating and setting components from parameters' ;
                                     FileUnit : 'fonctions_autocomponents' ;
              			                 Owner : 'Matthieu Giroux' ;
              			                 Comment : 'Dynamic components creating for XML Form, with no XML variables.';
              			                 BugsStory :  'Version 1.1.0.1 : Testing.' + #13#10 +
                                                              'Version 1.1.0.0 : Creating components and setting them from parameters.' + #13#10 +
                                                              'Version 1.0.0.0 : Création de l''unité à partir de fonctions_objets_dynamiques.';
              			                 UnitType : 1 ;
              			                 Major : 1 ; Minor : 1 ; Release : 0 ; Build : 1 );

{$ENDIF}

procedure p_setControlNameAndTag  ( const awin_Control : TWinControl ;
                          const as_BeginName,
                                as_MiddleName : String ;
                          const awin_Parent : TWinControl ;
                          const ai_FieldCounter, ai_counter : Longint );
function fwin_CreateAEditComponent ( const acom_Owner : TComponent ; const ab_isLarge, ab_IsLocal : Boolean ):TWinControl;
function fpan_CreateAction ( const abut_Button : TFWXPButton ; const as_name : String ; const acom_Owner : TWinControl ; const apan_ActionPanel : TPanel ):TPanel;
function fpan_CreateActionPanel ( const awin_Parent : TWinControl ; const acom_Owner : TWinControl ; var apan_ActionPanel : TPanel ):TPanel;
function fgrb_CreateGroupBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TGroupBox;
function fpan_CreatePanel      ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TPanel;
function fscb_CreateScrollBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TScrollBox;
function fdgv_CreateGroupView ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TDBGroupView;
procedure p_SetControlAndParentWidth ( const awin_control, awin_parent : TControl );
procedure p_setComponentLeftWidth  ( const awin_Control : TControl ; const ab_Column : Boolean );
procedure p_setFieldComponentData ( const awin_Control : TWinControl ; const afw_Source : TFWSource ; const afw_columnField : TFWFieldColumn ; const ab_IsLocal : Boolean );
procedure p_setLabelComponent (const awin_Control : TWinControl ; const alab_Label : TFWLabel; const ab_Column : Boolean);
function fdbn_CreateNavigation ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean ; const aal_Align : TAlign ):TExtDBNavigator;
function fdbg_CreateGrid ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean ; const aal_Align : TAlign ):TExtDBGrid;
function fwin_CreateAFieldComponent ( const afdt_FieldDataType : TFWFieldData ; const acom_Owner : TComponent ; const ab_IsLocal : Boolean ):TWinControl;
function fspl_CreateSPlitter ( const awin_Parent : TWinControl ;
                               const as_Name : String;
                               const acom_Owner : TComponent ;
                               const aal_Align : TAlign
                               ):TControl ;
function fpc_CreatePageControl ( const awin_Parent : TWinControl ;
                                 const  as_Name : String;
                                 const  apan_PanelOrigin : TWinControl ;
                                 const acom_Owner : TComponent ): TPageControl;
function fscb_CreateTabSheet (  var   apc_PageControl: TCustomTabControl;
                                const awin_ParentPageControl, awin_PanelOrigin: TWinControl;
                                const as_Name, as_Caption: String;
                                const acom_Owner : TComponent ): TScrollBox;
function ffwc_getRelationComponent (  const afws_sources : TFWSources ;
                                      const afws_source  : TFWSource ;
                                      const awin_Parent  : TWinControl ;
                                      const aff_field    : TFWFieldColumn ;
                                      var   afcb_Button  : TXMLFillCombo ;
                                      const as_MiddleName : String;
                                      const ab_isLocal   : Boolean ;
                                      const acom_owner   : TComponent) : TWinControl;
procedure p_setFieldComponentTop  ( const awin_Control : TWinControl; const ai_lastTop, ai_lastHeight : Integer ; var ab_Column : Boolean ); overload;
procedure p_setFieldComponentTop  ( const awin_Control, awin_last : TWinControl; var ab_Column : Boolean ); overload;
function ffwl_CreateALabelComponent ( const acom_Owner : TComponent ;
                                      const awin_Parent, awin_Control : TWinControl ;
                                      const afcf_ColumnField : TFWFieldColumn;
                                      const as_Name : String ;
                                      const ai_Counter : Longint ;
                                      const ab_Column : Boolean ):TFWLabel;
function fds_CreateGroupViewDataSource (  const as_Table, as_NameEnd : String  ;
                                          const alr_relation : TFWRelation ;
                                          const acom_Owner : TComponent    ): TDatasource;
function fdbg_GroupViewComponents  ( var FPageControlDetails : TCustomTabControl;
                                     const afws_sources : TFWSources ;
                                     const afws_source : TFWSource ;
                                     const awin_Parent : TWinControl ;
                                     const ai_Connection : Integer;
                                     const ads_Connection : TDSSource;
                                     const afr_relation : TFWRelation;
                                     const acom_Owner : TComponent;
                                     const ai_FieldCounter,
                                           ai_counter     : Integer):TDBGroupView;

implementation

uses fonctions_dbcomponents,
{$IFNDEF FPC}
     JvSplitter,
{$ENDIF}
     U_ExtNumEdits,
     u_fillcombobutton,
     u_extfilecomp,
     fonctions_string,
     fonctions_extdb,
     fonctions_createsql,
     u_buttons_appli,
     fonctions_languages;

////////////////////////////////////////////////////////////////////////////////
// function fds_CreateGroupViewDataSource
// create datasource, dataset, setting and open it
// as_Table      : Table name
// as_Fields     : List of fields with comma
// as_NameEnd    : End of components' names
// ar_Connection : Connection of table
// alis_NodeFields : Node of fields' nodes
////////////////////////////////////////////////////////////////////////////////
function fds_CreateGroupViewDataSource (  const as_Table, as_NameEnd : String  ;
                                          const alr_relation : TFWRelation ;
                                          const acom_Owner : TComponent    ): TDatasource;
begin
  with alr_relation.TablesDest [ 0 ].Connection do
    Result := fds_CreateDataSourceAndDataset ( as_Table, as_NameEnd, QueryCopy, acom_Owner );
end;

/////////////////////////////////////////////////////////////////////////
// function ffwl_CreateALabelComponent
// Creating a TFWLabel and setting properties
// acom_Owner : Form
// awin_Parent : Parent component
// awin_Control : Control of label
// afcf_ColumnField : field column definitions
// as_Name : Name of caption
// ai_Counter : Field counter
// ab_Column : Second editing column
// returns TFWLabel;
//////////////////////////////////////////////////////////////////////////

function ffwl_CreateALabelComponent ( const acom_Owner : TComponent ;
                                      const awin_Parent, awin_Control : TWinControl ;
                                      const afcf_ColumnField : TFWFieldColumn;
                                      const as_Name : String ;
                                      const ai_Counter : Longint ;
                                      const ab_Column : Boolean ):TFWLabel;
Begin
  Result := TFWLabel.Create ( acom_Owner );
  with Result do
   Begin
    Parent := awin_Parent ;
    Name   := fs_TextToFileName( CST_COMPONENTS_LABEL_BEGIN+as_Name+IntToStr(afcf_ColumnField.index)+'_'+IntToStr(ai_Counter));
    MyEdit := awin_Control;
    Caption := fs_GetLabelCaption ( as_Name );
    Tag := ai_counter + 1;
   end;
  if assigned ( afcf_ColumnField ) Then
    Begin
      afcf_ColumnField.CaptionName := Result.Caption;
      afcf_ColumnField.HintName := '| ' + afcf_ColumnField.CaptionName;
    end;
  if gb_DoubleColumn and ab_Column
   then awin_Control.Left := CST_XML_FIELDS_CAPTION_SPACE + CST_XML_SEGUND_COLUMN_MIN_POSWIDTH
   Else awin_Control.Left := CST_XML_FIELDS_CAPTION_SPACE ;

end;

function fwin_getChoice ( const acom_Owner : TComponent ; const ab_IsLocal : Boolean ):TWinControl;
Begin
  if ab_IsLocal then
    Result := TRadioGroup.Create ( acom_Owner )
   Else
    Result := TDBRadioGroup.Create ( acom_Owner );
End;


// function fdbg_GroupViewComponents
// Creates a full N-N or N-1 relationships management
// awin_Parent : the parent component of the created components
// anod_NodeRelation : The relationships node
// const alis_ListCrossLink : The other side relationships
// ai_FieldCounter : Table counter
// ai_Counter : Column Counter
// returns the main list

function fdbg_GroupViewComponents  ( var FPageControlDetails : TCustomTabControl;
                                     const afws_sources : TFWSources ;
                                     const afws_source : TFWSource ;
                                     const awin_Parent : TWinControl ;
                                     const ai_Connection : Integer;
                                     const ads_Connection : TDSSource;
                                     const afr_relation : TFWRelation;
                                     const acom_Owner : TComponent;
                                     const ai_FieldCounter,
                                           ai_counter     : Integer):TDBGroupView;
var lpan_ParentPanel   : TWinControl;
    lpan_GroupViewRight,
    lpan_PanelActions,
    lpan_Panel : TPanel ;
    ldgv_GroupViewRight : TDBGroupView ;
    lcon_Control   : TControl;

    procedure p_setGroupmentfields ( const adgv_GroupView : TDBGroupView );
    Begin

      with adgv_GroupView, afws_source, afr_relation do
         Begin
           DataFieldGroup := FieldsFK [ 0 ].FieldName;
           DataFieldUnit  := FieldsFK [ 1 ].FieldName;
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
      with afr_relation,Result do
        Begin
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_ACTIONS + TablesDest.toString(False) + '1', acom_Owner, alLeft );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonRecord := TFWRecord.Create ( acom_Owner );
          ButtonRecord.Parent := lpan_PanelActions;
          lpan_PanelActions.Height := ButtonRecord.Height;
          ButtonRecord.Name := CST_COMPONENTS_RECORD_BEGIN + TablesDest.toString(False);
          ButtonRecord.Align := alLeft ;
          p_setLeftFromPanel ( ButtonRecord );
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_ACTIONS + TablesDest.toString(False) + '2', acom_Owner, alLeft );
          p_setLeftToPanel ( ButtonRecord );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonCancel := TFWCancel.Create ( acom_Owner );
          ButtonCancel.Parent := lpan_PanelActions;
          ButtonCancel.Name := CST_COMPONENTS_ABORT_BEGIN + TablesDest.toString(False);
          ButtonCancel.Align := alLeft ;
          ButtonCancel.Width := ButtonRecord.Width;
          p_setLeftFromPanel ( ButtonCancel );
        end;
    end;

    // procedure p_setAndCreateButtons;
    // Create The buttons of the main group view
    procedure p_CreateAndSetButtonsMoving;
    Begin
      with afr_relation,Result do
        Begin
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + TablesDest.toString(False) + '1', acom_Owner, alTop );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonIn := TFWInSelect.Create ( acom_Owner );
          ButtonIn.Parent := lpan_PanelActions;
          ButtonIn.Name := CST_COMPONENTS_IN_BEGIN + TablesDest.toString(False);
          ( ButtonIn as TFWGroupButtonMoving ).Caption := '' ;
          lpan_PanelActions.Width := ButtonIn.Width;
          p_setTopFromPanel ( ButtonIn );
          ButtonIn.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + TablesDest.toString(False) + '2', acom_Owner, alTop );
          p_setTopToPanel ( ButtonIn );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonOut := TFWOutSelect.Create ( acom_Owner );
          ButtonOut.Parent := lpan_PanelActions;
          ButtonOut.Name := CST_COMPONENTS_OUT_BEGIN + TablesDest.toString(False);
          ( ButtonOut as TFWGroupButtonMoving ).Caption := '' ;
          p_setTopFromPanel ( ButtonOut );
          ButtonOut.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + TablesDest.toString(False) + '3', acom_Owner, alTop );
          p_setTopToPanel ( ButtonOut );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonTotalIn := TFWInAll.Create ( acom_Owner );
          ButtonTotalIn.Parent := lpan_PanelActions;
          ButtonTotalIn.Name := CST_COMPONENTS_INALL_BEGIN + TablesDest.toString(False);
          ( ButtonTotalIn as TFWGroupButtonMoving ).Caption := '' ;
          p_setTopFromPanel ( ButtonTotalIn );
          ButtonTotalIn.Align := alTop ;
          lpan_Panel := fpan_CreatePanel ( lpan_PanelActions, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_INTERLEAVING + CST_COMPONENTS_BUTTONS + TablesDest.toString(False) + '4', acom_Owner, alTop );
          p_setTopToPanel ( ButtonTotalIn );
          lpan_Panel.Width := CST_BUTTONS_INTERLEAVING;
          ButtonTotalOut := TFWOutAll.Create ( acom_Owner );
          ButtonTotalOut.Parent := lpan_PanelActions;
          ButtonTotalOut.Name := CST_COMPONENTS_OUTALL_BEGIN + TablesDest.toString(False);
          ( ButtonTotalOut as TFWGroupButtonMoving ).Caption := '' ;
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
     with adgv_GroupView, afr_relation do
       Begin
         FieldDelimiter    := ',';
         DataKeyOwner      := afws_source.GetKeyString;
         DataKeyUnit       := FieldsFK.ToString;
         DataFieldsDisplay := FieldsDisplay.ToString;
         DataTableGroup    := TablesDest [ 0 ].Table;
         DataTableOwner    := afws_source.Table;
         DataTableUnit     := TablesDest [ 1 ].Table;
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
         for li_i := 0 to FieldsDisplay.Count -1 do
           with Columns.Add do
             begin
               Caption := FieldsDisplay [ li_i ].GetCaption;
             end;
         ShowColumnHeaders:=True;
       end;

   end;

begin
  with afws_source, afr_relation as TFWRelationGroup do
    Begin
      lpan_ParentPanel := fscb_CreateTabSheet ( FPageControlDetails, PanelDetails, awin_Parent, CST_COMPONENTS_DETAILS + IntToStr ( ai_FieldCounter )+ CST_COMPONENTS_GROUPBOX_BEGIN + TablesDest.toString(False) + IntToStr(ai_counter), RelationName, acom_Owner  );
      {$IFDEF FPC}
      lpan_ParentPanel.BeginUpdateBounds;
      {$ENDIF}
      try
  //      lpan_ParentPanel.Hint := fs_GetLabelCaption ( as_Name );
  //      lpan_ParentPanel.ShowHint := True;
        Result := fdgv_CreateGroupView ( lpan_ParentPanel, CST_COMPONENTS_GROUPVIEW_BEGIN + Table + CST_COMPONENTS_LEFT, acom_Owner, alLeft );
        Result.Datasource:=fds_CreateGroupViewDataSource ( Table, IntToStr ( ai_FieldCounter ) + '_' + IntToStr ( ai_Counter ), afr_relation, acom_Owner );
        Result.Width := CST_GROUPVIEW_WIDTH;
        p_setGroupmentfields ( Result );
        GroupView := Result ;
        lpan_PanelActions := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_ACTIONS + Table, acom_Owner, alTop );
        lpan_GroupViewRight := fpan_CreatePanel ( lpan_ParentPanel, CST_COMPONENTS_PANEL_BEGIN + Table + CST_COMPONENTS_RIGHT, acom_Owner, alClient );
        // Creating and setting buttons
        p_CreateAndSetButtonsActions;
        lpan_PanelActions := fpan_CreatePanel ( lpan_GroupViewRight, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_MIDDLE + Table, acom_Owner, alLeft );
        lpan_Panel.width := CST_GROUPVIEW_INOUT_WIDTH + CST_CONTROLS_INTERLEAVING * 2;
        ldgv_GroupViewRight := fdgv_CreateGroupView ( lpan_GroupViewRight, CST_COMPONENTS_GROUPVIEW_BEGIN + Table + CST_COMPONENTS_RIGHT, acom_Owner, alClient );
        p_CreateAndSetButtonsMoving;
        p_setGroupmentfields ( ldgv_GroupViewRight );
        p_setButtons;
        lcon_Control := fspl_CreateSplitter ( lpan_ParentPanel, CST_COMPONENTS_SPLITTER_BEGIN + Table + CST_COMPONENTS_MIDDLE, acom_Owner, alLeft );
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
function fwin_CreateAFieldComponent ( const afdt_FieldDataType : TFWFieldData ; const acom_Owner : TComponent ; const ab_IsLocal : Boolean ):TWinControl;
begin
  Result := nil;
  case afdt_FieldDataType.FieldType of
    ftFloat :
     Begin
      if ab_IsLocal then
        Begin
         Result := TExtNumEdit.Create ( acom_Owner );
         (Result as TExtNumEdit).Text:='';
        end
       else
        Result := TExtDBNumEdit.Create ( acom_Owner );
     end;
  ftMemo : Result := fwin_CreateAEditComponent ( acom_Owner, True, ab_IsLocal );
  ftString:
    Begin
      if foFile in afdt_FieldDataType.Options Then
       Begin
        if ab_IsLocal
          then Result := TFWFileEdit.Create ( acom_Owner )
          else Result := TExtDBFileEdit.Create ( acom_Owner );
       end
      else
        if foChoice in afdt_FieldDataType.Options Then
          Result := fwin_getChoice  ( acom_Owner, ab_IsLocal )
         else
          if ab_IsLocal then
            Result := TFWEdit.Create ( acom_Owner )
           else
            Result := TFWDBEdit.Create ( acom_Owner );
    End;
  ftDate,ftDateTime:
    Begin
      if ab_IsLocal then
        Result := TFWDateEdit.Create ( acom_Owner )
       Else
        Result := TFWDBDateEdit.Create ( acom_Owner );
    End;
    ftInteger :
      Begin
       if foChoice in afdt_FieldDataType.Options Then
        Result := fwin_getChoice  ( acom_Owner, ab_IsLocal )
       else
        if ab_IsLocal then
          Result := TFWSpinEdit.Create ( acom_Owner )
         else
          Result := TFWDBSpinEdit.Create ( acom_Owner );

      end;
  end;
end;


/////////////////////////////////////////////////////////////////////////
// function fwin_CreateAEditComponent
// Creating a text edit component and setting properties
// acom_Owner : Form
// ab_isLarge : Large or litte text edit
// ab_IsLocal : Local or data linked
// returns Memo or edit
//////////////////////////////////////////////////////////////////////////


function fwin_CreateAEditComponent ( const acom_Owner : TComponent ; const ab_isLarge, ab_IsLocal : Boolean ):TWinControl;
Begin
  if ab_isLarge Then
    Begin
      if ab_IsLocal then
        Result := TFWMemo.Create ( acom_Owner )
       else
        Result := TFWDBMemo.Create ( acom_Owner );
    End
   Else
    Begin
      if ab_IsLocal then
        Result := TFWEdit.Create ( acom_Owner )
       else
        Result := TFWDBEdit.Create ( acom_Owner );
    End;
end;

procedure p_setControlNameAndTag  ( const awin_Control : TWinControl ;
                          const as_BeginName,
                                as_MiddleName : String ;
                          const awin_Parent : TWinControl ;
                          const ai_FieldCounter, ai_counter : Longint );
begin
  awin_Control.Parent := awin_Parent ;
  awin_Control.Name := as_BeginName + IntToStr(ai_counter) + as_MiddleName + IntToStr(ai_FieldCounter);
  awin_Control.Tag := ai_FieldCounter + 1;
End;



/////////////////////////////////////////////////////////////////////////
// function fscb_CreateScrollBox
// Creating an scrollbox and setting properties
// awin_Parent : Parent control
// as_Name : Name of scrollbox
// acom_Owner : Form
// aal_Align : Align value
// returns a scrollbox
//////////////////////////////////////////////////////////////////////////
function fscb_CreateScrollBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TScrollBox;
Begin
  Result := TScrollBox.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Align := aal_Align ;
  Result.Name := as_Name;
{$IFDEF FPC}
  Result.Caption := '';
{$ENDIF}

end;


/////////////////////////////////////////////////////////////////////////
// function fpan_CreatePanel
// Creating a panel and setting properties
// awin_Parent : Parent control
// as_Name : Name of panel
// acom_Owner : Form
// aal_Align : Align value
// returns a panel
//////////////////////////////////////////////////////////////////////////

function fpan_CreatePanel ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TPanel;
Begin
  Result := TPanel.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Align := aal_Align ;
  Result.BevelOuter := bvNone ;
  Result.Name := as_Name;
  Result.Caption := '';

End;

/////////////////////////////////////////////////////////////////////////
// function fpan_CreatePanel
// Creating a panel and setting properties
// awin_Parent : Parent control
// as_Name : Name of panel
// acom_Owner : Form
// aal_Align : Align value
// returns a panel
//////////////////////////////////////////////////////////////////////////

function fgrb_CreateGroupBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TGroupBox;
Begin
  Result := TGroupBox.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Align := aal_Align ;
//  Result.BevelOuter := bvNone ;
  Result.Name := as_Name;
  Result.Caption := '';
  Result.Width:=CST_XML_SEGUND_COLUMN_MIN_POSWIDTH-CST_CONTROLS_INTERLEAVING * 2;

End;


/////////////////////////////////////////////////////////////////////////
// function fdgv_CreateGroupView
// Creating an alone GroupView and setting properties
// awin_Parent : Parent control
// as_Name : Name of panel
// acom_Owner : Form
// aal_Align : Align value
// returns a GroupView
//////////////////////////////////////////////////////////////////////////
function fdgv_CreateGroupView ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TDBGroupView;
Begin
  Result := TDBGroupView.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Name := as_name;
  Result.Align := aal_Align ;
End;

/////////////////////////////////////////////////////////////////////////
// function fspl_CreateSPlitter
// Creating an alone Splitter and setting properties
// awin_Parent : Parent control
// as_Name : Name of panel
// acom_Owner : Form
// aal_Align : Align value
// returns a Splitter
//////////////////////////////////////////////////////////////////////////
function fspl_CreateSPlitter ( const awin_Parent : TWinControl ;
                               const as_Name : String;
                               const acom_Owner : TComponent ;
                               const aal_Align : TAlign
                               ):TControl ;
Begin
  {$IFDEF FPC}
  Result := TSplitter.create ( acom_Owner );
  {$ELSE}
  Result := TJvSplitter.create ( acom_Owner );
  {$ENDIF}
  Result.parent := awin_Parent;
  Result.Name := as_Name;
  Result.Align := aal_Align ;
End;

/////////////////////////////////////////////////////////////////////////
// function fdbn_CreateNavigation
// Creating an alone Navigation and setting properties
// awin_Parent : Parent control
// as_Name : Name of panel
// acom_Owner : Form
// ab_Edit : Editing
// aal_Align : Align value
// returns an ExtDBNavigator
//////////////////////////////////////////////////////////////////////////
function fdbn_CreateNavigation ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean  ; const aal_Align : TAlign ):TExtDBNavigator;
Begin
  Result := TExtDBNavigator.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Name := As_Name;
  Result.GlyphSize := gsLarge ;
  Result.Align := alTop ;
  if not ab_Edit then
    Begin
      Result.VisibleButtons := [nbEFirst, nbEPrior, nbENext, nbELast];
    End
  else
    Begin
      Result.VisibleButtons := [];
    End;

End;

procedure p_setFieldComponentData ( const awin_Control : TWinControl ; const afw_Source : TFWSource ; const afw_columnField : TFWFieldColumn ; const ab_IsLocal : Boolean );
begin
  if not ab_IsLocal Then
    Begin
      p_setComponentData ( awin_Control, afw_Source.Datasource, afw_columnField.FieldName );
    end;
end;



/////////////////////////////////////////////////////////////////////////
// function fpan_CreateActionPanel
// Creating an Action Panel and setting buttons properties
// awin_Parent : Parent control
// acom_Owner : Form
// apan_ActionPanel : Creating Action Panel to set
// returns a main panel
//////////////////////////////////////////////////////////////////////////
function fpan_CreateAction ( const abut_Button : TFWXPButton ; const as_name : String ; const acom_Owner : TWinControl ; const apan_ActionPanel : TPanel ):TPanel;
Begin
  abut_Button.Parent := apan_ActionPanel;
  abut_Button.Name := CST_COMPONENTS_BUTTON_BEGIN + as_name;
  abut_Button.Align := alRight ;
  Result := fpan_CreatePanel ( apan_ActionPanel, CST_COMPONENTS_PANEL_BEGIN + as_name, acom_Owner, alRight );
  Result.Width := 10;
  Result.Name := CST_COMPONENTS_PANEL_BEGIN + as_name;;
End;

/////////////////////////////////////////////////////////////////////////
// function fpan_CreateActionPanel
// Creating an Action Panel and setting buttons properties
// awin_Parent : Parent control
// acom_Owner : Form
// apan_ActionPanel : Creating Action Panel to set
// returns a main panel
//////////////////////////////////////////////////////////////////////////
function fpan_CreateActionPanel ( const awin_Parent : TWinControl ; const acom_Owner : TWinControl ; var apan_ActionPanel : TPanel ):TPanel;
var lbut_Button : TFWButton;
Begin
  apan_ActionPanel := fpan_CreatePanel ( acom_Owner, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_ACTIONS, acom_Owner, alTop );
  lbut_Button := TFwClose.Create ( acom_Owner );
  fpan_CreateAction ( lbut_Button, CST_COMPONENTS_BUTTON_CLOSE, acom_Owner, apan_ActionPanel);
  apan_ActionPanel.Height := lbut_Button.GlyphSize + 2 ;
  Result := fpan_CreatePanel ( acom_Owner, CST_COMPONENTS_PANEL_MAIN, acom_Owner, alClient );
End;



/////////////////////////////////////////////////////////////////////////
// function fdbg_CreateGrid
// Creating a DB Grid and setting properties
// awin_Parent : Parent control
// as_Name : Name of Db Grid
// acom_Owner : Form
// ab_Edit : Editings
// aal_Align : Align property to set
// returns a DB Grid
//////////////////////////////////////////////////////////////////////////
function fdbg_CreateGrid ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean ; const aal_Align : TAlign ):TExtDBGrid;
Begin
  Result := TExtDBGrid.create ( acom_Owner );
  Result.parent := awin_Parent;
  Result.Name := as_Name;
  // form can be packed with autosize
  Result.Constraints.MinHeight:=200;
  Result.Constraints.MinWidth :=200;
  Result.Align := alClient ;
  if not ab_Edit then
    Begin
      Result.Readonly := True;
    End;

End;


// fonction fpc_CreatePageControl
// Creating a pagecontrol
// awin_Parent : Parent component
// as_Name : name of pagecontrol
// apan_PanelOrigin : Changing The non pagecontrol panel and adding it to the tabsheet getting 2 tabsheet
function fpc_CreatePageControl ( const awin_Parent : TWinControl ;
                                 const  as_Name : String;
                                 const  apan_PanelOrigin : TWinControl ;
                                 const acom_Owner : TComponent ): TPageControl;
var ltbs_Tabsheet : TTabSheet ;
begin
  Result := TPageControl.Create ( acom_Owner );
  Result.Parent := awin_Parent;
  Result.Name := CST_COMPONENTS_PAGECONTROL_BEGIN + as_Name;
  Result.Align := alClient;
  ltbs_Tabsheet := TTabSheet.Create ( acom_Owner );
  ltbs_Tabsheet.PageControl := Result as TPageControl;
  ltbs_Tabsheet.Align := alClient;
  ltbs_Tabsheet.Caption := awin_Parent.Hint;
  ltbs_Tabsheet.Name := CST_COMPONENTS_TABSHEET_BEGIN + awin_Parent.Name;
  // Le panneau d'origine change de parent
  apan_PanelOrigin.Parent := ltbs_Tabsheet;
End;

procedure p_setComponentLeftWidth  ( const awin_Control : TControl ; const ab_Column : Boolean );
begin
  with awin_Control do
    Begin
      if gb_DoubleColumn and ab_Column
       then Left := CST_XML_SEGUND_COLUMN_MIN_POSWIDTH + CST_CONTROLS_INTERLEAVING
       Else Left := CST_CONTROLS_INTERLEAVING ;
      Width := CST_XML_SEGUND_COLUMN_MIN_POSWIDTH-CST_CONTROLS_INTERLEAVING*2;
    end;
end;

// procedure p_SetControlAndParentWidth
// Setting parent component width
procedure p_SetControlAndParentWidth ( const awin_control, awin_parent : TControl );
Begin
  with awin_control do
    Begin
      if Width > CST_XML_SEGUND_COLUMN_MIN_POSWIDTH * 2  Then
        Width:=CST_XML_SEGUND_COLUMN_MIN_POSWIDTH * 2;
      if Left + Width + CST_CONTROLS_INTERLEAVING > awin_Parent.ClientWidth Then
        awin_Parent.ClientWidth := Left + Width + CST_CONTROLS_INTERLEAVING;
      awin_Parent.ClientHeight := Top + Height + CST_CONTROLS_INTERLEAVING;
    end;
end;



// procedure p_setLabelComponent
// after having fully read the field nodes last setting of label component
// awin_Control : Field Component
// alab_Label : Label to set
// ab_Column : Second editing column
procedure p_setLabelComponent (const awin_Control : TWinControl ; const alab_Label : TFWLabel; const ab_Column : Boolean);
begin
  if assigned ( alab_Label ) then
   with alab_Label do
    Begin
      Top  := awin_Control.Top + ( awin_Control.Height - Height ) div 2 ;
      Width := CST_XML_FIELDS_CAPTION_SPACE - CST_XML_FIELDS_LABEL_INTERLEAVING;
      if gb_DoubleColumn and ab_Column
       then Left := CST_XML_SEGUND_COLUMN_MIN_POSWIDTH + CST_CONTROLS_INTERLEAVING
       else Left := CST_CONTROLS_INTERLEAVING;
    End;
end;


// function fscb_CreateTabSheet
// Create a tabsheet and so a pagecontrol
// apc_PageControl : Page control to eventually create
// awin_ParentPageControl : Parent of pagecontrol
//  awin_PanelOrigin    : Panel not in a pagecontrol
// as_Name              : Pagecontrol name
// as_Caption : old caption
// ai_Counter : COlumn counter
function fscb_CreateTabSheet (  var   apc_PageControl: TCustomTabControl;
                                const awin_ParentPageControl, awin_PanelOrigin: TWinControl;
                                const as_Name, as_Caption: String;
                                const acom_Owner : TComponent ): TScrollBox;
var ltbs_Tabsheet : TTabSheet ;
begin
  if apc_PageControl = nil then
    apc_PageControl := fpc_CreatePageControl ( awin_ParentPageControl, as_Name, awin_PanelOrigin, acom_Owner );
  ltbs_Tabsheet := TTabSheet.Create ( acom_Owner );
  ltbs_Tabsheet.Align := alClient;
  ltbs_Tabsheet.PageControl := apc_PageControl as TPageControl;
  ltbs_Tabsheet.Caption := fs_getlabelCaption ( as_Caption );
  Result := fscb_CreateScrollBox ( ltbs_Tabsheet, CST_COMPONENTS_TABSHEET_BEGIN +as_Name, acom_Owner, alClient );

end;

//procedure p_setFieldComponenttop
// Set control top
// awin_Control : Component to set
// ab_Column : Second editing column
procedure p_setFieldComponentTop  ( const awin_Control : TWinControl; const ai_lastTop, ai_lastHeight : Integer ; var ab_Column : Boolean );
begin
  if gb_DoubleColumn and ab_Column and ( awin_Control.Width < CST_XML_SEGUND_COLUMN_MIN_POSWIDTH )  Then
   // Intervalle entre les champs
    awin_Control.Top := ai_lastTop + CST_CONTROLS_INTERLEAVING
   Else
    Begin
     awin_Control.Top := ai_lastTop + ai_lastHeight  + CST_CONTROLS_INTERLEAVING ;
     ab_Column:=False;
    end;

end;
procedure p_setFieldComponentTop  ( const awin_Control, awin_last : TWinControl; var ab_Column : Boolean );
begin
  if awin_last = nil
    Then p_setFieldComponentTop ( awin_Control, 0,0, ab_Column )
    Else p_setFieldComponentTop ( awin_Control, awin_last.Top,awin_last.Height, ab_Column )
end;
function ffwc_getRelationComponent (  const afws_sources : TFWSources ;
                                      const afws_source  : TFWSource ;
                                      const awin_Parent  : TWinControl ;
                                      const aff_field    : TFWFieldColumn ;
                                      var   afcb_Button  : TXMLFillCombo ;
                                      const as_MiddleName : String;
                                      const ab_isLocal   : Boolean ;
                                      const acom_owner   : TComponent) : TWinControl;
var LPageControl:TCustomTabControl;
begin
  if (aff_field.Relation.TablesDest.Count > 0) Then
   begin
    if not ab_IsLocal Then
     Begin
       afcb_Button:=ffc_CreateFillComboButton(acom_Owner) as TXMLFillCombo;
       afcb_Button.Combo:=TFWDBLookupCombo.Create(acom_Owner);
       Result:=afcb_Button.Combo;
       with afcb_Button,Combo,aff_field.Relation,TablesDest[0] do
         Begin
           FormRegisteredName:=TableKey;
           //MyShowMessage(tablekey);
           FormSource:=0;
           p_SetSQLQuery (DataSource.DataSet,FieldsDisplay,FieldsFK,Table);
           p_SetComboProperties ( Result, Datasource, aff_field.Relation );
           DisplayAllFields:=True;
           try
             Datasource.DataSet.Open;
           Except
           end;
         end;
     // set name of button
     p_setControlNameAndTag( afcb_Button, 'xfc_1N', as_MiddleName, awin_Parent, aff_field.Index, afws_Source.Index);

     end
    Else Result:=Nil;
   End
  Else
   with afws_Source,Relations do
   Begin
    LPageControl := PageControlDetails;
    Result:=fdbg_GroupViewComponents( LPageControl,afws_sources,afws_source,awin_Parent,-1,Connection,Items[Count-1],acom_owner,aff_field.Index,Index);
    PageControlDetails:=LPageControl;
   end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_autocomponents );
{$ENDIF}
end.
