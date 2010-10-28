unit U_ASQLBuilder;
{
---------------------------------------------------------------
Code generated by AF Component Wizard
AF Component Wizard 2002� AFComponents - Ferruccio Accalai
Idea by MAS-CompMaker, 2000-2002� Mats Asplund http://go.to/mdp
---------------------------------------------------------------

Component Name: TAdvancedSQLBuilder
        Author: Matthieu GIROUX
 Creation Date: 2009
       Version: 0.7
   Description: Simple SELECT, CREATE, ALTER SQL script builder from field-, table-, where info
        E-mail: matthieu.giroux@free.fr
       Website: - none -
  Legal Issues: All rigths reserved 2009� by Matthieu GIROUX


Usage:
  Generated format:
    SELECT
      Field1 [AS "Field1Alias"]
      [, Field2 [AS "Field2Alias"], .. Fieldn [AS "FieldnAlias"]]
    FROM
      Table1 [Table1Alias]
      [, Table2 [Table2Alias], .. Tablen [TablenAlias]]
    [WHERE
      [Join1]
      [AND Join2 .. AND Joinn]
      [AND [(]]
      [Where1 .. Wheren]
      [)] ]
    [GROUP BY
      GroupBy1 [, GroupBy2, .. GroupByn] ]
    [ORDER BY
      OrderBy1 [, OrderBy2, .. OrderByn] ]

Other infos:
  - Cannot add any item with empty name
  - Fields must be TABLENAME.FIELDNAME format (case insensitive, without spaces)
  - Aliases can contain special character, space, etc.
  - Field items have alias and aggregate informations
    (TAdvancedFieldDef and TAdvancedAggregate)
  - Table items have alias informations
    (TAdvancedTableDef)
  - OrderBy items have sortorder informations
    (TAdvancedOrderByDef and TAdvancedOrderBy)


  This software is provided 'as-is', without any express or
  implied warranty.  In no event will the author be held liable
  for any  damages arising from the use of this software.

  Permission is granted to anyone to use this software for any
  purpose, including commercial applications, and to alter it
  and redistribute it freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented,
     you must not claim that you wrote the original software.
     If you use this software in a product, an acknowledgment
     in the product documentation would be appreciated but is
     not required.

  2. Altered source versions must be plainly marked as such, and
     must not be misrepresented as being the original software.

  3. This notice may not be removed or altered from any source
     distribution.

  4. If you decide to use this software in any of your applications.
     Send me an EMail and tell me about it.


---------------------------------------------------------------
}

interface

uses
  SysUtils, Classes;

type
  TAdvancedAggregate = (sbsaNone, sbsaCount, sbsaSum, sbsaMax, sbsaMin, sbsaAvg);
  TAdvancedOrderBy   = (sbsoAsc, sbsoDesc);
  TAdvancedSQLRequest   = (sbrSelect, sbrCreate, sbrAlter );
  TAdvancedSQLBuilderError = (sbecOK, sbecNoFields, sbecNoTables);
  TAdvancedSQLBuilderLanguage = (sblaEnglish, sblaFrench, sblaHungarian);

  TAdvancedFieldDef = class
    Name      : string;
    Aggregate : TAdvancedAggregate;
    Alias     : string;
  end;
  TAdvancedTableDef = class
    Name  : string;
    Alias : string;
  end;
  TAdvancedOrderByDef = class
    Name      : string;
    OrderType : TAdvancedOrderBy;
  end;
  TOnError = procedure(Sender: TObject;
     ErrorCode: TAdvancedSQLBuilderError; ErrMessage: string) of object;

  TAdvancedSQLBuilder = class(TComponent)
  private
    { Private declarations }
    fOnError : TOnError;
    fAbout: String;
    fFieldList : TStringList;
    fTableList : TStringList;
    fJoinList  : TStringList;
    fWhereList : TStringList;
    fOrderBy   : TStringList;
    fResult    : TStringList;
    fGroupBy   : TStringList;
    fDistinct  : Boolean;
    fUseTableAlias    : Boolean;
    fUseFieldAlias    : Boolean;
    fUseGenFieldAlias : Boolean;
    fSQLRequest : TAdvancedSQLRequest;
    fLanguage         : TAdvancedSQLBuilderLanguage;
    procedure SetAbout(Value: string);
  protected
    { Protected declarations }
    function SchReplaceStr(const S, Srch, Replace: string): string;
    function ReplaceAlias(pFieldName: string):string;
    function GenerateFieldAlias(pFieldIndex: integer): string;
    procedure ErrorHandler(pErrCode : TAdvancedSQLBuilderError);
  public
    { Public declarations }
    property SQLResult: TStringList read fResult;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ResetLists;
    function AddField(FieldName: string; Aggregate: TAdvancedAggregate = sbsaNone;
                      Alias: string = ''): integer;
    function AddTable(TableName: string; TableAlias: string = ''): Integer;
    function AddJoin(Join: string): Integer;
    function AddWhere(Where: string): Integer;
    function AddOrderBy(OrderBy: string; OrderType: TAdvancedOrderBy = sbsoAsc): Integer;
    function BuildSQL: Boolean;
  published
    { Published declarations }
    property OnError: TOnError read fOnError write fOnError;
    property Distinct : Boolean read fDistinct write fDistinct default False;
    property UseTableAlias : Boolean read fUseTableAlias write fUseTableAlias default False;
    property UseFieldAlias : Boolean read fUseFieldAlias write fUseFieldAlias default False;
    property UseGenFieldAlias : Boolean read fUseGenFieldAlias write fUseGenFieldAlias default True;
    property Language : TAdvancedSQLBuilderLanguage read fLanguage write fLanguage default sblaEnglish;
    property Request : TAdvancedSQLRequest read fSQLRequest write fSQLRequest default sbrSelect;
    property About: String read fAbout write SetAbout;
  end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Data Access', [TAdvancedSQLBuilder]);
end;

function TAdvancedSQLBuilder.AddField(FieldName: string;
  Aggregate: TAdvancedAggregate; Alias: string): integer;
var
  ob: TAdvancedFieldDef;
begin
  Result:=-1;
  if Trim(FieldName)='' then exit;
  ob := TAdvancedFieldDef.Create;
  ob.Name := UpperCase(FieldName);
  ob.Aggregate := Aggregate;
  ob.Alias := Alias;
  Result:=fFieldList.AddObject(UpperCase(FieldName), TObject(ob));
end;

function TAdvancedSQLBuilder.AddTable(TableName: string; TableAlias: string): integer;
var
  ob: TAdvancedTableDef;
begin
  Result:=-1;
  if Trim(TableName)='' then exit;
  ob := TAdvancedTableDef.Create;
  ob.Name  := UpperCase(TableName);
  ob.Alias := TableAlias;
  Result:=fTableList.AddObject(UpperCase(TableName), TObject(ob));
end;

function TAdvancedSQLBuilder.AddJoin(Join: string): Integer;
begin
  Result:=-1;
  if Trim(Join)='' then exit;
  Result:=fJoinList.Add(UpperCase(Join));
end;

function TAdvancedSQLBuilder.AddWhere(Where: string): Integer;
begin
  Result:=-1;
  if Trim(Where)='' then exit;
  Result:=fWhereList.Add(UpperCase(Where));
end;

function TAdvancedSQLBuilder.AddOrderBy(OrderBy: string; OrderType: TAdvancedOrderBy): Integer;
var
  ob: TAdvancedOrderByDef;
begin
  Result:=-1;
  if Trim(OrderBy)='' then exit;
  ob := TAdvancedOrderByDef.Create;
  ob.Name  := UpperCase(OrderBy);
  ob.OrderType := OrderType;
  Result:=fOrderBy.AddObject(UpperCase(OrderBy), TObject(ob));
end;

constructor TAdvancedSQLBuilder.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	fAbout    := 'Version 0.7, 2009� Matthieu GIROUX';
  fFieldList:= TStringList.Create;
  fTableList:= TStringList.Create;
  fSQLRequest:=sbrSelect;
  fTableList.Duplicates:=dupIgnore;
  fJoinList := TStringList.Create;
  fWhereList:= TStringList.Create;
  fOrderBy  := TStringList.Create;
  fResult   := TStringList.Create;
  fGroupBy  := TStringList.Create;
  ResetLists;
end;

destructor TAdvancedSQLBuilder.Destroy;
begin
  fFieldList.Free;
  fTableList.Free;
  fJoinList.Free;
  fWhereList.Free;
  fOrderBy.Free;
  fResult.Free;
  fGroupBy.Free;
	inherited Destroy;
end;

procedure TAdvancedSQLBuilder.ResetLists;
begin
  fFieldList.Clear;
  fTableList.Clear;
  fJoinList.Clear;
  fWhereList.Clear;
  fOrderBy.Clear;
  fResult.Clear;
  fGroupBy.Clear;
end;

function TAdvancedSQLBuilder.BuildSQL: Boolean;
var
  sTableName: string;
  sFieldName: string;
  sAlias: string;
  sFirst: string;
  sTemp: string;
  iTemp: Integer;
begin
  Result:=False;
  fResult.Clear; fGroupBy.Clear;
  if fFieldList.Count=0 then
  begin
    ErrorHandler(sbecNoFields);
    exit;
  end;

  // Fill fTableList with fFieldLists tablenames if not exists
  for iTemp:=0 to fFieldList.Count-1 do
  begin
    sFieldName:=TAdvancedFieldDef(fFieldList.Objects[iTemp]).Name;
    sTableName:=UpperCase(Copy(sFieldName,1,Pos('.',sFieldName)-1));
    if fTableList.IndexOf(sTableName)=-1
      then AddTable(sTableName);
  end;

  if fTableList.Count=0 then
  begin
    ErrorHandler(sbecNoTables);
    exit;
  end;

  if fDistinct
    then fResult.Add('SELECT DISTINCT')
    else fResult.Add('SELECT');


  // Fields
  for iTemp:=0 to fFieldList.Count-1 do
  begin
    sFieldName:=TAdvancedFieldDef(fFieldList.Objects[iTemp]).Name;
    if TAdvancedFieldDef(fFieldList.Objects[iTemp]).Aggregate = sbsaNone
      then fGroupBy.Add(TAdvancedFieldDef(fFieldList.Objects[iTemp]).Name);
    case TAdvancedFieldDef(fFieldList.Objects[iTemp]).Aggregate of
      sbsaNone  : sFirst:='';
      sbsaCount : sFirst:='COUNT(';
      sbsaSum   : sFirst:='SUM(';
      sbsaMax   : sFirst:='MAX(';
      sbsaMin   : sFirst:='MIN(';
      sbsaAvg   : sFirst:='AVG(';
    end;
    sTemp:=sFieldName;

    if fUseTableAlias then sTemp:=ReplaceAlias(sTemp);
    sTemp:=sFirst+sTemp;

    if sFirst<>'' then sTemp:=sTemp+')';
    if fUseFieldAlias or fUseGenFieldAlias
      then sTemp:=sTemp+GenerateFieldAlias(iTemp);

    if iTemp<(fFieldList.Count-1) then sTemp:=sTemp+',';
    fResult.Add('  '+sTemp);
  end;
  if fFieldList.Count=fGroupBy.Count then fGroupBy.Clear;


  // Tables
  fResult.Add('FROM');
  for iTemp:=0 to fTableList.Count-1 do
  begin
    sTemp:=TAdvancedTableDef(fTableList.Objects[iTemp]).Name;
    sAlias:=TAdvancedTableDef(fTableList.Objects[iTemp]).Alias;
    if fUseTableAlias and (Trim(sAlias)<>'')
      then sTemp:=sTemp+' '+sAlias;
    if iTemp<(fTableList.Count-1) then sTemp:=sTemp+',';
    fResult.Add('  '+sTemp);
  end;

  if fJoinList.Count+fWhereList.Count>0 then fResult.Add('WHERE');


  // Join (All lines without 'AND')
  if fJoinList.Count>0 then
  begin
    for iTemp:=0 to fJoinList.Count-1 do
    begin
      sTemp:=fJoinList[iTemp];
      if fUseTableAlias then sTemp:=ReplaceAlias(sTemp);
      if iTemp=0
        then fResult.Add('  '+sTemp)
        else fResult.Add('  AND '+sTemp);
    end;
  end;

  if (fJoinList.Count>0) and (fWhereList.Count>0) then fResult.Add('  AND (');


  // Where (All lines with their 'OR' or 'AND' or parenthesis)
  if fWhereList.Count>0 then
  begin
    for iTemp:=0 to fWhereList.Count-1 do
    begin
      sTemp:=fWhereList[iTemp];
      if fUseTableAlias then sTemp:=ReplaceAlias(sTemp);
      fResult.Add('  '+sTemp);
    end;
  end;
  if (fJoinList.Count>0) and (fWhereList.Count>0) then fResult.Add('  )');


  // GroupBy
  if fGroupBy.Count>0 then
  begin
    fResult.Add('GROUP BY');
    for iTemp:=0 to fGroupBy.Count-1 do
    begin
      sTemp:=fGroupBy[iTemp];
      if fUseTableAlias then sTemp:=ReplaceAlias(sTemp);
      if iTemp<(fGroupBy.Count-1) then sTemp:=sTemp+',';
      fResult.Add('  '+sTemp);
    end;
  end;


  // OrderBy
  if fOrderBy.Count>0 then
  begin
    fResult.Add('ORDER BY');
    for iTemp:=0 to fOrderBy.Count-1 do
    begin
      sTemp:=TAdvancedOrderByDef(fOrderBy.Objects[iTemp]).Name;
      if fUseTableAlias then sTemp:=ReplaceAlias(sTemp);
      if TAdvancedOrderByDef(fOrderBy.Objects[iTemp]).OrderType = sbsoDesc
        then sTemp:=sTemp+' DESC';
      if iTemp<(fOrderBy.Count-1) then sTemp:=sTemp+',';
      fResult.Add('  '+sTemp);
    end;
  end;

  Result:=True;
  ErrorHandler(sbecOK);
end;

function TAdvancedSQLBuilder.SchReplaceStr(const S, Srch,
  Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then
    begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else
      Result := Result + Source;
  until I <= 0;
end;

function TAdvancedSQLBuilder.ReplaceAlias(pFieldName: string): string;
var
  pAlias, pTableName : string;
  iTempTbl: Integer;
  pTemp : string;
begin
  pTemp:=pFieldName;
  for iTempTbl:= 0 to fTableList.Count-1 do
  begin
    pAlias:=TAdvancedTableDef(fTableList.Objects[iTempTbl]).Alias;
    if Trim(pAlias)<>'' then
    begin
      pTableName:=TAdvancedTableDef(fTableList.Objects[iTempTbl]).Name;
      pTemp:=SchReplaceStr(pTemp,pTableName+'.',pAlias+'.');
    end;
  end;
  Result:=pTemp;
end;

function TAdvancedSQLBuilder.GenerateFieldAlias(pFieldIndex: integer): string;
var
  cFirstChar: Char;
  iTemp: Integer;
  sNewAlias: string;
  sFieldAlias: string;
  bIsAggregate: Boolean;
begin
//  ***********************************************************
//  *                   *   Aggr. exists   * Aggr. not exists *
//  ***********************************************************
//  * Alias exists      *  1: Quote marks  *  2: Quote marks  *
//  ***********************************************************
//  * Alias not exists  *  3: Generating   *    4: Empty      *
//  ***********************************************************

  sFieldAlias:=TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Alias;
  bIsAggregate:=(TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Aggregate <> sbsaNone);

  // 4: Empty
  Result:='';
  if (not(bIsAggregate)) and (sFieldAlias='') then exit;

  // 1: Quote marks (aggr)
  if (sFieldAlias<>'') and bIsAggregate and (fUseGenFieldAlias or fUseFieldAlias) then
  begin
    sNewAlias:=sFieldAlias; // Assign original
    if sFieldAlias[1]<>'"' then sNewAlias:='"'+sNewAlias;
    if sFieldAlias[Length(sFieldAlias)]<>'"' then sNewAlias:=sNewAlias+'"';
    Result:=' AS '+sNewAlias;
    exit;
  end;

  // 2: Quote marks (not aggr)
  if (sFieldAlias<>'') and not(bIsAggregate) and fUseFieldAlias then
  begin
    sNewAlias:=sFieldAlias; // Assign original
    if sFieldAlias[1]<>'"' then sNewAlias:='"'+sNewAlias;
    if sFieldAlias[Length(sFieldAlias)]<>'"' then sNewAlias:=sNewAlias+'"';
    Result:=' AS '+sNewAlias;
    exit;
  end;

  Result:='';

  if not(fUseGenFieldAlias) or not(bIsAggregate) then exit;

  // 3: Generating
  sNewAlias:=TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Name;
  // Tablename remover
  for iTemp := 0 to fTableList.Count-1
    do sNewAlias:=SchReplaceStr(sNewAlias,
                  TAdvancedTableDef(fTableList.Objects[iTemp]).Name+'.','');
  // First capital
  cFirstChar:=sNewAlias[1];
  sNewAlias:=LowerCase(sNewAlias);
  sNewAlias[1]:=cFirstChar;
  case fLanguage of
    sblaEnglish: case TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Aggregate of
      sbsaCount  : sNewAlias:='Count of '+sNewAlias;
      sbsaSum    : sNewAlias:='Sum of '+sNewAlias;
      sbsaMax    : sNewAlias:='Max of '+sNewAlias;
      sbsaMin    : sNewAlias:='Min of '+sNewAlias;
      sbsaAvg    : sNewAlias:='Average of '+sNewAlias;
    end;
    sblaFrench: case TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Aggregate of
      sbsaCount  : sNewAlias:='Total de '+sNewAlias;
      sbsaSum    : sNewAlias:='Somme de '+sNewAlias;
      sbsaMax    : sNewAlias:='Max de '+sNewAlias;
      sbsaMin    : sNewAlias:='Min de '+sNewAlias;
      sbsaAvg    : sNewAlias:='Moy de '+sNewAlias;
    end;
    sblaHungarian: case TAdvancedFieldDef(fFieldList.Objects[pFieldIndex]).Aggregate of
      sbsaCount  : sNewAlias:=sNewAlias+' (db)';
      sbsaSum    : sNewAlias:='�sszes '+sNewAlias;
      sbsaMax    : sNewAlias:=sNewAlias+' maximuma';
      sbsaMin    : sNewAlias:=sNewAlias+' minimuma';
      sbsaAvg    : sNewAlias:=sNewAlias+' �tlaga';
    end;
  end;
  sNewAlias:=' AS "'+sNewAlias+'"';
  Result:=sNewAlias;
end;

procedure TAdvancedSQLBuilder.SetAbout(Value: string);
begin
  exit;
end;

procedure TAdvancedSQLBuilder.ErrorHandler(pErrCode: TAdvancedSQLBuilderError);
var
  sErrorMessage: string;
begin
  case fLanguage of
    sblaEnglish: case pErrCode of
      sbecOK        : sErrorMessage:='Done!';
      sbecNoFields  : sErrorMessage:='FieldList is empty!';
      sbecNoTables  : sErrorMessage:='TableList is empty!';
    end;
    sblaFrench: case pErrCode of
      sbecOK        : sErrorMessage:='Fait!';
      sbecNoFields  : sErrorMessage:='Pas de champs!';
      sbecNoTables  : sErrorMessage:='Pas de table!';
    end;
    sblaHungarian: case pErrCode of
      sbecOK        : sErrorMessage:='K�sz!';
      sbecNoFields  : sErrorMessage:='A mez�lista �res!';
      sbecNoTables  : sErrorMessage:='A t�blalista �res!';
    end;
  end;
  if Assigned(FOnError) then FOnError(Self, pErrCode, sErrorMessage);
end;

end.
