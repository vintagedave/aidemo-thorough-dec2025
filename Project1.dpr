program Project1;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  Maze.Core in 'Maze.Core.pas',
  Maze.Generator.RecursiveBacktracking in 'Maze.Generator.RecursiveBacktracking.pas',
  Maze.Generator.Prim in 'Maze.Generator.Prim.pas',
  MazeSettingsDialog in 'MazeSettingsDialog.pas' {frmMazeSettings},
  Maze.Settings in 'Maze.Settings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
