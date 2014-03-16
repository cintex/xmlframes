unit Interval;

interface

uses
  StrUtils, SysUtils, StringTokenizer;

type
  TInterval=class
  private
    _separators : Vector;
    _intervals : Vector;
    _content : String;
    _startOffset : integer;
    _min : integer;
    _endOffset : integer;
    EMPTY_CHAR : char;
    _max : integer;
    __VERSION : String;
    procedure setFormatString(format : String);
    procedure parseString(format : String);
    procedure parseInterval(format : String; start : integer; end : integer);
    procedure parseSeparator(format : String; start : integer; end : integer);
    function getInterval(i : integer): Interval;
    function getSeparator(i : integer): String;
    function getIntervalsCount(): int;
    function getIndexIntervalFromOffset(offset : integer): int;
    function getIndexSeparatorFromOffset(offset : integer): int;
    function isCharDeletionValid(offset : integer): boolean;
    function isCharInsertionValid(c : char; offset : integer): boolean;
    function replaceChar(offset : integer; c : char): int;
    function getDisplayableString(hasFocus : boolean): String;
    function isAllEmpty(): boolean;
    function getIntValue(offset : integer): int;
    procedure setIntValue(offset : integer; value : integer);
    function getMinIntValue(offset : integer): int;
    function getMaxIntValue(offset : integer): int;
    procedure setValue(value : String);
    procedure clear();
    function getMinimum(): int;
    function getMaximum(): int;
    function getMaxCharCount(): int;
    procedure setOffset(offset : integer);
    function getStartOffset(): int;
    function getEndOffset(): int;
    procedure replaceChar(offset : integer; c : char);
    function isEmpty(): boolean;
    function getContent(): String;
    function getEditingDisplayableString(): String;
    function getEditedDisplayableString(): String;
    function getMaxCompletedString(): String;
    function getMinCompletedString(): String;
    function getIntValue(): int;
    procedure setIntValue(value : integer);
    function getCurrentPossibleValue(): String;
    procedure clear();
  public;
    constructor Create;
    destructor Destroy; override;
  end;

function substring(str : String; offset : integer): String;
function substring2(str : String; offset : integer; count : integer): String;
function startsWith(str : String; prefix : String): boolean; 
function endsWith(str : String; suffix : String): boolean; 

implementation

function substring(str : String; offset : integer): String;
begin
  result := RightStr(str, Length(str) - offset);
end;

function substring2(str : String; offset : integer; count : integer): String;
begin
  result := MidStr(str, offset+1, count - offset);
end;

function startsWith(str : String; prefix : String): boolean;
begin
  result := (Pos(prefix, str) = 1);
end;

function endsWith(str : String; suffix : String): boolean;
begin
  result := (RightStr(str, Length(suffix)) = suffix);
end;

{ TInterval }

constructor TInterval.Create();
begin
  inherited Create;
end;

destructor TInterval.Destroy();
begin
  inherited Destroy;
end;
unit Interval;

interface

uses
  StrUtils, SysUtils, StringTokenizer;

type
  TInterval=class
  private
    _separators : Vector;
    _intervals : Vector;
    _content : String;
    _startOffset : integer;
    _min : integer;
    _endOffset : integer;
    EMPTY_CHAR : char;
    _max : integer;
    __VERSION : String;
    procedure setFormatString(format : String);
    procedure parseString(format : String);
    procedure parseInterval(format : String; start : integer; end : integer);
    procedure parseSeparator(format : String; start : integer; end : integer);
    function getInterval(i : integer): Interval;
    function getSeparator(i : integer): String;
    function getIntervalsCount(): int;
    function getIndexIntervalFromOffset(offset : integer): int;
    function getIndexSeparatorFromOffset(offset : integer): int;
    function isCharDeletionValid(offset : integer): boolean;
    function isCharInsertionValid(c : char; offset : integer): boolean;
    function replaceChar(offset : integer; c : char): int;
    function getDisplayableString(hasFocus : boolean): String;
    function isAllEmpty(): boolean;
    function getIntValue(offset : integer): int;
    procedure setIntValue(offset : integer; value : integer);
    function getMinIntValue(offset : integer): int;
    function getMaxIntValue(offset : integer): int;
    procedure setValue(value : String);
    procedure clear();
    function getMinimum(): int;
    function getMaximum(): int;
    function getMaxCharCount(): int;
    procedure setOffset(offset : integer);
    function getStartOffset(): int;
    function getEndOffset(): int;
    procedure replaceChar(offset : integer; c : char);
    function isEmpty(): boolean;
    function getContent(): String;
    function getEditingDisplayableString(): String;
    function getEditedDisplayableString(): String;
    function getMaxCompletedString(): String;
    function getMinCompletedString(): String;
    function getIntValue(): int;
    procedure setIntValue(value : integer);
    function getCurrentPossibleValue(): String;
    procedure clear();
  public;
    constructor Create;
    destructor Destroy; override;
  end;

function substring(str : String; offset : integer): String;
function substring2(str : String; offset : integer; count : integer): String;
function startsWith(str : String; prefix : String): boolean; 
function endsWith(str : String; suffix : String): boolean; 

implementation

function substring(str : String; offset : integer): String;
begin
  result := RightStr(str, Length(str) - offset);
end;

function substring2(str : String; offset : integer; count : integer): String;
begin
  result := MidStr(str, offset+1, count - offset);
end;

function startsWith(str : String; prefix : String): boolean;
begin
  result := (Pos(prefix, str) = 1);
end;

function endsWith(str : String; suffix : String): boolean;
begin
  result := (RightStr(str, Length(suffix)) = suffix);
end;

{ TInterval }

constructor TInterval.Create();
begin
  inherited Create;
end;

destructor TInterval.Destroy();
begin
  inherited Destroy;
end;

begin
  ~~~~~5
  _intervals:=######7;
  ~~~~~5
  _separators:=######7;
  EMPTY_CHAR:='_';
end;
begin
  parseString(format);
end;
procedure TLyJFormat.setFormatString(format : String);
begin
  parseString(format);
end;

procedure TLyJFormat.parseString(format : String);
var
  start : integer;
  n : null;
  end : null;
  offset : integer;
  j : null;
  i : integer;
  firstInterval : null;
  beginBySep : boolean;
  size : integer;
begin
  size:=format.length();
  start:=format.indexOf('[');
  end:=format.indexOf(']');
  beginBySep:=false;
  
  if (start<>0) then 
  begin
    parseSeparator(format,0,start-1);
    beginBySep:=true;
    firstInterval:=start;
  end;
  parseInterval(format,start,end);
  start:=end+1;
  end:=format.indexOf('[',start)-1;
  begin
    parseSeparator(format,start,end);
    start:=end+1;
    end:=format.indexOf(']',start);
    parseInterval(format,start,end);
    start:=end+1;
    end:=format.indexOf('[',start)-1;
  end;
  
  if ((end<0) 
    and (start<size)) then 
  begin
    parseSeparator(format,start,size-1);
  end;
  offset:=firstInterval;
  i:=0;
  while (i<n) do begin
    j:=i;
    
    if (beginBySep) then 
    begin
      j:=i+1;
    end;
    getInterval(i).setOffset(offset);
    offset+=getInterval(i).getMaxCharCount();
    offset+=if ((i<(n-1))) then (getSeparator(j).length()) (0);
    inc(i);
  end;
end;

procedure TLyJFormat.parseInterval(format : String; start : integer; end : integer);
var
  min : integer;
  str : String;
  pos : integer;
  max : null;
begin
  
  if (start<end) then 
  begin
    str:=substring2(format,start+1,end);
    begin
      pos:=str.indexOf('-');
      min:=Integer.parseInt(substring2(str,0,pos));
      max:=Integer.parseInt(substring(str,pos+1));
    end;
    begin
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
    ;
  end;
end;

procedure TLyJFormat.parseSeparator(format : String; start : integer; end : integer);
var
  str : String;
begin
  
  if (start<=(end+1)) then 
  begin
    str:=substring2(format,start,end+1);
    _separators.add(str);
  end else begin
    ~~~~~5
    ;
  end;
end;

function TLyJFormat.getInterval(i : integer): Interval;
begin
  result := _intervals.get(i);
end;

function TLyJFormat.getSeparator(i : integer): String;
begin
  result := _separators.get(i);
end;

function TLyJFormat.getIntervalsCount(): int;
begin
  result := _intervals.size();
end;

function TLyJFormat.getIndexIntervalFromOffset(offset : integer): int;
var
  n : null;
  i : integer;
  result : integer;
begin
  result:=-1;
  i:=0;
  while (i<n) do begin
    
    if ((offset>=getInterval(i).getStartOffset()) 
      and (offset<=getInterval(i).getEndOffset())) then 
    begin
      result:=i;
    end;
    inc(i);
  end;
  result := result;
end;

function TLyJFormat.getIndexSeparatorFromOffset(offset : integer): int;
var
  n : null;
  i : integer;
  result : integer;
begin
  result:=-1;
  i:=0;
  while (i<n) do begin
    
    if ((offset>getInterval(i).getEndOffset()) 
      and (offset<getInterval(i+1).getStartOffset())) then 
    begin
      result:=i;
    end;
    inc(i);
  end;
  result := result;
end;

function TLyJFormat.isCharDeletionValid(offset : integer): boolean;
var
  index : integer;
begin
  index:=getIndexIntervalFromOffset(offset);
  
  if (index=-1) then 
  begin
    result := false;
  end;
  result := true;
end;

function TLyJFormat.isCharInsertionValid(c : char; offset : integer): boolean;
var
  minText : String;
  relOffset : integer;
  inter : Interval;
  maxValue : integer;
  index : integer;
  startOffset : integer;
  maxText : String;
  minValue : integer;
  minBuf : StringBuffer;
  maxBuf : StringBuffer;
begin
  
  if (not Character.isDigit(c)) then 
  begin
    result := false;
  end;
  index:=getIndexIntervalFromOffset(offset);
  
  if (index=-1) then 
  begin
    result := false;
  end;
  inter:=getInterval(index);
  startOffset:=inter.getStartOffset();
  relOffset:=offset-startOffset;
  ~~~~~5
  minBuf:=######7;
  ~~~~~5
  maxBuf:=######7;
  minBuf.setCharAt(relOffset,c);
  maxBuf.setCharAt(relOffset,c);
  minText:=minBuf.toString();
  maxText:=maxBuf.toString();
  begin
    minValue:=Integer.parseInt(minText);
    maxValue:=Integer.parseInt(maxText);
  end;
  begin
    result := false;
  end;
  
  if ((minValue<=inter.getMaximum()) 
    and (maxValue>=inter.getMinimum())) then 
  begin
    result := true;
  end;
  result := false;
end;

function TLyJFormat.replaceChar(offset : integer; c : char): int;
var
  relOffset : integer;
  inter : Interval;
  index : integer;
begin
  index:=getIndexIntervalFromOffset(offset);
  inter:=getInterval(index);
  relOffset:=offset-inter.getStartOffset();
  inter.replaceChar(relOffset,c);
  
  if (relOffset=(inter.getMaxCharCount()-1)) then 
  begin
    result := (if ((index<_separators.size())) then (offset+getSeparator(index).length()+1) (offset+1));
  end;
  result := offset+1;
end;

function TLyJFormat.getDisplayableString(hasFocus : boolean): String;
var
  n : null;
  j : null;
  i : integer;
  beginBySep : boolean;
  text : String;
begin
  text:='';
  
  if (hasFocus 
    or  isAllEmpty()) then 
  begin
    hasFocus:=true;
  end;
  text:='';
  beginBySep:=false;
  beginBySep:=(if ((n=0)) then false (getInterval(0).getStartOffset()<>0));
  
  if (beginBySep) then 
  begin
    text+=getSeparator(0);
  end;
  i:=0;
  while (i<n) do begin
    j:=i;
    
    if (beginBySep) then 
    begin
      j:=i+1;
    end;
    text+=if ((hasFocus)) then (getInterval(i).getEditingDisplayableString()) (getInterval(i).getEditedDisplayableString());
    
    if (j<_separators.size()) then 
    begin
      text+=getSeparator(j);
    end;
    inc(i);
  end;
  result := text;
end;

function TLyJFormat.isAllEmpty(): boolean;
var
  n : null;
  i : integer;
begin
  i:=0;
  while (i<n) do begin
    
    if (not getInterval(i).isEmpty()) then 
    begin
      result := false;
    end;
    inc(i);
  end;
  result := true;
end;

function TLyJFormat.getIntValue(offset : integer): int;
var
  interIndex : integer;
  index : integer;
  count : integer;
  sepIndex : integer;
begin
  
  if (getIntervalsCount()=0) then 
  begin
    result := 0;
  end;
  interIndex:=getIndexIntervalFromOffset(offset);
  sepIndex:=getIndexSeparatorFromOffset(offset);
  
  if (interIndex<>-1) then 
  begin
    result := getInterval(interIndex).getIntValue();
  end else if (sepIndex<>-1) then 
  begin
    result := getInterval(sepIndex).getIntValue();
  end else begin
    count:=getIntervalsCount();
    index:=if (((count-1)>=0)) then (count-1) (0);
    result := getInterval(index).getIntValue();
  end;
end;

procedure TLyJFormat.setIntValue(offset : integer; value : integer);
var
  interIndex : integer;
  sepIndex : integer;
begin
  
  if (getIntervalsCount()=0) then 
  begin
    exit;
  end;
  interIndex:=getIndexIntervalFromOffset(offset);
  sepIndex:=getIndexSeparatorFromOffset(offset);
  
  if (interIndex<>-1) then 
  begin
    getInterval(interIndex).setIntValue(value);
  end else if (sepIndex<>-1) then 
  begin
    getInterval(sepIndex).setIntValue(value);
  end else begin
    getInterval(getIntervalsCount()-1).setIntValue(value);
  end;
end;

function TLyJFormat.getMinIntValue(offset : integer): int;
var
  interIndex : integer;
  sepIndex : integer;
begin
  
  if (getIntervalsCount()=0) then 
  begin
    result := 0;
  end;
  interIndex:=getIndexIntervalFromOffset(offset);
  sepIndex:=getIndexSeparatorFromOffset(offset);
  
  if (interIndex<>-1) then 
  begin
    result := getInterval(interIndex).getMinimum();
  end else if (sepIndex<>-1) then 
  begin
    result := getInterval(sepIndex).getMinimum();
  end else begin
    result := getInterval(getIntervalsCount()-1).getMinimum();
  end;
end;

function TLyJFormat.getMaxIntValue(offset : integer): int;
var
  interIndex : integer;
  sepIndex : integer;
begin
  
  if (getIntervalsCount()=0) then 
  begin
    result := 0;
  end;
  interIndex:=getIndexIntervalFromOffset(offset);
  sepIndex:=getIndexSeparatorFromOffset(offset);
  
  if (interIndex<>-1) then 
  begin
    result := getInterval(interIndex).getMaximum();
  end else if (sepIndex<>-1) then 
  begin
    result := getInterval(sepIndex).getMaximum();
  end else begin
    result := getInterval(getIntervalsCount()-1).getMaximum();
  end;
end;

procedure TLyJFormat.setValue(value : String);
var
  start : integer;
  n : null;
  end : null;
  i : integer;
  subVal : null;
begin
  i:=0;
  while (i<n) do begin
    start:=getInterval(i).getStartOffset();
    end:=getInterval(i).getEndOffset();
    begin
      subVal:=Integer.parseInt(substring2(value,start,end+1));
      getInterval(i).setIntValue(subVal);
    end;
    begin
    end;
    inc(i);
  end;
end;

procedure TLyJFormat.clear();
var
  n : null;
  i : integer;
begin
  i:=0;
  while (i<n) do begin
    getInterval(i).clear();
    inc(i);
  end;
end;

begin
  _min:=minimum;
  _max:=maximum;
  clear();
end;
function TInterval.getMinimum(): int;
begin
  result := _min;
end;

function TInterval.getMaximum(): int;
begin
  result := _max;
end;

function TInterval.getMaxCharCount(): int;
begin
  result := String.valueOf(_max).length();
end;

procedure TInterval.setOffset(offset : integer);
begin
  _startOffset:=offset;
  _endOffset:=offset+getMaxCharCount()-1;
end;

function TInterval.getStartOffset(): int;
begin
  result := _startOffset;
end;

function TInterval.getEndOffset(): int;
begin
  result := _endOffset;
end;

procedure TInterval.replaceChar(offset : integer; c : char);
begin
  _content:=substring2(_content,0,offset)+c+substring(_content,offset+1);
end;

function TInterval.isEmpty(): boolean;
var
  length : null;
  i : integer;
begin
  i:=0;
  begin
    
    if (_content.charAt(i)<>EMPTY_CHAR) then 
    begin
      result := false;
    end;
    inc(i);
  end;
  result := true;
end;

function TInterval.getContent(): String;
begin
  result := _content;
end;

function TInterval.getEditingDisplayableString(): String;
begin
  result := _content;
end;

function TInterval.getEditedDisplayableString(): String;
var
  resu : StringBuffer;
  contentWithBlank : String;
  i : integer;
  tmp : String;
  value : integer;
begin
  contentWithBlank:=_content.replace(EMPTY_CHAR,' ');
  tmp:=contentWithBlank.trim();
  
  if (tmp.length()=0) then 
  begin
    begin
      tmp:=String.valueOf(getMinimum());
    end;
    begin
    end;
  end;
  value:=LyTools.intFromString(tmp);
  
  if (value<getMinimum()) then 
  begin
    value:=getMinimum();
  end;
  
  if (value>getMaximum()) then 
  begin
    value:=getMaximum();
  end;
  begin
    tmp:=String.valueOf(value);
  end;
  begin
    result := _content;
  end;
  ~~~~~5
  resu:=######7;
  i:=tmp.length();
  while (i<_content.length()) do begin
    resu.append('0');
    inc(i);
  end;
  resu.append(tmp);
  result := (resu.toString());
end;

function TInterval.getMaxCompletedString(): String;
var
  filledWithChar : char;
  i : integer;
  tmp : StringBuffer;
begin
  ~~~~~5
  tmp:=######7;
  filledWithChar:='9';
  i:=0;
  begin
    tmp.setCharAt(i,filledWithChar);
    inc(i);
  end;
  i:=tmp.toString().indexOf(EMPTY_CHAR);
  
  if (i=-1) then 
  begin
    begin
      Integer.parseInt(tmp.toString());
      result := tmp.toString();
    end;
    begin
      result := '';
    end;
  end;
  begin
    tmp.setCharAt(i,filledWithChar);
    inc(i);
  end;
  begin
    Integer.parseInt(tmp.toString());
    result := tmp.toString();
  end;
  begin
    result := '';
  end;
end;

function TInterval.getMinCompletedString(): String;
var
  i : integer;
  tmp : StringBuffer;
begin
  ~~~~~5
  tmp:=######7;
  i:=0;
  begin
    tmp.setCharAt(i,'0');
    inc(i);
  end;
  i:=tmp.toString().indexOf(EMPTY_CHAR);
  
  if (i=-1) then 
  begin
    begin
      Integer.parseInt(tmp.toString());
      result := tmp.toString();
    end;
    begin
      result := '';
    end;
  end;
  begin
    tmp.setCharAt(i,'0');
    inc(i);
  end;
  begin
    Integer.parseInt(tmp.toString());
    result := tmp.toString();
  end;
  begin
    result := '';
  end;
end;

function TInterval.getIntValue(): int;
begin
  result := Integer.parseInt(getEditedDisplayableString());
end;

procedure TInterval.setIntValue(value : integer);
var
  n : null;
  i : integer;
  str : String;
  max : integer;
begin
  
  if ((value>=_min) 
    and (value<=_max)) then 
  begin
    str:=String.valueOf(value);
    max:=getMaxCharCount();
    
    if (str.length()<max) then 
    begin
      i:=0;
      while (i<n) do begin
        str:='0'+str;
        inc(i);
      end;
    end;
    _content:=str;
  end;
end;

function TInterval.getCurrentPossibleValue(): String;
begin
  result := '';
end;

procedure TInterval.clear();
var
  n : null;
  i : integer;
begin
  _content:='';
  i:=0;
  while (i<n) do begin
    _content+=String.valueOf(EMPTY_CHAR);
    inc(i);
  end;
end;


end.
