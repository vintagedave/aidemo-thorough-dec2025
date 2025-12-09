object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Maze Viewer'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pbMaze: TPaintBox
    Left = 0
    Top = 48
    Width = 624
    Height = 393
    OnPaint = pbMazePaint
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 48
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object btnShowSettings: TButton
      Left = 16
      Top = 10
      Width = 113
      Height = 25
      Caption = 'Show &Settings'
      TabOrder = 0
      OnClick = btnShowSettingsClick
    end
    object btnRegenerateMaze: TButton
      Left = 137
      Top = 10
      Width = 145
      Height = 25
      Caption = '&Regenerate Maze'
      TabOrder = 1
      OnClick = btnRegenerateMazeClick
    end
  end
end
