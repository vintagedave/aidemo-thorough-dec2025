unit MazeSettingsDialog;

interface

uses
  System.SysUtils, System.Classes, System.TypInfo, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Maze.Settings;

type
  /// <summary>
  /// Dialog allowing the user to choose the maze generation algorithm.
  /// </summary>
  TfrmMazeSettings = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblAlgorithm: TLabel;
    cbAlgorithm: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    FMazeSettings: TMazeSettings;
    /// <summary>
    /// Populates the algorithm combo box using the display names mapped from <c>TMazeAlgorithm</c>.
    /// When <c>TMazeAlgorithm</c> is extended, update <c>AlgorithmDisplayNames</c> accordingly.
    /// </summary>
    procedure PopulateAlgorithms;
    /// <summary>
    /// Finds the combo box index corresponding to the given algorithm, or -1 if none matches.
    /// </summary>
    function FindIndexForAlgorithm(const AAlgorithm: TMazeAlgorithm): Integer;
    /// <summary>
    /// Safely resolves the algorithm stored at the given combo box index.
    /// Returns <c>True</c> only when the stored object is non-nil and represents a valid enum value.
    /// </summary>
    function TryGetAlgorithmAtIndex(const AIndex: Integer; out AAlgorithm: TMazeAlgorithm): Boolean;
  public
    /// <summary>
    /// Shows the dialog for the given settings instance and updates it if the user confirms.
    /// </summary>
    class function Execute(const AMazeSettings: TMazeSettings): Boolean;
  end;

var
  frmMazeSettings: TfrmMazeSettings;

implementation

{$R *.dfm}

{ TfrmMazeSettings }

class function TfrmMazeSettings.Execute(const AMazeSettings: TMazeSettings): Boolean;
begin
  Result := False;

  if not Assigned(AMazeSettings) then begin
    Exit;
  end;

  var LDialog := TfrmMazeSettings.Create(nil);
  try
    LDialog.FMazeSettings := AMazeSettings;

    var LIndex := LDialog.FindIndexForAlgorithm(AMazeSettings.Algorithm);
    if LIndex >= 0 then begin
      LDialog.cbAlgorithm.ItemIndex := LIndex;
    end else begin
      LDialog.cbAlgorithm.ItemIndex := -1;
    end;

    Result := LDialog.ShowModal = mrOK;
    if Result then begin
      var LSelectedAlgorithm: TMazeAlgorithm;
      if LDialog.TryGetAlgorithmAtIndex(LDialog.cbAlgorithm.ItemIndex, LSelectedAlgorithm) then begin
        AMazeSettings.Algorithm := LSelectedAlgorithm;
      end;
    end;
  finally
    LDialog.Free;
  end;
end;

procedure TfrmMazeSettings.FormCreate(Sender: TObject);
begin
  PopulateAlgorithms;
end;

function TfrmMazeSettings.FindIndexForAlgorithm(const AAlgorithm: TMazeAlgorithm): Integer;
begin
  Result := -1;

  for var I := 0 to cbAlgorithm.Items.Count - 1 do begin
    var LAlgorithm: TMazeAlgorithm;
    if TryGetAlgorithmAtIndex(I, LAlgorithm) and (LAlgorithm = AAlgorithm) then begin
      Result := I;
      Break;
    end;
  end;
end;

function TfrmMazeSettings.TryGetAlgorithmAtIndex(const AIndex: Integer; out AAlgorithm: TMazeAlgorithm): Boolean;
begin
  Result := False;
  AAlgorithm := Low(TMazeAlgorithm);

  if (AIndex < 0) or (AIndex >= cbAlgorithm.Items.Count) then begin
    Exit;
  end;

  var LObj := cbAlgorithm.Items.Objects[AIndex];
  if LObj = nil then begin
    Exit;
  end;

  var LValue := NativeInt(LObj);
  if (LValue < Ord(Low(TMazeAlgorithm))) or (LValue > Ord(High(TMazeAlgorithm))) then begin
    Exit;
  end;

  AAlgorithm := TMazeAlgorithm(LValue);
  Result := True;
end;

procedure TfrmMazeSettings.PopulateAlgorithms;
const
  AlgorithmDisplayNames: array[TMazeAlgorithm] of string = (
    'Recursive Backtracking',
    'Prim''s Algorithm'
  );
begin
  cbAlgorithm.Items.BeginUpdate;
  try
    cbAlgorithm.Items.Clear;

    for var LAlgorithm := Low(TMazeAlgorithm) to High(TMazeAlgorithm) do begin
      cbAlgorithm.Items.AddObject(AlgorithmDisplayNames[LAlgorithm], TObject(NativeInt(Ord(LAlgorithm))));
    end;
  finally
    cbAlgorithm.Items.EndUpdate;
  end;
end;

end.
