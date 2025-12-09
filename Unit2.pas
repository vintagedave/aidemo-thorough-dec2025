unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Maze.Core, Maze.Generator.RecursiveBacktracking, Maze.Generator.Prim, Maze.Settings, MazeSettingsDialog;

type
  /// <summary>
  /// Main form hosting maze display area and controls for settings and regeneration.
  /// </summary>
  TForm2 = class(TForm)
    pnlTop: TPanel;
    btnShowSettings: TButton;
    btnRegenerateMaze: TButton;
    pbMaze: TPaintBox;
    procedure btnShowSettingsClick(Sender: TObject);
    procedure btnRegenerateMazeClick(Sender: TObject);
    procedure pbMazePaint(Sender: TObject);
  private
    FMazeSettings: TMazeSettings;
    FMazeCells: TArray<TMazeCell>;
    FMazeWidth: Integer;
    FMazeHeight: Integer;
    /// <summary>
    /// Opens the maze settings dialog.
    /// </summary>
    procedure OpenSettingsDialog;
    /// <summary>
    /// Triggers maze regeneration and requests a repaint of the maze area.
    /// </summary>
    procedure RegenerateMaze;
    /// <summary>
    /// Returns an <see cref="IMazeGenerator"/> instance based on the current settings.
    /// </summary>
    function CreateGeneratorForSettings: IMazeGenerator;
    /// <summary>
    /// Renders the current maze into the paint box.
    /// </summary>
    procedure RenderMaze;
    /// <summary>
    /// Shows an error message to the user.
    /// </summary>
    procedure ShowError(const AMessage: string);
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btnRegenerateMazeClick(Sender: TObject);
begin
  RegenerateMaze;
end;

procedure TForm2.btnShowSettingsClick(Sender: TObject);
begin
  OpenSettingsDialog;
end;

function TForm2.CreateGeneratorForSettings: IMazeGenerator;
begin
  if not Assigned(FMazeSettings) then begin
    Exit(nil);
  end;

  case FMazeSettings.Algorithm of
    maRecursiveBacktracking:
      Result := TMazeRecursiveBacktrackingGenerator.Create;
    maPrim:
      Result := TMazePrimGenerator.Create;
  else
    Result := nil;
  end;
end;

procedure TForm2.CreateWnd;
begin
  inherited CreateWnd;

  Randomize;

  if not Assigned(FMazeSettings) then begin
    FMazeSettings := TMazeSettings.Create;
  end;

  FMazeWidth := 20;
  FMazeHeight := 15;

  RegenerateMaze;
end;

procedure TForm2.DestroyWnd;
begin
  FMazeCells := nil;

  FreeAndNil(FMazeSettings);

  inherited DestroyWnd;
end;

procedure TForm2.OpenSettingsDialog;
begin
  if not Assigned(FMazeSettings) then begin
    FMazeSettings := TMazeSettings.Create;
  end;

  if TfrmMazeSettings.Execute(FMazeSettings) then begin
    RegenerateMaze;
  end;
end;

procedure TForm2.pbMazePaint(Sender: TObject);
begin
  RenderMaze;
end;

procedure TForm2.RegenerateMaze;
begin
  var LGenerator := CreateGeneratorForSettings;
  if not Assigned(LGenerator) then begin
    ShowError('No maze generator is available.');
    Exit;
  end;

  try
    FMazeCells := LGenerator.GenerateMaze(FMazeWidth, FMazeHeight);
  except
    on E: Exception do begin
      ShowError('Failed to generate maze: ' + E.Message);
      Exit;
    end;
  end;

  pbMaze.Invalidate;
end;

procedure TForm2.RenderMaze;
begin
  var LCanvas := pbMaze.Canvas;

  LCanvas.Brush.Color := clWindow;
  LCanvas.FillRect(pbMaze.ClientRect);

  if Length(FMazeCells) = 0 then begin
    Exit;
  end;

  var LCellWidth := pbMaze.ClientWidth div FMazeWidth;
  var LCellHeight := pbMaze.ClientHeight div FMazeHeight;

  if (LCellWidth <= 0) or (LCellHeight <= 0) then begin
    Exit;
  end;

  LCanvas.Pen.Color := clWindowText;

  for var LCell in FMazeCells do begin
    var LX := LCell.X * LCellWidth;
    var LY := LCell.Y * LCellHeight;
    var RX := LX + LCellWidth;
    var BY := LY + LCellHeight;

    if LCell.NorthWall then begin
      LCanvas.MoveTo(LX, LY);
      LCanvas.LineTo(RX, LY);
    end;

    if LCell.SouthWall then begin
      LCanvas.MoveTo(LX, BY);
      LCanvas.LineTo(RX, BY);
    end;

    if LCell.WestWall then begin
      LCanvas.MoveTo(LX, LY);
      LCanvas.LineTo(LX, BY);
    end;

    if LCell.EastWall then begin
      LCanvas.MoveTo(RX, LY);
      LCanvas.LineTo(RX, BY);
    end;
  end;
end;

procedure TForm2.ShowError(const AMessage: string);
begin
  MessageDlg(AMessage, mtError, [mbOK], 0);
end;

end.
