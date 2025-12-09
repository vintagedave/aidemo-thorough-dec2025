unit Maze.Settings;

interface

/// <summary>
/// Supported maze generation algorithms.
/// </summary>
type
  TMazeAlgorithm = (maRecursiveBacktracking, maPrim);

  /// <summary>
  /// In-memory user settings for maze generation.
  /// </summary>
  TMazeSettings = class
  private
    FAlgorithm: TMazeAlgorithm;
  public
    constructor Create;
    /// <summary>
    /// Selected maze generation algorithm.
    /// </summary>
    property Algorithm: TMazeAlgorithm read FAlgorithm write FAlgorithm;
  end;

implementation

{ TMazeSettings }

constructor TMazeSettings.Create;
begin
  inherited Create;

  FAlgorithm := maRecursiveBacktracking;
end;

end.
