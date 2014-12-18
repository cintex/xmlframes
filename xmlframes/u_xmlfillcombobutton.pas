unit u_xmlfillcombobutton;

{$IFDEF FPC}
{$mode Delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, ExtJvXPButtons, Graphics,
  {$IFDEF VERSIONS}
     fonctions_version,
  {$ENDIF}
  u_fillcombobutton, Forms;

{$IFDEF VERSIONS}
const
    gVer_XMLFillCombo : T_Version = ( Component : 'Bouton personnalisé de remplissage de combo box avec lien XML' ;
                                       FileUnit : 'u_xmlfillcombobutton' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Composant bouton de remplissage de lien 1-N avec lien XML.' ;
                                       BugsStory : '1.0.0.1 : CreateForm can inherit.' + #13#10
                                                 + '1.0.0.0 : Working on DELPHI.' + #13#10
                                                 + '0.8.0.0 : Not Finished.';
                                       UnitType : 3 ;
                                       Major : 1 ; Minor : 0 ; Release : 0 ; Build : 1 );
{$ENDIF}

type

  { TXMLFillCombo }

  TXMLFillCombo = class ( TExtFillCombo )
     protected
      procedure CreateForm(const aico_Icon: TIcon); override;
    End;

implementation

uses fonctions_xmlform;

{ TExtFillCombo }

// procedure TXMLFillCombo.CreateForm
// Creating the registered xml form
// aico_Icon : parameter not used because not needed

procedure TXMLFillCombo.CreateForm(const aico_Icon: TIcon);
begin

  FFormModal := fxf_ExecuteFonctionFile ( FormRegisteredName, False );
  if not assigned ( FFormModal ) Then
    inherited CreateForm ( aico_Icon );
end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_XMLFillCombo  );
{$ENDIF}
end.

