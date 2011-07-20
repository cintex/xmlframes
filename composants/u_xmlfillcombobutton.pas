unit u_xmlfillcombobutton;

{$IFDEF FPC}
{$mode Delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, JvXPButtons, Graphics,
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
                                       BugsStory : '0.8.0.0 : Not Finished.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

{ TFWFillCombo }
type

  { TXMLFillCombo }

  TXMLFillCombo = class ( TFWFillCombo )
     protected
      procedure CreateForm(const aico_Icon: TIcon); override;
    End;

implementation

uses u_xmlform;

{ TFWFillCombo }

procedure TXMLFillCombo.CreateForm(const aico_Icon: TIcon);
begin

  FFormModal := fxf_ExecuteFonctionFile ( FormRegisteredName, False );

end;



{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_XMLFillCombo  );
{$ENDIF}
end.

