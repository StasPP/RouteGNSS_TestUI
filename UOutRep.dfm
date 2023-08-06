object OutRep: TOutRep
  Left = 0
  Top = 0
  Caption = 'Output Report'
  ClientHeight = 321
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 285
    Width = 581
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -202
    ExplicitTop = 165
    ExplicitWidth = 649
    object Panel4: TPanel
      Left = 327
      Top = 0
      Width = 254
      Height = 36
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 192
      ExplicitTop = 1
      ExplicitHeight = 34
      object Button6: TButton
        Left = 6
        Top = 3
        Width = 115
        Height = 27
        Caption = 'Output'
        TabOrder = 0
      end
      object Button1: TButton
        Left = 127
        Top = 3
        Width = 121
        Height = 27
        Caption = 'Close'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -202
    ExplicitTop = 165
    ExplicitWidth = 649
  end
  object ListBox1: TListBox
    Left = 0
    Top = 36
    Width = 333
    Height = 249
    Align = alClient
    ItemHeight = 13
    TabOrder = 2
    ExplicitLeft = 120
    ExplicitTop = 8
    ExplicitWidth = 121
    ExplicitHeight = 97
  end
  object PageControl1: TPageControl
    Left = 333
    Top = 36
    Width = 248
    Height = 249
    ActivePage = TabSheet3
    Align = alRight
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
  end
  object ImageList1: TImageList
    Left = 344
    Top = 24
  end
end
