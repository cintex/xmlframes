////////////////////////////////////////////////////////////////////////////////
//
//	Nom Unité :  U_MultiDonnées
//	Description :	Datamodule divers de données
//	Créée par Matthieu GIROUX liberlog.fr en 2010
//
////////////////////////////////////////////////////////////////////////////////

unit u_multidonnees;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
  Classes,
{$IFDEF CSV}
{$IFDEF FPC}
  SDFData,
{$ELSE}
  JvCSvData,
{$ENDIF}
{$ENDIF}
{$IFDEF EADO}
  ADODB,
{$ENDIF}
{$IFDEF IBX}
  IBQuery, IB, IBDatabase,
{$ENDIF}
{$IFDEF ZEOS}
  ZConnection,
  ZDataset,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  DB, u_multidata;

{$IFDEF VERSIONS}
const
      gver_M_Donnees : T_Version = ( Component : 'Data Module with connections and cloned queries.' ; FileUnit : 'U_multidonnees' ;
                        			           Owner : 'Matthieu Giroux' ;
                        			           Comment : 'Created from XML file.' ;
                        			           BugsStory   : 'Version 1.0.0.1 : IBX Version.' + #13#10
                                                                       + 'Version 1.0.0.0 : ZEOS, CSV and DELPHI ADO Version.'  ;
                        			           UnitType : 2 ;
                        			           Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}


type

   { TDMModuleSources }

   TDMModuleSources= class(TMDataSources)
   public
     constructor Create(AOwner: TComponent);
     End;

var
  DMModuleSources: TDMModuleSources = nil;

function fs_getSoftData : String;


implementation


uses Forms, Controls, SysUtils,
{$IFDEF CSV}
     StrUtils,
{$ENDIF}
{$IFDEF FPC}
  FileUtil,
{$ENDIF}
  U_FormMainIni, Dialogs,
  fonctions_string, fonctions_proprietes ;

////////////////////////////////////////////////////////////////////////////////
// function fs_getSoftData
// getting the data directory
// returns data path
////////////////////////////////////////////////////////////////////////////////
function fs_getSoftData : String;
Begin
  Result := ExtractFileDir( Application.ExeName ) + 'data' + DirectorySeparator ;
End;

constructor TDMModuleSources.Create(AOwner: TComponent);
begin
  if not ( csDesigning in ComponentState ) Then
    Try
      GlobalNameSpace.BeginWrite;
      {$IFDEF FPC}
      CreateNew(AOwner, 0 );
      {$ELSE}
      CreateNew(AOwner);
      {$ENDIF}
      ModuleCreate;
      DoCreate;
      DMModuleSources := Self ;

    Finally
      GlobalNameSpace.EndWrite;
    End
  Else
   inherited ;
End;
{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gver_M_Donnees );
{$ENDIF}
end.
