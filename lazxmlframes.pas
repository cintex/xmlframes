{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit lazxmlframes; 

interface

uses
    u_xmlform, fonctions_xml, U_XMLFenetrePrincipale, fonctions_ObjetsXML, 
  fonctions_autocomponents, u_languagevars, u_multidonnees, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('lazxmlframes', @Register); 
end.
