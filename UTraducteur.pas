unit UTraducteur;

interface

uses
  System.Classes, System.Generics.Collections;

type
  TTraduc = TDictionary<string, string>;

  TTraducteur = class(TObject)
  private
    lesTraduc: TDictionary<string, TTraduc>;
    slngref: string;
  public
    constructor Create; overload;
    constructor Create(rep: string); overload;
    function traduit(scode, sref: String): String;
    function majtraduction(scode, sref, trad: String): boolean;
    procedure retireRef(sref: String);
    procedure ref2Liste(lst: TStringList);
    procedure langues2Liste(lst: TStringList);
    procedure Sauve(rep: string);
  end;

implementation

uses
  System.IOUtils, System.JSON, System.SysUtils;

{ TTraducteur }

constructor TTraducteur.Create;
begin
  lesTraduc := TDictionary<string, TTraduc>.Create;
end;

constructor TTraducteur.Create(rep: string);
var
  Fichiers: TArray<string>;
  s, nomF: String;
  trd: TTraduc;
  stjson: string;
  Ftxt: TextFile;
  JSONValue: TJSONValue;
  jliste: TJSONArray;
  n, err: Integer;
  elem: TJSONObject;
  sref, strad: string;
begin
  lesTraduc := TDictionary<string, TTraduc>.Create;
  slngref := '';
  Fichiers := TDirectory.GetFiles(rep + '\Langues', '*.json');
  for nomF in Fichiers do
  begin
    s := ExtractFileName(nomF);
    delete(s, length(s) - 4, 5);
    trd := TTraduc.Create;
    lesTraduc.Add(s, trd);
    if slngref = '' then
      slngref := s;
    assignFile(Ftxt, nomF);
    reset(Ftxt);
    stjson := '';
    while not(eof(Ftxt)) do
    begin
      readln(Ftxt, s);
      stjson := stjson + s;
    end;
    closeFile(Ftxt);
    JSONValue := TJSONObject.ParseJSONValue(stjson);
    jliste := JSONValue.GetValue<TJSONArray>();
    for n := 0 to jliste.Count - 1 do
    begin
      elem := TJSONObject(jliste.items[n]);
      if elem.TryGetValue<string>('ref', sref) and elem.TryGetValue<string>('trad', strad) then
      begin
        if not(trd.TryAdd(sref, strad)) then
          err := 2;
      end
      else
      begin
        err := 1;
      end;
    end;
  end;
end;

procedure TTraducteur.langues2Liste(lst: TStringList);
var
  s: string;
begin
  lst.Clear;
  for s in lesTraduc.Keys do
  begin
    lst.Add(s);
  end;
end;

function TTraducteur.majtraduction(scode, sref, trad: String): boolean;
var
  trd: TTraduc;
  s: string;
begin
  if lesTraduc.TryGetValue(scode, trd) then
  begin
    trd.AddOrSetValue(sref, trad);
    result := true;
  end
  else
    result := false;
end;

procedure TTraducteur.ref2Liste(lst: TStringList);
var
  trd: TTraduc;
  s: string;
begin
  if lesTraduc.TryGetValue(slngref, trd) then
  begin
    lst.Clear;
    for s in trd.Keys do
    begin
      lst.Add(s);
    end;
  end;
end;

procedure TTraducteur.retireRef(sref: String);
var
 trd: TTraduc;
begin
 for trd in lesTraduc.Values do
 begin
   trd.Remove(sref);
 end;
end;

function TTraducteur.traduit(scode, sref: String): String;
var
  trd: TTraduc;
  strad: string;
begin
  if lesTraduc.TryGetValue(scode, trd) then
  begin
    if trd.TryGetValue(sref, strad) then
      result := strad
    else
      result := 'XXXX' + sref;
  end
  else
    result := 'XXXX' + scode + 'XXXXX';
end;

procedure TTraducteur.Sauve(rep: string);
var
  Fichiers: TArray<string>;
  nf,nomF: String;
  trd: TTraduc;
  stjson: string;
  Ftxt: TextFile;

  jliste: TJSONArray;
  n, err: Integer;
  elem: TJSONObject;
  sref, strad: string;
begin
  for nomF in lesTraduc.Keys do
  begin
    if lesTraduc.TryGetValue(nomF, trd) then
    begin
      jliste := TJSONArray.Create;
      for sref in trd.Keys do
      begin
        if trd.TryGetValue(sref, strad) then
        begin
          elem := TJSONObject.Create;
          elem.AddPair('ref', sref);
          elem.AddPair('trad', strad);
          jliste.Add(elem);
        end;
      end;
      nf:= rep + nomF + '.json';
      AssignFile(Ftxt, nf);
      rewrite(Ftxt);
      nf:=jliste.ToJSON;
      writeln(Ftxt, nf);
      closeFile(Ftxt);
    end;
  end;
end;

end.
