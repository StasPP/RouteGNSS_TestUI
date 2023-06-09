object FAntProp: TFAntProp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Antenna Properties'
  ClientHeight = 375
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label8: TLabel
    Left = 8
    Top = 53
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object NameEd: TEdit
    Left = 8
    Top = 23
    Width = 153
    Height = 21
    MaxLength = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 96
    Top = 339
    Width = 176
    Height = 25
    Caption = 'Accept'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 100
    Width = 211
    Height = 233
    Caption = 'L1 phase center'
    TabOrder = 2
    object Label18: TLabel
      Left = 10
      Top = 79
      Width = 53
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dU, mm:'
    end
    object Label17: TLabel
      Left = 19
      Top = 52
      Width = 44
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dE, mm:'
    end
    object Label16: TLabel
      Left = 18
      Top = 25
      Width = 45
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dN, mm:'
    end
    object Label5: TLabel
      Left = 13
      Top = 107
      Width = 117
      Height = 13
      Caption = 'Phase center variations:'
    end
    object EAntU: TEdit
      Left = 67
      Top = 76
      Width = 86
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object EAntE: TEdit
      Left = 67
      Top = 49
      Width = 86
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object EAntN: TEdit
      Left = 67
      Top = 22
      Width = 86
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object VBL1: TValueListEditor
      Left = 13
      Top = 126
      Width = 180
      Height = 98
      DefaultColWidth = 50
      FixedCols = 1
      ScrollBars = ssVertical
      Strings.Strings = (
        '90=0.000'
        '85=0.000'
        '80=0.000'
        '75=0.000'
        '70=0.000'
        '65=0.000'
        '60=0.000'
        '55=0.000'
        '50=0.000'
        '45=0.000'
        '40=0.000'
        '35=0.000'
        '30=0.000'
        '25=0.000'
        '20=0.000'
        '15=0.000'
        '10=0.000'
        '5=0.000'
        '0=0.000')
      TabOrder = 3
      TitleCaptions.Strings = (
        'Angle, '#176
        'Value, mm')
      ColWidths = (
        50
        107)
    end
  end
  object GroupBox2: TGroupBox
    Left = 228
    Top = 100
    Width = 209
    Height = 233
    Caption = 'L2 phase center'
    TabOrder = 3
    object Label2: TLabel
      Left = 10
      Top = 79
      Width = 53
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dU, mm:'
    end
    object Label3: TLabel
      Left = 19
      Top = 52
      Width = 44
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dE, mm:'
    end
    object Label4: TLabel
      Left = 18
      Top = 25
      Width = 45
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'dN, mm:'
    end
    object Label6: TLabel
      Left = 13
      Top = 107
      Width = 117
      Height = 13
      Caption = 'Phase center variations:'
    end
    object EAntU2: TEdit
      Left = 67
      Top = 76
      Width = 86
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object EAntE2: TEdit
      Left = 67
      Top = 49
      Width = 86
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object EAntN2: TEdit
      Left = 67
      Top = 22
      Width = 86
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object VBL2: TValueListEditor
      Left = 13
      Top = 126
      Width = 180
      Height = 98
      DefaultColWidth = 50
      FixedCols = 1
      ScrollBars = ssVertical
      Strings.Strings = (
        '90=0.000'
        '85=0.000'
        '80=0.000'
        '75=0.000'
        '70=0.000'
        '65=0.000'
        '60=0.000'
        '55=0.000'
        '50=0.000'
        '45=0.000'
        '40=0.000'
        '35=0.000'
        '30=0.000'
        '25=0.000'
        '20=0.000'
        '15=0.000'
        '10=0.000'
        '5=0.000'
        '0=0.000')
      TabOrder = 3
      TitleCaptions.Strings = (
        'Angle, '#176
        'Value, mm')
      ColWidths = (
        50
        107)
    end
  end
  object Button2: TButton
    Left = 278
    Top = 339
    Width = 159
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button2Click
  end
  object EDiscr: TEdit
    Left = 8
    Top = 69
    Width = 211
    Height = 21
    MaxLength = 40
    TabOrder = 5
  end
  object GroupBox3: TGroupBox
    Left = 228
    Top = 8
    Width = 209
    Height = 89
    Caption = 'Construction'
    TabOrder = 6
    object Label7: TLabel
      Left = 16
      Top = 17
      Width = 113
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Antenna Radius, mm:'
    end
    object Label9: TLabel
      Left = 10
      Top = 42
      Width = 119
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Measuring Point*, mm:'
    end
    object Label10: TLabel
      Left = 12
      Top = 65
      Width = 175
      Height = 13
      Caption = '*from the Antenna Refference Point'
    end
    object EdRad: TEdit
      Left = 135
      Top = 14
      Width = 63
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object EGrPl: TEdit
      Left = 135
      Top = 39
      Width = 63
      Height = 21
      TabOrder = 1
      Text = '0'
    end
  end
end
