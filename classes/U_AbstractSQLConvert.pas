unit U_AbstractSQLConvert;

interface

///////////////////////////////////////////////////////////////////////
// Nom Unite: U_AbstractSQLConvert
// Description : Création d'une requête de création SQL automatisée
// Créé par Matthieu GIROUX le 15/03/2009
///////////////////////////////////////////////////////////////////////

uses
	Messages, Graphics, Controls, Classes, DB;

type
	TC_AbstractSQLFieldConvert = class

	private
		{ Déclarations privées }

    function CreateSQLField ( const Name : String; const FieldType : TFieldType ; const Size1, Size2 : Integer ; const IsAuto : Boolean; const DefaultValue : String ):boolean; virtual; abstract;

	public
		{ Déclarations publiques }
    // Valeur SQL par défaut
    function getDefault : String ; virtual; abstract;
    // Compteur Auto
    function getAutoInc : String ; virtual; abstract;
    // Valeur NULL
    function getNull : String ; virtual; abstract;
    // Taille du champ
    function getSize : String ; virtual; abstract;
    function getSize1 : String ; virtual; abstract;
    function getSize2 : String ; virtual; abstract;

	end;

implementation

end.
