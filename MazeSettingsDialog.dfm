object frmMazeSettings: TfrmMazeSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Maze Settings'
  ClientHeight = 160
  ClientWidth = 420
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    420
    160)
  TextHeight = 15
  object lblAlgorithm: TLabel
    Left = 20
    Top = 24
    Width = 146
    Height = 15
    Caption = '&Maze generation algorithm:'
    FocusControl = cbAlgorithm
  end
  object pnlButtons: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 119
    Width = 420
    Height = 41
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      420
      41)
    object btnOK: TButton
      Left = 244
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 325
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cbAlgorithm: TComboBox
    Left = 20
    Top = 47
    Width = 380
    Height = 23
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
end
