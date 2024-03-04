unit TraducMainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, UTraducteur,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Menus;

type
  TForm3 = class(TForm)
    lbRef: TListBox;
    Label1: TLabel;
    edLangue1: TEdit;
    cbLangue1: TComboBox;
    btnValide1: TButton;
    edLangue2: TEdit;
    btnValide2: TButton;
    cbLangue2: TComboBox;
    btnSuppRef: TButton;
    edNouvRef: TEdit;
    btnAjoutRef: TButton;
    MenuBar1: TMenuBar;
    Panel1: TPanel;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure lbRefChange(Sender: TObject);
    procedure btnValide1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnSuppRefClick(Sender: TObject);
  private
    { Déclarations privées }
    trad: TTraducteur;

  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.btnSuppRefClick(Sender: TObject);
var
  sref: string;
begin
  if lbRef.ItemIndex >= 0 then
  begin
    sref := lbRef.Items[lbRef.ItemIndex];
    trad.retireRef(sref);
    lbRef.Items.Delete(lbRef.ItemIndex);
  end;
end;

procedure TForm3.btnValide1Click(Sender: TObject);
var
  scode, sref, strad: string;
begin
  if (lbRef.ItemIndex >= 0) and ((cbLangue1.ItemIndex >= 0) and (Sender = btnValide1) or (cbLangue2.ItemIndex >= 0) and
    (Sender = btnValide2)) then
  begin
    sref := lbRef.Items[lbRef.ItemIndex];
    if (Sender = btnValide1) then
    begin
      scode := cbLangue1.Items[cbLangue1.ItemIndex];
      strad := edLangue1.Text;
    end;
    if (Sender = btnValide2) then
    begin
      scode := cbLangue2.Items[cbLangue2.ItemIndex];
      strad := edLangue2.Text;
    end;
    if trad.majtraduction(scode, sref, strad) then
    begin
      if (Sender = btnValide1) then
        edLangue1.Text := '';
      if (Sender = btnValide2) then
        edLangue2.Text := '';
    end;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  trad.Sauve('D:\Projets\Delphi\amiraute2\langues\');
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  s: string;
  refs: TStringList;
begin
  trad := TTraducteur.Create('D:\Projets\Delphi\amiraute2\');
  refs := TStringList.Create;
  trad.ref2Liste(refs);
  lbRef.Clear;
  lbRef.BeginUpdate;
  for s in refs do
  begin
    lbRef.Items.Add(s);
  end;
  lbRef.EndUpdate;
  refs.Clear;
  trad.langues2Liste(refs);
  cbLangue1.BeginUpdate;
  cbLangue2.BeginUpdate;
  for s in refs do
  begin
    cbLangue1.Items.Add(s);
    cbLangue2.Items.Add(s);
  end;
  cbLangue1.EndUpdate;
  cbLangue2.EndUpdate;
end;

procedure TForm3.lbRefChange(Sender: TObject);
var
  scode, sref: string;
begin
  if (lbRef.ItemIndex >= 0) then
  begin

    sref := lbRef.Items[lbRef.ItemIndex];
    if (cbLangue1.ItemIndex >= 0) then
    begin
      scode := cbLangue1.Items[cbLangue1.ItemIndex];
      edLangue1.Text := trad.traduit(scode, sref);
    end;
    if (cbLangue2.ItemIndex >= 0) then
    begin
      scode := cbLangue2.Items[cbLangue2.ItemIndex];
      edLangue2.Text := trad.traduit(scode, sref);
    end;
  end;
end;

end.
