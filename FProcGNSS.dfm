object ProcGNSS: TProcGNSS
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'GNSS Processor'
  ClientHeight = 226
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPan: TPanel
    Left = 0
    Top = 0
    Width = 328
    Height = 53
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object StatusLabel: TLabel
      Left = 9
      Top = 6
      Width = 3
      Height = 13
    end
    object Progress: TProgressBar
      Left = 10
      Top = 23
      Width = 315
      Height = 14
      Margins.Left = 30
      Margins.Bottom = 30
      Smooth = True
      TabOrder = 0
    end
  end
  object MemoPan: TPanel
    Left = 0
    Top = 53
    Width = 457
    Height = 173
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object MemoSubPan1: TPanel
      Left = 0
      Top = 33
      Width = 457
      Height = 140
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Memo: TMemo
        Left = 0
        Top = 0
        Width = 457
        Height = 140
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = MemoChange
      end
    end
    object MemoSubPan2: TPanel
      Left = 0
      Top = 0
      Width = 457
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object MessagesLabel: TLabel
        Left = 9
        Top = 11
        Width = 51
        Height = 13
        Caption = 'Messages:'
      end
    end
  end
  object ButtonsPan: TPanel
    Left = 328
    Top = 0
    Width = 129
    Height = 53
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object StopBtn: TSpeedButton
      Left = 12
      Top = 14
      Width = 81
      Height = 25
      Caption = 'STOP'
      OnClick = StopBtnClick
    end
    object ShowMemo: TSpeedButton
      Left = 96
      Top = 14
      Width = 25
      Height = 25
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD70DDDDDDDDDDDDD7F0DDDDDDDDDDDD7FF0
        DDDDDD870000FFF078DDDD7FFFFFFFFFF7DDDD0F7777777FF0DDDD0FFFFFFFFF
        F0DDDD0F77777FFFF0DDDD0FFFFFFFFFF0DDDD0F77777777F0DDDD7FFFFFFFFF
        F7DDDD870000000078DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
      OnClick = ShowMemoClick
    end
  end
end
