unit Maze.Core;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  /// <summary>
  /// Cardinal directions used for maze navigation.
  /// </summary>
  TMazeDirection = (mdNorth, mdSouth, mdEast, mdWest);

  TMazeDirectionSet = set of TMazeDirection;

  /// <summary>
  /// Simple record describing a single maze cell and which walls are present.
  /// </summary>
  TMazeCell = record
  public
    X: Integer;
    Y: Integer;
    /// <summary>
    /// True if the cell has a wall on its north edge.
    /// </summary>
    NorthWall: Boolean;
    /// <summary>
    /// True if the cell has a wall on its south edge.
    /// </summary>
    SouthWall: Boolean;
    /// <summary>
    /// True if the cell has a wall on its east edge.
    /// </summary>
    EastWall: Boolean;
    /// <summary>
    /// True if the cell has a wall on its west edge.
    /// </summary>
    WestWall: Boolean;

    class function Create(const AX, AY: Integer): TMazeCell; static;
  end;

  /// <summary>
  /// Interface representing maze generation algorithms. Implementations should be stateless or reentrant.
  /// </summary>
  IMazeGenerator = interface
    ['{6F3DAD11-4B25-4C05-8B0A-05F1FB3EDC18}']
    /// <summary>
    /// Generates a maze for the given width and height.
    /// </summary>
    /// <param name="AWidth">Number of cells horizontally; must be &gt; 0.</param>
    /// <param name="AHeight">Number of cells vertically; must be &gt; 0.</param>
    /// <returns>
    /// A flat array of <see cref="TMazeCell"/> records with length AWidth * AHeight.
    /// Cells are ordered row-major (Y first, then X).
    /// </returns>
    function GenerateMaze(const AWidth, AHeight: Integer): TArray<TMazeCell>;

    /// <summary>
    /// Gets a human-friendly name for the generator implementation, suitable for UI display.
    /// </summary>
    function GetDisplayName: string;
  end;

implementation

{ TMazeCell }

class function TMazeCell.Create(const AX, AY: Integer): TMazeCell;
begin
  Result.X := AX;
  Result.Y := AY;

  Result.NorthWall := True;
  Result.SouthWall := True;
  Result.EastWall := True;
  Result.WestWall := True;
end;

end.
