{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  '
  +'Cette source est seulement employée pour compiler et installer le '
  +'paquet.
 }

unit lazXMLFrameWork;

interface

uses
U_AbstractSQLConvert, u_formxml, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('lazXMLFrameWork', @Register); 
end.
