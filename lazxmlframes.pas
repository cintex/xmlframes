{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazxmlframes; 

interface

uses
    u_xmlform, fonctions_xml, U_XMLFenetrePrincipale, fonctions_ObjetsXML, 
  fonctions_autocomponents, u_languagevars, u_multidonnees, 
  fonctions_leon_format, u_xmlfillcombobutton, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('lazxmlframes', @Register); 
end.
