program Traducteur;

uses
  System.StartUpCopy,
  FMX.Forms,
  TraducMainFrm in 'TraducMainFrm.pas' {Form3},
  UTraducteur in 'UTraducteur.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
