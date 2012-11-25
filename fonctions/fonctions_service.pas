unit fonctions_service;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils, ALXmlDoc;

  {$IFDEF VERSIONS}
const
  gver_fonctions_service : T_Version = (Component : 'XML Service Unit' ;
                                           FileUnit : 'fonctions_service' ;
              			           Owner : 'Matthieu Giroux' ;
              			           Comment : 'Centralizing service.' ;
              			           BugsStory : 'Version 0.9.0.0 : Centralized unit.';
              			           UnitType : 1 ;
              			           Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );

{$ENDIF}

procedure p_LoadData ( const axno_Node : TALXMLNode );
function fs_getIniOrNotIniValue ( const as_Value : String ) : String;

implementation

uses u_multidata, u_multidonnees, fonctions_xml,
     U_FormMainIni, fonctions_init, fonctions_proprietes,
     DB;


/////////////////////////////////////////////////////////////////////////
// function fs_getIniOrNotIniValue
// Loading  from ini
// as_Value : Value to find from ini
/////////////////////////////////////////////////////////////////////////
function fs_getIniOrNotIniValue ( const as_Value : String ) : String;
Begin
  if  ( as_Value <> '' )
  and ( as_Value [1] = '$' )
  and Assigned(gmif_MainFormIniInit)
   Then Result := gmif_MainFormIniInit.ReadString( INISEC_PAR, copy ( as_Value, 2, Length(as_Value) -1 ), as_Value )
   else Result := as_Value;
End;

procedure p_LoadConnection ( const aNode : TALXMLNode ; const ads_connection : TDSSource );
var li_Pos : LongInt ;
Begin
  with ads_connection do
   Begin
    DataURL := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_URL ]);
    li_Pos := pos ( '//', DataURL );
    DataURL := copy ( DataURL , li_pos + 2, length ( DataURL ) - li_pos - 1 );
    DataPort := 0;
    li_Pos := pos ( ':', DataURL );
    // Récupération du port
    if li_Pos > 0 Then
      try
        if pos ( '/', DataURL ) > 0 Then
          DataPort    := StrToInt ( copy ( DataURL, li_Pos + 1, pos ( '/', DataURL ) - li_pos - 1 ))
         Else
          DataPort    := StrToInt ( copy ( DataURL, li_Pos + 1, length ( DataURL ) - li_pos ));
        // Finition de l'URL : Elle ne contient que l'adresse du serveur
        DataURL := copy ( DataURL , 1, li_Pos - 1 );
      Except
      end;
    if ( DataURL [ length ( DataURL )] = '/' ) Then
      DataURL := copy ( DataURL , 1, length ( DataURL ) - 1 );
    DataUser := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_USER ]);
    DataPassword :=fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_Password ]);
    Database := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_DATABASE ]);
    DataDriver := fs_getIniOrNotIniValue ( aNode.Attributes [ CST_LEON_DATA_DRIVER ]);
     p_setComponentProperty ( Connection, 'User', DataUser );
     p_setComponentProperty ( Connection, 'Password', DataPassword );
     p_setComponentProperty ( Connection, 'Hostname', DataURL );
     p_setComponentProperty ( Connection, 'Database', Database );
     if DataPort > 0 Then
       p_setComponentProperty ( Connection, 'Port', DataPort );
     if ( pos ( CST_LEON_DATA_MYSQL, DataDriver ) > 0 ) Then
       p_setComponentProperty ( Connection, 'Protocol', CST_LEON_DRIVER_MYSQL )
     else if ( pos ( CST_LEON_DATA_FIREBIRD, DataDriver ) > 0 ) Then
       p_setComponentProperty ( Connection, 'Protocol', CST_LEON_DRIVER_FIREBIRD )
     else if ( pos ( CST_LEON_DATA_SQLLITE, DataDriver ) > 0 ) Then
       p_setComponentProperty ( Connection, 'Protocol', CST_LEON_DRIVER_SQLLITE )
     else if ( pos ( CST_LEON_DATA_ORACLE, DataDriver ) > 0 ) Then
       p_setComponentProperty ( Connection, 'Protocol', CST_LEON_DRIVER_ORACLE )
     else if ( pos ( CST_LEON_DATA_POSTGRES, DataDriver ) > 0 ) Then
       p_setComponentProperty ( Connection, 'Protocol', CST_LEON_DRIVER_POSTGRES );
     try
       p_setComponentBoolProperty ( Connection, 'Connected', True );
     except
       on e: Exception do
         Raise EDatabaseError.Create ( 'Could not initiate connection on ' + DataDriver + ' and ' + DataURL +#13#10 + 'User : ' + DataUser +#13#10 + 'Base : ' + Database +#13#10 + e.Message   );
     end;

   end;
end;

/////////////////////////////////////////////////////////////////////////
// Procédure p_Loaddata
// Loading data link
// Charge le lien de données
// axno_Node : xml data document
/////////////////////////////////////////////////////////////////////////
procedure p_LoadData ( const axno_Node : TALXMLNode );
var li_i : LongInt ;
    li_Pos : LongInt ;
    lds_connection : TDSSource;
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
                         if Assigned(gmif_MainFormIniInit)
                           Then Begin
                                  DataPort     := gmif_MainFormIniInit.ReadInteger( INISEC_PAR, 'Port', 8080 );
                                  DataUser     := gmif_MainFormIniInit.ReadString ( INISEC_PAR, CST_LEON_DATA_USER, '' );
                                  DataPassword := gmif_MainFormIniInit.ReadString ( INISEC_PAR, CST_LEON_DATA_password, '' );
                                  DataURL      := gmif_MainFormIniInit.ReadString ( INISEC_PAR, CST_LEON_DATA_URL, '' );
                                  DataSecure   := gmif_MainFormIniInit.ReadBool   ( INISEC_PAR, 'Secure', False );
                                End;
                           else DataPort := 8080;
                         p_setComponentProperty ( Connection, 'Port', DataPort );
                         if DataUser <> '' Then
                           Begin
                            p_setComponentProperty ( Connection, 'Host', DataURL );
                            p_setComponentProperty ( Connection, 'Password', DataPassword );
                            p_setComponentProperty ( Connection, 'UserName', DataUser );
                            p_SetComponentBoolProperty( Connection, 'WithSSL', DataSecure );
                           End;
                         if QueryCopy = nil Then
                           Begin
                             lds_connection := DMModuleSources.Connections.add;
                             Connection := fobj_getComponentObjectProperty(Connection,CST_DBPROPERTY_ZEOSDB) as TComponent;
                             p_LoadConnection ( lNode , lds_connection );
                           End;
                       End;
              {$ENDIF}
              else
                p_LoadConnection ( lNode , lds_connection );
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

