object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Import Track'
  ClientHeight = 359
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 263
    Width = 689
    Height = 89
    ColCount = 4
    DefaultColWidth = 120
    DefaultRowHeight = 16
    FixedCols = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowMoving, goColMoving, goEditing, goThumbTracking]
    ParentFont = False
    TabOrder = 0
    ColWidths = (
      120
      120
      120
      120)
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 257
    Height = 249
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1044#1072#1090#1091#1084#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ComboBox1: TComboBox
        Left = 3
        Top = 5
        Width = 243
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
      end
      object RadioGroup2: TRadioGroup
        Left = 4
        Top = 33
        Width = 240
        Height = 180
        Caption = #1058#1080#1087' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
        ItemIndex = 0
        Items.Strings = (
          #1064#1080#1088#1086#1090#1072'/'#1044#1086#1083#1075#1086#1090#1072
          #1055#1088#1086#1089#1090#1088#1072#1085#1089#1090#1074#1077#1085#1085#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
          #1055#1088#1086#1077#1082#1094#1080#1103' '#1043#1072#1091#1089#1089#1072'-'#1050#1088#1102#1075#1077#1088#1072
          #1055#1088#1086#1077#1082#1094#1080#1103' UTM (WGS84/NAD83) - '#1057#1077#1074#1077#1088
          #1055#1088#1086#1077#1082#1094#1080#1103' UTM (WGS84/NAD83) - '#1070#1075)
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      ImageIndex = 1
      object ComboBox2: TComboBox
        Left = 3
        Top = 5
        Width = 243
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
      end
      object ListBox4: TListBox
        Left = 3
        Top = 33
        Width = 243
        Height = 185
        Hint = '111'
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 272
    Top = 8
    Width = 425
    Height = 249
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1086#1088#1084#1072#1090#1072
    TabOrder = 2
    object Label1: TLabel
      Left = 64
      Top = 120
      Width = 93
      Height = 13
      Caption = #1053#1072#1095#1072#1090#1100' '#1089#1086' '#1089#1090#1088#1086#1082#1080':'
    end
    object RSpacer: TRadioGroup
      Left = 8
      Top = 16
      Width = 225
      Height = 97
      Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1080
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #1055#1088#1086#1073#1077#1083#1099
        'Tab'
        #1044#1088#1091#1075#1080#1077
        ';'
        ',')
      TabOrder = 2
    end
    object Spacer: TEdit
      Left = 88
      Top = 85
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object ValueList: TValueListEditor
      Left = 8
      Top = 144
      Width = 225
      Height = 97
      DefaultColWidth = 120
      FixedCols = 1
      GridLineWidth = 0
      KeyOptions = [keyEdit, keyAdd, keyUnique]
      Strings.Strings = (
        #1048#1084#1103'=1'
        'X=2'
        'Y=3'
        'Z=4')
      TabOrder = 1
      TitleCaptions.Strings = (
        #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
        #1050#1086#1083#1086#1085#1082#1072)
      ColWidths = (
        120
        99)
      RowHeights = (
        18
        18
        18
        18
        18)
    end
    object SpinEdit1: TSpinEdit
      Left = 168
      Top = 116
      Width = 65
      Height = 22
      MaxValue = 100000
      MinValue = 1
      TabOrder = 3
      Value = 1
    end
    object RoutesBE: TRadioGroup
      Left = 239
      Top = 16
      Width = 175
      Height = 122
      Caption = #1053#1072#1095#1072#1083#1086'/'#1082#1086#1085#1077#1094' '#1084#1072#1088#1096#1088#1091#1090#1072
      ItemIndex = 2
      Items.Strings = (
        #1042' '#1086#1076#1085#1086#1081' '#1089#1090#1088#1086#1082#1077
        #1063#1077#1090#1085#1099#1077'/'#1085#1077#1095#1077#1090#1085#1099#1077' '#1089#1090#1088#1086#1082#1080
        #1052#1077#1090#1082#1072' a, b '#1074' '#1080#1084#1077#1085#1080
        #1054#1073#1097#1077#1077' '#1080#1084#1103)
      TabOrder = 4
    end
    object ValueList2: TValueListEditor
      Left = 239
      Top = 144
      Width = 183
      Height = 97
      DefaultColWidth = 120
      FixedCols = 1
      GridLineWidth = 0
      KeyOptions = [keyEdit, keyAdd, keyUnique]
      Strings.Strings = (
        'X=5'
        'Y=6'
        'Z=7')
      TabOrder = 5
      TitleCaptions.Strings = (
        #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
        #1050#1086#1083#1086#1085#1082#1072)
      Visible = False
      ColWidths = (
        120
        57)
      RowHeights = (
        18
        18
        18
        18)
    end
  end
end
