unit Maze.Generator.Prim;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Types, Maze.Core;

type
  /// <summary>
  /// Maze generator using randomized Prim's algorithm.
  /// </summary>
  TMazePrimGenerator = class(TInterfacedObject, IMazeGenerator)
  private
    type
      TFrontierEdge = record
      public
        FromX: Integer;
        FromY: Integer;
        ToX: Integer;
        ToY: Integer;
        Direction: TMazeDirection;
      end;
  private
    function IndexOfCell(const AWidth, AX, AY: Integer): Integer;
    procedure KnockDownWall(var ACurrent, ANeighbor: TMazeCell; const ADirection: TMazeDirection);
    function CreateEdge(const AFromX, AFromY, AToX, AToY: Integer; const ADirection: TMazeDirection): TFrontierEdge;
    procedure AddFrontierEdges(const AWidth, AHeight: Integer; const AVisited: TArray<Boolean>;
      const AX, AY: Integer; const AFrontier: TList<TFrontierEdge>);
  public
    /// <inheritdoc />
    function GenerateMaze(const AWidth, AHeight: Integer): TArray<TMazeCell>;
    /// <inheritdoc />
    function GetDisplayName: string;
  end;

implementation

{ TMazePrimGenerator }

procedure TMazePrimGenerator.AddFrontierEdges(const AWidth, AHeight: Integer; const AVisited: TArray<Boolean>;
  const AX, AY: Integer; const AFrontier: TList<TFrontierEdge>);
begin
  if (AY > 0) and not AVisited[IndexOfCell(AWidth, AX, AY - 1)] then begin
    AFrontier.Add(CreateEdge(AX, AY, AX, AY - 1, mdNorth));
  end;

  if (AY < AHeight - 1) and not AVisited[IndexOfCell(AWidth, AX, AY + 1)] then begin
    AFrontier.Add(CreateEdge(AX, AY, AX, AY + 1, mdSouth));
  end;

  if (AX < AWidth - 1) and not AVisited[IndexOfCell(AWidth, AX + 1, AY)] then begin
    AFrontier.Add(CreateEdge(AX, AY, AX + 1, AY, mdEast));
  end;

  if (AX > 0) and not AVisited[IndexOfCell(AWidth, AX - 1, AY)] then begin
    AFrontier.Add(CreateEdge(AX, AY, AX - 1, AY, mdWest));
  end;
end;

function TMazePrimGenerator.CreateEdge(const AFromX, AFromY, AToX, AToY: Integer;
  const ADirection: TMazeDirection): TFrontierEdge;
begin
  Result.FromX := AFromX;
  Result.FromY := AFromY;
  Result.ToX := AToX;
  Result.ToY := AToY;
  Result.Direction := ADirection;
end;

function TMazePrimGenerator.GenerateMaze(const AWidth, AHeight: Integer): TArray<TMazeCell>;
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

  var LVisited: TArray<Boolean> := nil;
  SetLength(LVisited, Length(Result));

  var LFrontier := TList<TFrontierEdge>.Create;
  try
    var LStart := TPoint.Create(0, 0);
    LVisited[IndexOfCell(AWidth, LStart.X, LStart.Y)] := True;
    AddFrontierEdges(AWidth, AHeight, LVisited, LStart.X, LStart.Y, LFrontier);

    while LFrontier.Count > 0 do begin
      var LEdgeIndex := Random(LFrontier.Count);
      var LEdge := LFrontier[LEdgeIndex];

      var LToIndex := IndexOfCell(AWidth, LEdge.ToX, LEdge.ToY);
      if LVisited[LToIndex] then begin
        LFrontier.Delete(LEdgeIndex);
        Continue;
      end;

      var LFromIndex := IndexOfCell(AWidth, LEdge.FromX, LEdge.FromY);
      KnockDownWall(Result[LFromIndex], Result[LToIndex], LEdge.Direction);

      LVisited[LToIndex] := True;
      AddFrontierEdges(AWidth, AHeight, LVisited, LEdge.ToX, LEdge.ToY, LFrontier);

      LFrontier.Delete(LEdgeIndex);
    end;
  finally
    LFrontier.Free;
  end;
end;

function TMazePrimGenerator.GetDisplayName: string;
begin
  Result := 'Prim''s Algorithm';
end;

function TMazePrimGenerator.IndexOfCell(const AWidth, AX, AY: Integer): Integer;
begin
  Result := (AY * AWidth) + AX;
end;

procedure TMazePrimGenerator.KnockDownWall(var ACurrent, ANeighbor: TMazeCell; const ADirection: TMazeDirection);
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
