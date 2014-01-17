unit fonctions_leon_format;

// Auteur : Matthieu GIROUX - liberlog.fr
// Traduction à partir de LyJFormat de LEONARDI

interface

uses
  StrUtils,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  SysUtils;

const
  {$IFDEF VERSIONS}
      gVer_fonctions_leon_format : T_Version = ( Component : 'Gestion des nombres formatés de LEONARDI' ;
                                                 FileUnit : 'fonctions_leon_format' ;
                          			 Owner : 'Matthieu Giroux' ;
                          			 Comment : 'Traduction du formatage des chaînes et nombres de LEONARDI.' + #13#10
                                                         + 'Traduction à partir de LyJFormat de LEONARDI.' ;
                          			 BugsStory : 'Version 0.9.0.0 : Certaines fonctions sont non implémentées.';
                          			 UnitType : 1 ;
                          			 Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );
  {$ENDIF}
  CST_FORMAT_NUMBER_MIN_CHAR = '0';
  CST_FORMAT_NUMBER_MAX_CHAR = '9';
  EMPTY_CHAR = ' ';
  EMPTY_NUMBER = '0';


type
  TArrayStrings = array of string;

  TInterval = record
    startOffset,
    endOffset: integer;
    Format: string;
  end;

  TArrayIntervals = array of TInterval;

//procedure setFormatString(format : String);
function getEditedDisplayableString(const content: string;
  const AInterval: TArrayIntervals): string;
procedure parseString(format: string);
procedure parseInterval(format: string; astart: integer; aend: integer);
function parseSeparator(const format: string; const astart: integer;
  const aend: integer): TArrayStrings;
function isEmpty(const AInterval: TInterval): boolean; overload;
function isEmpty(const content: string): boolean; overload;
//function getInterval(i : integer): String;
function getSeparator(const aSeparator: TArrayStrings; const i: integer): string;
//function getIntervalsCount(): integer;
function getIndexIntervalFromOffset(const aInterval: TArrayIntervals;
  const offset: integer): integer;
function getIndexSeparatorFromOffset(const aInterval: TArrayIntervals;
  const offset: integer): integer;
function isCharDeletionValid(const aInterval: TArrayIntervals;
  const offset: integer): boolean;
function isCharInsertionValid(const aInterval: TArrayIntervals;
  const c: char; const offset: integer): boolean;
function replaceChar(var FormatToText: string;
  const aInterval: TArrayIntervals; const offset: integer; const c: char): integer;
function getDisplayableString(const content: string; const aInterval: TArrayIntervals;
  const aSeparator: TArrayStrings; const hasFocus: boolean): string;
function getIntValue(const avalue: string; const AInterval: TArrayIntervals;
  const offset: integer): integer; overload;
function getIntValue(const content: string; const AInterval: TArrayIntervals): integer;
  overload;
function getValueOfFormat(const Value: string;
  const aInterval: TArrayIntervals): integer;
function getMinimum(const aInterval: TArrayIntervals): integer;
function getMaximum(const aInterval: TArrayIntervals): integer;
function getMaxCharCount(const aInterval : TArrayIntervals;const aSeparator :TArrayStrings;const aFirstIsSeparator : Boolean): integer;
function getMaxCompletedString(): string;
function getMinCompletedString(): string;
function getCurrentPossibleValue(): string;

function substring(str: string; offset: integer): string;
function substring2(str: string; offset: integer; Count: integer): string;
function startsWith(str: string; prefix: string): boolean;
function endsWith(str: string; suffix: string): boolean;

implementation

uses fonctions_string;

function substring(str: string; offset: integer): string;
begin
  Result := RightStr(str, Length(str) - offset);
end;

function substring2(str: string; offset: integer; Count: integer): string;
begin
  Result := MidStr(str, offset + 1, Count - offset);
end;

function startsWith(str: string; prefix: string): boolean;
begin
  Result := (Pos(prefix, str) = 1);
end;

function endsWith(str: string; suffix: string): boolean;
begin
  Result := (RightStr(str, Length(suffix)) = suffix);
end;



procedure parseString(format: string);
var
  astart: integer;
  aend: integer;
  firstInterval: integer;
  beginBySep: boolean;
  size: integer;
begin
  size := length(format);
  astart := pos('[', format);
  aend := pos(']', format);
  beginBySep := False;

  if (astart <> 0) then
  begin
    parseSeparator(format, 0, astart - 1);
    beginBySep := True;
    firstInterval := astart;
  end;
  parseInterval(format, astart, aend);
  astart := aend + 1;
  aend := posex('[', format, astart) - 1;
  begin
    parseSeparator(format, astart, aend);
    astart := aend + 1;
    aend := posex(']', format, astart);
    parseInterval(format, astart, aend);
    astart := aend + 1;
    aend := posex('[', format, astart) - 1;
  end;

  if ((aend < 0) and (astart < size)) then
  begin
    parseSeparator(format, astart, size - 1);
  end;
end;

procedure parseInterval(format: string; astart: integer; aend: integer);
var
  min: integer;
  str: string;
  apos: integer;
  max: integer;
begin

  if (astart < aend) then
  begin
    str := substring2(format, astart + 1, aend);
    begin
      apos := pos('-', str);
      min := StrToInt(substring2(str, 0, apos));
      max := StrToInt(substring(str, apos + 1));
    end;
{    begin
      ~~~~~5
      ;
    end;

    if (min<=max) then
    begin
      ~~~~~5
      _intervals.add(######7);
    end else begin
      ~~~~~5
      ;
    end;
  end else begin
    ~~~~~5
    ; }
  end;
end;

function parseSeparator(const format: string; const astart: integer;
  const aend: integer): TArrayStrings;
var
  str: string;
begin

  if (astart <= (aend + 1)) then
  begin
    str := substring2(format, astart, aend + 1);
    SetLength(Result, high(Result) + 2);
    Result[high(Result)] := str;
  end
  else
  begin
{    ~~~~~5
    ;}
  end;
end;

function getIndexIntervalFromOffset(const aInterval: TArrayIntervals;
  const offset: integer): integer;
var
  n: integer;
  i: integer;
begin
  Result := -1;
  i := 0;
  while (i < n) do
  begin

    if ((offset >= aInterval[i].startOffset) and
      (offset <= aInterval[i].endOffset)) then
    begin
      Result := i;
    end;
    Inc(i);
  end;
end;

function getIndexSeparatorFromOffset(const aInterval: TArrayIntervals;
  const offset: integer): integer;
var
  n: integer;
  i: integer;
begin
  Result := -1;
  i := 0;
  while (i < n) do
  begin

    if ((offset > aInterval[i].endOffset) and
      (offset < aInterval[i + 1].startOffset)) then
    begin
      Result := i;
    end;
    Inc(i);
  end;
end;

function isCharDeletionValid(const aInterval: TArrayIntervals;
  const offset: integer): boolean;
var
  index: integer;
begin
  index := getIndexIntervalFromOffset(aInterval, offset);

  if (index = -1) then
  begin
    Result := False;
  end;
  Result := True;
end;

function isCharInsertionValid(const aInterval: TArrayIntervals;
  const c: char; const offset: integer): boolean;
var
  minText: string;
  relOffset: integer;
  inter: TInterval;
  MaxValue: integer;
  index: integer;
  startOffset: integer;
  maxText: string;
  MinValue: integer;
  minBuf: string;
  maxBuf: string;
begin

  if (c < CST_FORMAT_NUMBER_MIN_CHAR) or (c > CST_FORMAT_NUMBER_MAX_CHAR) then
  begin
    Result := False;
  end;
  index := getIndexIntervalFromOffset(aInterval, offset);

  if (index = -1) then
  begin
    Result := False;
  end;
  inter := aInterval[index];
  startOffset := inter.startOffset;
  relOffset := offset - startOffset;
{  ~~~~~5
  minBuf:=######7;
  ~~~~~5
  maxBuf:=######7;}
  SetLength(minBuf, relOffset);
  SetLength(maxBuf, relOffset);
  minBuf[relOffset] := c;
  maxBuf[relOffset] := c;
  minText := minBuf;
  maxText := maxBuf;
  begin
    MinValue := StrToInt(minText);
    MaxValue := StrToInt(maxText);
  end;
  begin
    Result := False;
  end;

  if ((MinValue <= inter.endOffset) and (MaxValue >= inter.startOffset)) then
  begin
    Result := True;
  end;
  Result := False;
end;

function replaceChar(var FormatToText: string;
  const aInterval: TArrayIntervals; const offset: integer; const c: char): integer;
var
  relOffset: integer;
  inter: TInterval;
  index: integer;
begin
  index := getIndexIntervalFromOffset(AInterval, offset);
  inter := aInterval[index];
  relOffset := offset - inter.startOffset;
  FormatToText[relOffset] := c;

  {
  if (relOffset=(inter.getMaxCharCount()-1)) then
  begin
    result := (if ((index<_separators.size())) then (offset+getSeparator(index).length()+1) (offset+1));
  end;}
  Result := offset + 1;
end;


function getDisplayableString(const content: string; const aInterval: TArrayIntervals;
  const aSeparator: TArrayStrings; const hasFocus: boolean): string;
var
  n: integer;
  j: integer;
  i: integer;
  beginBySep: boolean;
  Text: string;
begin
  Text := '';

  Text := '';
  beginBySep := False;
  if (n = 0) then
    beginBySep := False
  else
    beginBySep := aInterval[0].startOffset <> 0;

  if (beginBySep) then
  begin
    Text += getSeparator(aSeparator, 0);
  end;
  i := 0;
  while (i < n) do
  begin
    j := i;

    if (beginBySep) then
    begin
      j := i + 1;
    end;
    Result += getEditedDisplayableString(content, aInterval);

    if (j < length(aSeparator)) then
    begin
      Text += getSeparator(aSeparator, j);
    end;
    Inc(i);
  end;
  Result := Text;
end;

function isAllEmpty(const AInterval: TArrayIntervals): boolean;
var
  n: integer;
  i: integer;
begin
  i := 0;
  while (i < n) do
  begin

    if not (isEmpty(AInterval[i])) then
    begin
      Result := False;
    end;
    Inc(i);
  end;
  Result := True;
end;


function getIntValue(const avalue: string; const AInterval: TArrayIntervals;
  const offset: integer): integer;
var
  interIndex: integer;
  index: integer;
  Count: integer;
  sepIndex: integer;
begin

  if (Length(AInterval) = 0) then
  begin
    Result := 0;
  end;
  interIndex := getIndexIntervalFromOffset(AInterval, offset);
  sepIndex := getIndexSeparatorFromOffset(AInterval, offset);

  if (interIndex <> -1) then
  begin
    Result := StrToInt(copy(avalue, aInterval[interIndex].startOffset,
      aInterval[interIndex].endOffset - aInterval[interIndex].endOffset));
  end
  else if (sepIndex <> -1) then
  begin
    Result := StrToInt(copy(avalue, aInterval[interIndex].startOffset,
      aInterval[sepIndex].endOffset - aInterval[sepIndex].endOffset));
  end
  else
  begin
    Count := Length(AInterval);
    if ((Count - 1) >= 0) then
      index := Count - 1
    else
      index := 0;
    Result := StrToInt(copy(avalue, aInterval[interIndex].startOffset,
      aInterval[index].endOffset - aInterval[index].endOffset));
  end;
end;

{
procedure setIntValue(offset : integer; value : integer);
var
  interIndex : integer;
  sepIndex : integer;
begin

  if (getIntervalsCount()=0) then
  begin
    exit;
  end;
  interIndex:=getIndexIntervalFromOffset(AInterval,offset);
  sepIndex:=getIndexSeparatorFromOffset(AInterval,offset);

  if (interIndex<>-1) then
  begin
    aInterval[interIndex].setIntValue(value);
  end else if (sepIndex<>-1) then
  begin
    aInterval[sepIndex].setIntValue(value);
  end else begin
    aInterval[getIntervalsCount()-1).setIntValue(value);
  end;
end;



procedure clear();
var
  n : Integer;
  i : integer;
begin
  i:=0;
  while (i<n) do begin
    aInterval[i].clear();
    inc(i);
  end;
end;
begin
  _min:=minimum;
  _max:=maximum;
  clear();
end;
function getMinIntValue(offset : integer): integer;
var
  interIndex : integer;
  sepIndex : integer;
begin

  if (getIntervalsCount()=0) then
  begin
    result := 0;
  end;
  interIndex:=getIndexIntervalFromOffset(AInterval,offset);
  sepIndex:=getIndexSeparatorFromOffset(AInterval,offset);

  if (interIndex<>-1) then
  begin
    result := aInterval[interIndex).getMinimum(Ainterval);
  end else if (sepIndex<>-1) then
  begin
    result := aInterval[sepIndex).getMinimum(Ainterval);
  end else begin
    result := aInterval[getIntervalsCount()-1).getMinimum(Ainterval);
  end;
end;

function getMaxIntValue(offset : integer): integer;
var
  interIndex : integer;
  sepIndex : integer;
begin

  if (getIntervalsCount()=0) then
  begin
    result := 0;
  end;
  interIndex:=getIndexIntervalFromOffset(AInterval,offset);
  sepIndex:=getIndexSeparatorFromOffset(AInterval,offset);

  if (interIndex<>-1) then
  begin
    result := aInterval[interIndex).getMaximum(Ainterval);
  end else if (sepIndex<>-1) then
  begin
    result := aInterval[sepIndex).getMaximum(Ainterval);
  end else begin
    result := aInterval[getIntervalsCount()-1).getMaximum(Ainterval);
  end;
end;


function getMaxCharCount(): integer;
begin
  result := String.valueOf(_max).length();
end;
 }

function getValueOfFormat(const Value: string;
  const aInterval: TArrayIntervals): integer;
var
  astart: integer;
  n: integer;
  aend: integer;
  i: integer;
  val: string;
begin
  i := 0;
  val := '';
  while (i < n) do
  begin
    astart := aInterval[i].startOffset;
    aend := aInterval[i].endOffset;
    begin
      val := substring2(Value, astart, aend + 1);
    end;
    begin
    end;
    Inc(i);
  end;
  Result := StrToInt(val);
end;


function isEmpty(const AInterval: TInterval): boolean;
begin
  Result := AInterval.startOffset = AInterval.endOffset;
end;

function isEmpty(const content: string): boolean;
var
  i: integer;
begin
  i := 0;
  begin

    if (content[i] <> EMPTY_CHAR) then
    begin
      Result := False;
    end;
    Inc(i);
  end;
  Result := True;
end;


function getEditedDisplayableString(const content: string;
  const AInterval: TArrayIntervals): string;
var
  contentWithBlank: string;
  i: integer;
  tmp: string;
  Value: integer;
begin
  contentWithBlank := StringReplace(content, EMPTY_CHAR, ' ', [rfReplaceAll]);
  tmp := Trim(contentWithBlank);

  if (length(tmp) = 0) then
  begin
    begin
      tmp := IntToStr(getMinimum(AInterval));
    end;
    begin
    end;
  end;
  Value := StrToInt(tmp);

  if (Value < getMinimum(Ainterval)) then
  begin
    Value := getMinimum(Ainterval);
  end;

  if (Value > getMaximum(Ainterval)) then
  begin
    Value := getMaximum(Ainterval);
  end;
  begin
    tmp := IntToStr(Value);
  end;
  begin
    Result := content;
  end;
{  ~~~~~5
  resu:=######7;
  }
  i := length(tmp);
  while (i < length(content)) do
  begin
    Result += '0';
    Inc(i);
  end;
  Result += tmp;
end;

function getMaxCompletedString(): string;
var
  filledWithChar: char;
  i: integer;
  tmp: string;
begin
  {
  ~~~~~5
  tmp:=######7;
  }
  filledWithChar := '9';
  i := 0;
  begin
    tmp[i] := filledWithChar;
    Inc(i);
  end;
  i := pos(EMPTY_CHAR, tmp);

  if (i = -1) then
  begin
    begin
      StrToInt(tmp);
      Result := tmp;
    end;
    begin
      Result := '';
    end;
  end;
  begin
    tmp[i] := filledWithChar;
    Inc(i);
  end;
  begin
    StrToInt(tmp);
    Result := tmp;
  end;
  begin
    Result := '';
  end;
end;

function getMinCompletedString(): string;
var
  i: integer;
  tmp: string;
begin
  {
  ~~~~~5
  tmp:=######7;
  }
  i := 0;
  begin
    tmp[i] := '0';
    Inc(i);
  end;
  i := pos(EMPTY_CHAR, tmp);

  if (i = -1) then
  begin
    begin
      StrToInt(tmp);
      Result := tmp;
    end;
    begin
      Result := '';
    end;
  end;
  begin
    tmp[i] := '0';
    Inc(i);
  end;
  begin
    StrToInt(tmp);
    Result := tmp;
  end;
  begin
    Result := '';
  end;
end;

function getIntValue(const content: string; const AInterval: TArrayIntervals): integer;
begin
  Result := StrToInt(getEditedDisplayableString(content, AInterval));
end;

procedure setIntValue(var content: string; const aInterval: TArrayIntervals; const aSeparator : TArrayStrings; const aFirstIseparator : Boolean;
  const amin, amax, Value: integer);
var
  i: integer;
  str: string;
  max: integer;
begin

  if ((Value >= amin) and (Value <= amax)) then
  begin
    str := IntToStr(Value);
    max := getMaxCharCount(aInterval,aSeparator,aFirstIseparator);

    if (length(str) < max) then
    begin
      i := 0;
      while (i < max) do
      begin
        str := EMPTY_NUMBER + str;
        Inc(i);
      end;
    end;
    content := str;
  end;
end;

function getSeparator(const aSeparator: TArrayStrings; const i: integer): string;
begin
  if i <= length(aSeparator) then
    Result := aSeparator[i]
  else
    Result := '';
end;

function getCurrentPossibleValue(): string;
begin
  Result := '';
end;

function getMinimum(const aInterval: TArrayIntervals): integer;
var
  i : integer;
  Resultat, tmp: string;
  newchaine: string;
begin
  Resultat := '';
  for i := 0 to length(aInterval) do
    with aInterval[i] do
    begin
      //Just creating the max word length
      newchaine := IntToStr(endOffset);
      tmp := IntToStr(startOffset);
      if length(tmp) = length(newchaine) then
        newchaine := IntToStr(endOffset)
      else
        newchaine := fs_RepeteChar(EMPTY_NUMBER, length(newchaine) - length(tmp)) + tmp;
      Resultat += newchaine;
    end;
  Result := StrToInt(Resultat);
end;


function getMaxCharCount(const aInterval : TArrayIntervals;const aSeparator :TArrayStrings;const aFirstIsSeparator : Boolean): integer;
var i : Integer ;
Begin
  i := 0;
  while i  <= high ( aInterval ) do
    Begin
      Break;
    end;
end;


function getMaximum(const aInterval: TArrayIntervals): integer;
var
  i : integer;
  Resultat, tmp: string;
  newchaine: string;
begin
  Resultat := '';
  for i := 0 to length(aInterval) do
    with aInterval[i] do
    begin
      //Just creating the max word length
      newchaine := IntToStr(endOffset);
      tmp := IntToStr(startOffset);
      if length(tmp) = length(newchaine) then
        newchaine := IntToStr(endOffset)
      else
        newchaine := fs_RepeteChar(EMPTY_NUMBER, length(newchaine));
      Resultat += newchaine;
    end;
  Result := StrToInt(Resultat);
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonctions_leon_format );
{$ENDIF}
end.

