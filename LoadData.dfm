object LoadRData: TLoadRData
  Left = 596
  Top = 225
  BorderStyle = bsToolWindow
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1082#1088#1099#1074#1072#1077#1084#1086#1075#1086' '#1092#1072#1081#1083#1072
  ClientHeight = 415
  ClientWidth = 703
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 264
    Width = 339
    Height = 13
    Caption = #1060#1088#1072#1075#1084#1077#1085#1090' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1092#1072#1081#1083#1072' '#1087#1088#1080' '#1079#1072#1076#1072#1085#1085#1099#1093' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1093
  end
  object Button1: TButton
    Left = 360
    Top = 382
    Width = 175
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 542
    Top = 382
    Width = 153
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 280
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
    TabOrder = 2
    ColWidths = (
      120
      120
      120
      120)
  end
  object GroupBox2: TGroupBox
    Left = 272
    Top = 8
    Width = 425
    Height = 249
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1086#1088#1084#1072#1090#1072
    TabOrder = 3
    object Label1: TLabel
      Left = 64
      Top = 120
      Width = 92
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
      OnClick = RSpacerClick
    end
    object Spacer: TEdit
      Left = 88
      Top = 85
      Width = 41
      Height = 21
      Enabled = False
      MaxLength = 1
      TabOrder = 0
      OnChange = SpacerChange
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
      OnClick = ValueListClick
      OnKeyUp = ValueListKeyUp
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
      OnChange = RSpacerClick
    end
    object PC2: TPageControl
      Left = 237
      Top = 7
      Width = 186
      Height = 238
      ActivePage = TabSheet4
      Style = tsButtons
      TabOrder = 4
      object TabSheet3: TTabSheet
        Caption = 'TabSheet3'
        TabVisible = False
        object RoutesBE: TRadioGroup
          Left = 0
          Top = 3
          Width = 175
          Height = 122
          Caption = #1053#1072#1095#1072#1083#1086'/'#1082#1086#1085#1077#1094' '#1084#1072#1088#1096#1088#1091#1090#1072
          ItemIndex = 2
          Items.Strings = (
            #1042' '#1086#1076#1085#1086#1081' '#1089#1090#1088#1086#1082#1077
            #1063#1077#1090#1085#1099#1077'/'#1085#1077#1095#1077#1090#1085#1099#1077' '#1089#1090#1088#1086#1082#1080
            #1052#1077#1090#1082#1072' a, b '#1074' '#1080#1084#1077#1085#1080
            #1054#1073#1097#1077#1077' '#1080#1084#1103)
          TabOrder = 0
          OnClick = RoutesBEClick
        end
        object ValueList2: TValueListEditor
          Left = 0
          Top = 131
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
          TabOrder = 1
          TitleCaptions.Strings = (
            #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
            #1050#1086#1083#1086#1085#1082#1072)
          Visible = False
          OnClick = ValueList2Click
          OnKeyUp = ValueListKeyUp
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
      object TabSheet4: TTabSheet
        Caption = 'TabSheet4'
        ImageIndex = 1
        TabVisible = False
        object HgtTabIs: TRadioGroup
          Left = 3
          Top = 3
          Width = 172
          Height = 122
          Caption = #1042#1099#1089#1086#1090#1072
          ItemIndex = 0
          Items.Strings = (
            #1053#1077#1090
            #1054#1088#1090#1086#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103
            #1069#1083#1083#1080#1087#1089#1086#1080#1076)
          TabOrder = 1
          OnClick = HgtTabIsClick
        end
        object HgtTab: TSpinEdit
          Left = 119
          Top = 92
          Width = 47
          Height = 22
          MaxValue = 100000
          MinValue = 1
          TabOrder = 0
          Value = 4
          Visible = False
          OnChange = RSpacerClick
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 257
    Height = 249
    ActivePage = TabSheet1
    TabOrder = 4
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = #1044#1072#1090#1091#1084#1099
      object ComboBox1: TComboBox
        Left = 3
        Top = 5
        Width = 243
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        OnChange = ComboBox1Change
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
        OnClick = RadioGroup2Click
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
        OnChange = ComboBox2Change
      end
      object ListBox4: TListBox
        Left = 3
        Top = 33
        Width = 243
        Height = 185
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ListBox4Click
        OnMouseMove = ListBox4MouseMove
      end
    end
  end
  object Panel1: TPanel
    Left = 1
    Top = 375
    Width = 268
    Height = 39
    BevelOuter = bvNone
    TabOrder = 5
    object OTSave: TSpeedButton
      Left = 210
      Top = 8
      Width = 25
      Height = 24
      Flat = True
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D70000000000
        0000D033000000770300D033000000770300D033000000770300D03300000000
        0300D033333333333300D033000000003300D030777777770300D03077777777
        0300D030777777770300D030777777770300D030777777770000D03077777777
        0700D000000000000000DDDDDDDDDDDDDDD0}
      ParentShowHint = False
      ShowHint = True
      OnClick = OTSaveClick
    end
    object OTDel: TSpeedButton
      Left = 237
      Top = 8
      Width = 25
      Height = 24
      Flat = True
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFF0FFF0FFFFFFF1FFF0FF091FFFFF091FF0F09991FFF09991F0FF19991F0999
        1FF0FFF199919991FFF0FFFF1999991FFFF0FFFFF99991FFFFF0FFFF0999991F
        FFF0FFF099919991FFF0FF09991F19991FF0F09991FFF19991F0FF191FFFFF19
        1FF0FFF1FFFFFFF1FFF0FFFFFFFFFFFFFFF0}
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = OTDelClick
    end
    object OpTmp: TComboBox
      Left = 7
      Top = 9
      Width = 201
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      OnChange = OpTmpChange
    end
  end
  object Panel2: TPanel
    Left = 675
    Top = 282
    Width = 20
    Height = 20
    BevelOuter = bvNone
    TabOrder = 6
    object CheckGlobe: TSpeedButton
      Left = 0
      Top = 0
      Width = 20
      Height = 20
      Align = alClient
      Caption = '?'
      ParentShowHint = False
      ShowHint = True
      OnClick = CheckGlobeClick
      ExplicitLeft = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
end
