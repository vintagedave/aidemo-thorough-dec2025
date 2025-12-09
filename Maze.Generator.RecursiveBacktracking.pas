unit Maze.Generator.RecursiveBacktracking;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Types, Maze.Core;

type
  /// <summary>
  /// Maze generator using classic recursive backtracking (depth-first search) algorithm.
  /// </summary>
  TMazeRecursiveBacktrackingGenerator = class(TInterfacedObject, IMazeGenerator)
  private
    function IndexOfCell(const AWidth, AX, AY: Integer): Integer;
    procedure KnockDownWall(var ACurrent, ANeighbor: TMazeCell; const ADirection: TMazeDirection);
    function GetOppositeDirection(const ADirection: TMazeDirection): TMazeDirection;
    function GetUnvisitedNeighbors(const AWidth, AHeight: Integer; const AVisited: TArray<Boolean>;
      const AX, AY: Integer): TList<TMazeDirection>;
    procedure GenerateDepthFirst(const AWidth, AHeight: Integer; var ACells: TArray<TMazeCell>);
  public
    /// <inheritdoc />
    function GenerateMaze(const AWidth, AHeight: Integer): TArray<TMazeCell>;
    /// <inheritdoc />
    function GetDisplayName: string;
  end;

implementation

{ TMazeRecursiveBacktrackingGenerator }

procedure TMazeRecursiveBacktrackingGenerator.GenerateDepthFirst(const AWidth, AHeight: Integer;
  var ACells: TArray<TMazeCell>);
begin
  if (AWidth <= 0) or (AHeight <= 0) then begin
    Exit;
  end;

  var LTotalCells := AWidth * AHeight;
  var LVisited: TArray<Boolean> := nil;
  SetLength(LVisited, LTotalCells);

  var LStack := TStack<TPoint>.Create;
  try
    var LStart := TPoint.Create(0, 0);
    LStack.Push(LStart);
    LVisited[IndexOfCell(AWidth, LStart.X, LStart.Y)] := True;

    while LStack.Count > 0 do begin
      var LCurrentPoint := LStack.Peek;
      var LNeighbors := GetUnvisitedNeighbors(AWidth, AHeight, LVisited, LCurrentPoint.X, LCurrentPoint.Y);
      try
        if LNeighbors.Count = 0 then begin
          LStack.Pop;
          Continue;
        end;

        var LRandomIndex := Random(LNeighbors.Count);
        var LDirection := LNeighbors[LRandomIndex];

        var LNextPoint := LCurrentPoint;
        case LDirection of
          mdNorth:
            Dec(LNextPoint.Y);
          mdSouth:
            Inc(LNextPoint.Y);
          mdEast:
            Inc(LNextPoint.X);
          mdWest:
            Dec(LNextPoint.X);
        end;

        var LCurrentIndex := IndexOfCell(AWidth, LCurrentPoint.X, LCurrentPoint.Y);
        var LNextIndex := IndexOfCell(AWidth, LNextPoint.X, LNextPoint.Y);

        KnockDownWall(ACells[LCurrentIndex], ACells[LNextIndex], LDirection);

        LVisited[LNextIndex] := True;
        LStack.Push(LNextPoint);
      finally
        LNeighbors.Free;
      end;
    end;
  finally
    LStack.Free;
  end;
end;

function TMazeRecursiveBacktrackingGenerator.GenerateMaze(const AWidth, AHeight: Integer): TArray<TMazeCell>;
begin
  if (AWidth <= 0) or (AHeight <= 0) then begin
    raise EArgumentOutOfRangeException.Create('Maze dimensions must be positive.');
  end;

  SetLength(Result, AWidth * AHeight);

  for var LY := 0 to AHeight - 1 do begin
    for var LX := 0 to AWidth - 1 do begin
      var LIndex := IndexOfCell(AWidth, LX, LY);
      Result[LIndex] := TMazeCell.Create(LX, LY);
    end;
  end;

  GenerateDepthFirst(AWidth, AHeight, Result);
end;

function TMazeRecursiveBacktrackingGenerator.GetDisplayName: string;
begin
  Result := 'Recursive Backtracking';
end;

function TMazeRecursiveBacktrackingGenerator.GetOppositeDirection(const ADirection: TMazeDirection): TMazeDirection;
begin
  case ADirection of
    mdNorth:
      Result := mdSouth;
    mdSouth:
      Result := mdNorth;
    mdEast:
      Result := mdWest;
    mdWest:
      Result := mdEast;
  else
    raise EInvalidOpException.Create('Invalid direction.');
  end;
end;

function TMazeRecursiveBacktrackingGenerator.GetUnvisitedNeighbors(const AWidth, AHeight: Integer;
  const AVisited: TArray<Boolean>; const AX, AY: Integer): TList<TMazeDirection>;
begin
  Result := TList<TMazeDirection>.Create;

  if AY > 0 then begin
    if not AVisited[IndexOfCell(AWidth, AX, AY - 1)] then begin
      Result.Add(mdNorth);
    end;
  end;

  if AY < AHeight - 1 then begin
    if not AVisited[IndexOfCell(AWidth, AX, AY + 1)] then begin
      Result.Add(mdSouth);
    end;
  end;

  if AX < AWidth - 1 then begin
    if not AVisited[IndexOfCell(AWidth, AX + 1, AY)] then begin
      Result.Add(mdEast);
    end;
  end;

  if AX > 0 then begin
    if not AVisited[IndexOfCell(AWidth, AX - 1, AY)] then begin
      Result.Add(mdWest);
    end;
  end;
end;

function TMazeRecursiveBacktrackingGenerator.IndexOfCell(const AWidth, AX, AY: Integer): Integer;
begin
  Result := (AY * AWidth) + AX;
end;

procedure TMazeRecursiveBacktrackingGenerator.KnockDownWall(var ACurrent, ANeighbor: TMazeCell;
  const ADirection: TMazeDirection);
begin
  case ADirection of
    mdNorth:
      begin
        ACurrent.NorthWall := False;
        ANeighbor.SouthWall := False;
      end;
    mdSouth:
      begin
        ACurrent.SouthWall := False;
        ANeighbor.NorthWall := False;
      end;
    mdEast:
      begin
        ACurrent.EastWall := False;
        ANeighbor.WestWall := False;
      end;
    mdWest:
      begin
        ACurrent.WestWall := False;
        ANeighbor.EastWall := False;
      end;
  end;
end;

end.
