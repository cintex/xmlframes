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
  Controls, Classes, Dialogs, DB,
  U_ExtDBNavigator, Buttons, Forms, DBCtrls,
  SysUtils,ComCtrls, TypInfo, Variants,
  U_FormMainIni, u_framework_dbcomponents,
  fonctions_manbase, StdCtrls, u_extdbgrid,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  U_CustomFrameWork, u_framework_components,
  u_multidata,U_GroupView, ExtCtrls ;


const CST_GRID_NAVIGATION_WIDTH         = 200 ;
      CST_GRID_NAVIGATION_MIN_WIDTH     = 15 ;
      CST_GRID_FORM_FIELDS_HEIGHT       = 12 ;
      CST_BUTTONS_INTERLEAVING          = 10;
      CST_GROUPVIEW_WIDTH               = 200;
      CST_GROUPVIEW_INOUT_WIDTH         = 70;
      CST_GROUPVIEW_BUTTONS_WIDTH       = 80;
      CST_XML_FIELDS_INTERLEAVING       = 4;
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
      CST_COMPONENTS_SPLITTER_BEGIN     = 'spl_' ;
      CST_COMPONENTS_GROUPVIEW_BEGIN    = 'grv_' ;
      CST_COMPONENTS_RECORD_BEGIN       = 'fwr_Record' ;
      CST_COMPONENTS_ABORT_BEGIN        = 'fwa_Abort' ;
      CST_COMPONENTS_IN_BEGIN           = 'fwi_In' ;
      CST_COMPONENTS_INALL_BEGIN        = 'fwi_InAll' ;
      CST_COMPONENTS_OUT_BEGIN          = 'fwo_Out' ;
      CST_COMPONENTS_OUTALL_BEGIN       = 'fwo_OutAll' ;
      CST_COMPONENTS_FORM_BEGIN         = 'f_' ;

      CST_COMPONENTS_BUTTON_CLOSE       = 'fwc_Close' ;
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
      CST_COMPONENTS_MAIN               = 'Main' ;
      CST_COMPONENTS_CONTROLS           = 'Controls' ;
      CST_COMPONENTS_ACTIONS            = 'Actions' ;

var  gi_FontHeight : Integer = 24 ;

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

function fwin_CreateAEditComponent ( const acom_Owner : TComponent ; const ab_isLarge, ab_IsLocal : Boolean ):TWinControl;
function fpan_CreateActionPanel ( const awin_Parent : TWinControl ; const acom_Owner : TWinControl ; var apan_ActionPanel : TPanel ):TPanel;
function fgrb_CreateGroupBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TGroupBox;
function fpan_CreatePanel      ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TPanel;
function fscb_CreateScrollBox ( const awin_Parent : TWinControl ;  const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TScrollBox;
function fdgv_CreateGroupView ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const aal_Align : TAlign ):TDBGroupView;
function fdbn_CreateNavigation ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean ; const aal_Align : TAlign ):TExtDBNavigator;
function fdbg_CreateGrid ( const awin_Parent : TWinControl ; const as_Name : String; const acom_Owner : TComponent ; const ab_Edit : Boolean ; const aal_Align : TAlign ):TExtDBGrid;
function fspl_CreateSPlitter ( const awin_Parent : TWinControl ;
                               const as_Name : String;
                               const acom_Owner : TComponent ;
                               const aal_Align : TAlign
                               ):TControl ;
function ffwl_CreateALabelComponent ( const acom_Owner : TComponent ; const awin_Parent, awin_Control : TWinControl ; const afcf_ColumnField : TFWFieldColumn; const as_Name : String ; const ai_Counter : Longint ; const ab_Column : Boolean ):TFWLabel;

implementation

uses JvXPButtons,fonctions_dbcomponents,
{$IFNDEF FPC}
     JvSplitter,
{$ENDIF}
     U_ExtNumEdits,
     u_buttons_appli, fonctions_proprietes,
     u_fillcombobutton,fonctions_languages;

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

function ffwl_CreateALabelComponent ( const acom_Owner : TComponent ; const awin_Parent, awin_Control : TWinControl ; const afcf_ColumnField : TFWFieldColumn; const as_Name : String ; const ai_Counter : Longint ; const ab_Column : Boolean ):TFWLabel;
Begin
  Result := TFWLabel.Create ( acom_Owner );
  Result.Parent := awin_Parent ;
  Result.MyEdit := awin_Control;
  Result.Caption := fs_GetLabelCaption ( as_Name );
  Result.Tag := ai_counter + 1;
  if assigned ( afcf_ColumnField ) Then
    Begin
      afcf_ColumnField.CaptionName := Result.Caption; //lnod_FieldProperties.Attributes [ CST_LEON_VALUE ]);
      afcf_ColumnField.HintName := '| ' + afcf_ColumnField.CaptionName;
    end;
  if ab_Column then
    awin_Control.Left := CST_XML_FIELDS_CAPTION_SPACE + CST_XML_SEGUND_COLUMN_MIN_POSWIDTH
   Else
    awin_Control.Left := CST_XML_FIELDS_CAPTION_SPACE ;

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


/////////////////////////////////////////////////////////////////////////
// function fpan_CreateActionPanel
// Creating an Action Panel and setting buttons properties
// awin_Parent : Parent control
// acom_Owner : Form
// apan_ActionPanel : Creating Action Panel to set
// returns a main panel
//////////////////////////////////////////////////////////////////////////
function fpan_CreateActionPanel ( const awin_Parent : TWinControl ; const acom_Owner : TWinControl ; var apan_ActionPanel : TPanel ):TPanel;
var lbut_Button : TFwClose;
Begin
  apan_ActionPanel := fpan_CreatePanel ( acom_Owner, CST_COMPONENTS_PANEL_BEGIN + CST_COMPONENTS_ACTIONS, acom_Owner, alTop );
  lbut_Button := TFwClose.Create ( acom_Owner );
  lbut_Button.Parent := apan_ActionPanel;
  lbut_Button.Name := CST_COMPONENTS_BUTTON_CLOSE;
  apan_ActionPanel.Height := lbut_Button.Height ;
  lbut_Button.Align := alRight ;
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
  Result.Align := alClient ;
  if not ab_Edit then
    Begin
      Result.Readonly := True;
    End;

End;


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_autocomponents );
{$ENDIF}
end.
