object CSFormNew: TCSFormNew
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Add Coordinate System To Project'
  ClientHeight = 265
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 506
    Height = 265
    Shape = bsSpacer
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 8
    Width = 490
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    OnChange = ComboBox2Change
  end
  object ListBox4: TListBox
    Left = 8
    Top = 36
    Width = 490
    Height = 185
    Style = lbOwnerDrawFixed
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnDblClick = Button1Click
    OnDrawItem = ListBox4DrawItem
    OnMouseMove = ListBox4MouseMove
  end
  object Button1: TButton
    Left = 160
    Top = 232
    Width = 201
    Height = 25
    Caption = 'Choose'
    TabOrder = 2
    OnClick = Button1Click
  end
end
