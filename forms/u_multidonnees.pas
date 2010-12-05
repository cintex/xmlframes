////////////////////////////////////////////////////////////////////////////////
//
//	Nom Unité :  U_Données
//	Description :	Datamodule divers de données
//	Crée par Microcelt
//	Modifié le 05/07/2004
//
////////////////////////////////////////////////////////////////////////////////

unit u_multidonnees;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

{$I ..\compilers.inc}
{$I ..\extends.inc}

interface

uses
  Classes,
{$IFDEF FPC}
  SDFData,
{$ELSE}
  JvCSvData,
{$ENDIF}
{$IFNDEF CSV}
{$IFDEF EADO}
  ADODB,
{$ENDIF}
{$IFDEF ZEOS}
  ZConnection,
  ZDataset,
{$ENDIF}
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  DB;

{$IFDEF VERSIONS}
const
      gver_M_Donnees : T_Version = ( Component : 'Data Module with connections and cloned queries.' ; FileUnit : 'U_multidonnees' ;
                        			           Owner : 'Matthieu Giroux' ;
                        			           Comment : 'Created from XML file.' ;
                        			           BugsStory   : 'Version 1.0.0.0 : ZEOS, CSV and DELPHI ADO Version.'  ;
                        			           UnitType : 2 ;
                        			           Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}

      // ADO ZEOS CSV
type TDatasetType = ({$IFNDEF FPC}dtADO,{$ENDIF}{$IFDEF ZEOS}dtZEOS,{$ENDIF}dtCSV);
    // Connection parameters
     TAConnection = Record
                     Clep : String ;
                     dat_QueryCopy : TDataset ;
                     dtt_DatasetType : TDatasetType;
                     com_Connection : TComponent;
                     s_dataURL      : String ;
                     i_DataPort     : Integer ;
                     s_DataUser     : String ;
                     s_DataPassword : String ;
                     s_Database     : String ;
                     s_DataDriver   : String ;
                    end;

var gs_DataExtension : String = '.res';
    ga_Connections : Array of TAConnection;

procedure p_setMiniConnectionTo ( const ar_Source : TAConnection; var ar_Destination : TAConnection );
procedure p_setConnectionTo ( const ar_Source : TAConnection; var ar_Destination : TAConnection );
function fi_FindConnection ( const as_Clep : String ; const ab_Show_Error : Boolean ): Integer ;
function fs_getSoftData : String;

type

  { TM_Donnees }

  TM_Donnees = class(TDataModule)
   {$IFNDEF CSV}
    procedure ConnectionAfterConnect(Sender: TObject);
		procedure ConnectionAfterDisconnect(Sender: TObject);
   {$IFDEF EADO}
    procedure ConnectionExecuteComplete(Connection: TADOConnection;
      RecordsAffected: Integer; const Error: Error;
      var EventStatus: TEventStatus; const Command: _Command;
      const Recordset: _Recordset);
    procedure ConnectionWillExecute(Connection: TADOConnection;
      var CommandText: WideString; var CursorType: TCursorType;
      var LockType: TADOLockType; var CommandType: TCommandType;
      var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;
      const Command: _Command; const Recordset: _Recordset);
    {$ENDIF}
    {$ENDIF}
    procedure DataModuleCreate(Sender: TObject);

	private
		{ Déclarations privées }
		gi_RequetesSQLEncours : Integer ;
  protected
    procedure InitializeControls; virtual;
	public
    procedure CreateConnection ( const adtt_DatasetType : TDatasetType ; const as_Clep : String ); virtual;
    constructor Create ( AOwner : TComponent );override;
		{ Déclarations publiques }
	end;

var
	M_Donnees: TM_Donnees;

implementation


uses Forms, Controls, SysUtils,
{$IFDEF CSV}
     StrUtils,
{$ENDIF}
{$IFDEF FPC}
  FileUtil,
{$ENDIF}
  U_FormMainIni, Dialogs,
  fonctions_string, fonctions_dbcomponents, fonctions_proprietes ;

{$IFNDEF CSV}
////////////////////////////////////////////////////////////////////////////////
// Evènement   : ConnectionAfterConnect
// Description : Connexion principale établie
// Paramètre   : Sender : Le Module
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.ConnectionAfterConnect(Sender: TObject);
begin
  if  assigned ( Application.MainForm )
  and ( Application.MainForm is TF_FormMainIni ) Then
    ( Application.MainForm as TF_FormMainIni ).p_Connectee ;
end;

////////////////////////////////////////////////////////////////////////////////
// Evènement   : ConnectionAfterDisconnect
// Description : Déconnecté aux données principales
// Paramètre   : Sender : Le Module
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.ConnectionAfterDisconnect(Sender: TObject);
begin
  if  assigned ( Application.MainForm )
  and ( Application.MainForm is TF_FormMainIni ) Then
    ( Application.MainForm as TF_FormMainIni ).p_PbConnexion ;
end;

{$IFDEF EADO}
////////////////////////////////////////////////////////////////////////////////
// Evènement   : ConnectionWillExecute
// Description : Curseur SQL avec compteur de requête pour
// Paramètres  : Connection : le connecteur
//               Error          : nom de l'erreur
// Paramètres à modifier  :
//               EventStatus    : Status de l'évènement ( erreur ou pas )
//               Command        : commande ADO
//               Recordset      : Données ADO
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.ConnectionExecuteComplete(
	Connection: TADOConnection; RecordsAffected: Integer; const Error: Error;
	var EventStatus: TEventStatus; const Command: _Command;
	const Recordset: _Recordset);
begin
	// Décrémentation
	dec ( gi_RequetesSQLEncours );
	// Curseur classique
	Screen.Cursor := crDefault ;
	if gi_RequetesSQLEncours > 0 Then
		// Curseur SQL en scintillement si requête asynchrone
		Screen.Cursor := crSQLWait
	Else
		// Une reqête n'a peut-être pas été terminée
		gi_RequetesSQLEncours := 0 ;
end;

////////////////////////////////////////////////////////////////////////////////
// Evènement   : ConnectionWillExecute
// Description : Curseur SQL avec compteur de requête pour
// Paramètres  : Connection : le connecteur
// Paramètres à modifier  :
//							 CommandText : Le code SQL
//               CursorType  : Type de curseur
//               LockType    : Le mode d'accès en écriture
//               CommandType : Type de commande SQL
//               ExecuteOptions : Paramètres d'exécution
//               EventStatus    : Status de l'évènement ( erreur ou pas )
//               Command        : commande ADO
//               Recordset      : Données ADO
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.ConnectionWillExecute(Connection: TADOConnection;
	var CommandText: WideString; var CursorType: TCursorType;
	var LockType: TADOLockType; var CommandType: TCommandType;
	var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;
	const Command: _Command; const Recordset: _Recordset);
begin
	// Incrémente les requêtes
	inc ( gi_RequetesSQLEncours );
	// Curseur SQL
	Screen.Cursor := crSQLWait ;
end;
{$ENDIF}
{$ENDIF}
////////////////////////////////////////////////////////////////////////////////
// Evènement : Create
// Description : Initialisation des variables
// Paramètre : Sender : la fiche
////////////////////////////////////////////////////////////////////////////////
constructor TM_Donnees.Create(AOwner: TComponent);
begin
  if not ( csDesigning in ComponentState ) Then
    Try
      GlobalNameSpace.BeginWrite;
      {$IFDEF FPC}
      CreateNew(AOwner,0 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      InitializeControls;
      DoCreate;
      M_Donnees := Self ;

    Finally
      GlobalNameSpace.EndWrite;
    End
  Else
   inherited ;
End;
////////////////////////////////////////////////////////////////////////////////
// procedure CreateConnection
// Creating a connection and setting query
// adtt_DatasetType : Dataset type
// as_Clep : Clep of connection from XML file to set
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.CreateConnection ( const adtt_DatasetType : TDatasetType  ; const as_Clep : String );
var lmet_MethodeDistribueeSearch: TMethod;
Begin
 SetLength(ga_Connections, high ( ga_Connections ) + 2);
 with ga_Connections [ high ( ga_Connections )] do
   Begin
     Clep := as_Clep ;
     dtt_DatasetType := adtt_DatasetType;
     case adtt_DatasetType of
       {$IFDEF ZEOS}
       dtZEOS : Begin
                  dat_QueryCopy := TZQuery.Create(Self);
                  com_Connection :=TZConnection.Create(Self);
                  ( dat_QueryCopy as TZQuery ).Connection := com_Connection as TZConnection;
                End;
       {$ENDIF}
       {$IFDEF EADO}
       dtADO  : Begin
                  dat_QueryCopy := TADOQuery.Create(Self);
                  com_Connection :=TADOConnection.Create(Self);
                  ( dat_QueryCopy as TADOQuery ).Connection :=com_Connection as TADOConnection;
                End;
       {$ENDIF}
     end;

   if not assigned ( com_Connection )  then
     Exit;
   lmet_MethodeDistribueeSearch.Data := Self;
   with com_Connection do
     begin
       Name := Clep+IntToStr(high(ga_Connections));
       p_setComponentBoolProperty   ( com_Connection, 'LoginPrompt', False );
       lmet_MethodeDistribueeSearch.Code := MethodAddress('ConnectionAfterConnect');
       p_setComponentMethodProperty ( com_Connection, 'AfterConnect', lmet_MethodeDistribueeSearch );
       lmet_MethodeDistribueeSearch.Code := MethodAddress('ConnectionAfterDisconnect');
       p_setComponentMethodProperty ( com_Connection, 'AfterDisconnect', lmet_MethodeDistribueeSearch );
       {$IFDEF EADO}
       if com_Connection is TADOConnection then
         Begin
           ( com_Connection as TADOConnection ).OnExecuteComplete := ConnectionExecuteComplete;
           ( com_Connection as TADOConnection ).OnWillExecute := ConnectionWillExecute;
         End;
       {$ENDIF}
     end;
   end;

End;

////////////////////////////////////////////////////////////////////////////////
// procedure InitializeControls
// setting dataModule
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.InitializeControls;
Begin
 OnCreate := DataModuleCreate;
end;

////////////////////////////////////////////////////////////////////////////////
// procedure and event DataModuleCreate
// gi_RequetesSQLEncours : Setting module
////////////////////////////////////////////////////////////////////////////////
procedure TM_Donnees.DataModuleCreate(Sender: TObject);
begin
  gi_RequetesSQLEncours := 0 ;
end;

{ functions }

////////////////////////////////////////////////////////////////////////////////
// procedure p_setMiniConnectionTo
// setting some parameters of connection ar_Destination from ar_Source
// ar_Source : TaConnection to copy
// ar_Destination   : TaConnection to set
////////////////////////////////////////////////////////////////////////////////

procedure p_setMiniConnectionTo ( const ar_Source : TAConnection; var ar_Destination : TAConnection );
Begin
  with ar_Destination do
    Begin
      Clep           := ar_Source.Clep;
      com_Connection := ar_Source.com_Connection;
      dat_QueryCopy  := ar_Source.dat_QueryCopy;
      s_dataURL      := ar_Source.s_dataURL;
    end;
end;


////////////////////////////////////////////////////////////////////////////////
// procedure p_setConnectionTo
// setting parameters of connection ar_Destination from ar_Source
// ar_Source : TaConnection to copy
// ar_Destination   : TaConnection to set
////////////////////////////////////////////////////////////////////////////////
procedure p_setConnectionTo ( const ar_Source : TAConnection; var ar_Destination : TAConnection );
Begin
  p_setMiniConnectionTo ( ar_Source, ar_Destination );
  with ar_Destination do
    Begin
      s_Database     := ar_Source.s_Database;
      s_DataDriver   := ar_Source.s_DataDriver;
      s_DataPassword := ar_Source.s_DataPassword;
      s_DataUser     := ar_Source.s_DataUser;
      i_DataPort     := ar_Source.i_DataPort;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
// function fi_FindConnection
// as_Clep : XML File Clep which find the connection
// return the number of TAConnection
////////////////////////////////////////////////////////////////////////////////
function fi_FindConnection ( const as_Clep : String ; const ab_Show_Error : Boolean ): Integer ;
var li_i : Integer;
Begin
  Result := -1 ;
  for li_i := 0 to high ( ga_Connections ) do
    if ga_connections [ li_i ].Clep = as_Clep Then
      Result := li_i;
 if  ( result = -1 ) Then
   Begin
    if ( as_Clep = '' ) Then
     Result := low ( ga_Connections )
    Else
     if ab_Show_Error Then
       Begin
         ShowMessage ( 'Connection ' + as_Clep + ' not found !' );
         Abort;
       end;
  End;
end;

////////////////////////////////////////////////////////////////////////////////
// function fs_getSoftData
// getting the data directory
// returns data path
////////////////////////////////////////////////////////////////////////////////
function fs_getSoftData : String;
Begin
  Result := ExtractFileDir( Application.ExeName ) + 'data' + DirectorySeparator ;
End;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gver_M_Donnees );
{$ENDIF}
end.
