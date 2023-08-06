object FProcSet: TFProcSet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Processor Settings'
  ClientHeight = 202
  ClientWidth = 446
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 119
    Height = 13
    Caption = 'Path to Vector Processor'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 106
    Height = 13
    Caption = 'Path to PPP Processor'
  end
  object SpeedButton1: TSpeedButton
    Left = 415
    Top = 23
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDDDDDDDDDDDDDDDDD0000000000000DD77777777777700DD7FB8B8B8B8
      B700D7FB8B8B8B8B8070D7F8B8B8B8B870707F8B8B8B8B8B07707FFFFFFFFFF7
      08707777777777777B70D7F8B8B8B8B8B870D7FB8B8B8FFFFF70D7F8B8B8F777
      777DDD7FFFFF7DDDDDDDDDD77777DDDDDDDDDDDDDDDDDDDDDDDD}
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 416
    Top = 72
    Width = 23
    Height = 22
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDDDDDDDDDDDDDDDDD0000000000000DD77777777777700DD7FB8B8B8B8
      B700D7FB8B8B8B8B8070D7F8B8B8B8B870707F8B8B8B8B8B07707FFFFFFFFFF7
      08707777777777777B70D7F8B8B8B8B8B870D7FB8B8B8FFFFF70D7F8B8B8F777
      777DDD7FFFFF7DDDDDDDDDD77777DDDDDDDDDDDDDDDDDDDDDDDD}
    OnClick = SpeedButton2Click
  end
  object Button1: TButton
    Left = 216
    Top = 168
    Width = 105
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 327
    Top = 168
    Width = 112
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 401
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 72
    Width = 401
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object OpenDialog1: TOpenDialog
    Left = 256
    Top = 104
  end
end
