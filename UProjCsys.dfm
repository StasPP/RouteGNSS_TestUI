object FProjCsys: TFProjCsys
  Left = 0
  Top = 0
  Caption = 'Coordinate/Height Systems for the Project'
  ClientHeight = 225
  ClientWidth = 528
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 188
    Width = 528
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 223
      Top = 0
      Width = 305
      Height = 37
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object CfgButton: TSpeedButton
        Left = 8
        Top = 6
        Width = 162
        Height = 25
        Caption = 'Configure Database'
        Glyph.Data = {
          26040000424D2604000000000000360000002800000012000000120000000100
          180000000000F0030000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D5D5D5454544C4C4CFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF4B4B4B676767565656FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF4B4B4B7C7C7CFFFFFFFFFFFF6D
          6D6D7575756A6A6AFFFFFFFFFFFFFFFFFF5C5C5C4B4B4BFFFFFFFFFFFFFFFFFF
          0000FFFFFFFFFFFF4B4B4B9090908585855252528080808C8C8C8383837A7A7A
          6C6C6C5858585151515050504848484B4B4BFFFFFFFFFFFF0000FFFFFFFFFFFF
          535353929292ABABABA6A6A69E9E9E9797978C8C8C8585857E7E7E7474746A6A
          6A606060535353686868FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF4B4B4B9F9F
          9FAAAAAA9A9A9A7171715353534E4E4E7676768282827878786F6F6F4B4B4BFF
          FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF585858959595A2A2A2616161AD
          ADADB2B2B2B1B1B18383837979798585857C7C7C4B4B4BFFFFFFFFFFFFFFFFFF
          00004B4B4B6F6F6F6C6C6C909090939393585858C6C6C6888888525252616161
          AEAEAE8383837B7B7B8989897A7A7A5757578686864B4B4B00005B5B5B696969
          7B7B7B848484767676888888AAAAAA747474A4A4A49E9E9E575757ADADAD4E4E
          4E9494948D8D8D8080806B6B6B5A5A5A00005858586363636D6D6D7777776969
          69959595969696787878A0A0A0A4A4A44E4E4EADADAD5353539A9A9A98989890
          90908686866F6F6F00005353535050505C5C5C6969696B6B6B6E6E6EC8C8C858
          5858757575717171898989ABABAB777777A7A7A7A2A2A27C7C7C4D4D4D6C6C6C
          0000FFFFFFFFFFFFFFFFFF5B5B5B6565655F5F5F969696CACACA999999ACACAC
          C5C5C56262629B9B9BABABAB8F8F8FFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
          FFFFFF4C4C4C5656566161615C5C5C6C6C6C9292928181815555558383839E9E
          9EA4A4A47C7C7CFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF5757574040404848
          485252525C5C5C6161616060606C6C6C7F7F7F8C8C8C9494949B9B9B9D9D9D53
          5353FFFFFFFFFFFF0000FFFFFFFFFFFF3333333030303B3B3B4444444D4D4D58
          58586262626C6C6C7575757B7B7B6F6F6F828282989898808080FFFFFFFFFFFF
          0000FFFFFFFFFFFFFFFFFF323232595959FFFFFFFFFFFF4949495353535D5D5D
          FFFFFFFFFFFFFFFFFF6D6D6D676767FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4343434545454F4F4FFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF4B4B4B3A3A3A454545FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF0000}
        OnClick = CfgButtonClick
      end
      object AcceptButton: TSpeedButton
        Left = 176
        Top = 6
        Width = 121
        Height = 25
        Caption = 'Accept'
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          20000000000000040000120B0000120B00000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008FC996006DB97600FEFFFE00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF008FCB960000881000008810006FBC7800FEFF
          FE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF008FCD9600018E1200008E1100008E1100008E110072C1
          7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF0090D1980001961300009612000096120000961200009612000196
          13009AD5A100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF0091D69900019F1400009F1300009F1300009F1300009F1300009F1300009F
          1300019F14009BD9A200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0092DA
          9B0001A9150000A9140000A9140000A9140005AB190003AA170000A9140000A9
          140000A9140001A915009CDEA400FFFFFF00FFFFFF00FFFFFF00FFFFFF006AD3
          760000B4150000B4150000B4150005B51A00ABE6B200A3E4AB0003B5180000B4
          150000B4150000B4150001B416009DE2A500FFFFFF00FFFFFF00FFFFFF00FEFF
          FE0067D9750000BF170004C01B00ABEAB300FFFFFF00FFFFFF00A3E8AB0003C0
          1A0000BF170000BF170000BF170001BF18009DE6A600FFFFFF00FFFFFF00FFFF
          FF00FEFFFE006AE07800ABEEB300FFFFFF00FFFFFF00FFFFFF00FFFFFF00A2EC
          AB0003CB1B0000CA180000CA180000CA180002CA1A009DEBA600FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00A1F0AA0003D51C0000D5190000D5190000D5190060E57000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00A1F3AB0003DF1D0000DF1A005DEB6E00FCFFFC00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00A0F7AA005FF17100FCFFFC00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        OnClick = AcceptButtonClick
      end
    end
  end
  object Panel4: TPanel
    Left = 9
    Top = 0
    Width = 510
    Height = 188
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 510
      Height = 16
      Align = alTop
      AutoSize = False
      Caption = 'Coordinate systems:'
      Layout = tlBottom
      ExplicitWidth = 429
    end
    object CSBox: TListBox
      Left = 0
      Top = 16
      Width = 477
      Height = 134
      Style = lbOwnerDrawFixed
      Align = alClient
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 0
      OnClick = CSBoxClick
      OnDrawItem = CSBoxDrawItem
    end
    object Panel5: TPanel
      Left = 0
      Top = 150
      Width = 510
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 510
        Height = 15
        Align = alTop
        AutoSize = False
        Caption = 'Geoid Model:'
        Layout = tlBottom
        ExplicitWidth = 429
      end
      object GeoidBox: TComboBox
        Left = 0
        Top = 16
        Width = 510
        Height = 22
        Align = alBottom
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDrawItem = GeoidBoxDrawItem
      end
    end
    object Panel1: TPanel
      Left = 477
      Top = 16
      Width = 33
      Height = 134
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object AddButton: TSpeedButton
        Left = 4
        Top = -1
        Width = 26
        Height = 26
        Hint = 'Add'
        Glyph.Data = {
          42010000424D4201000000000000760000002800000015000000110000000100
          040000000000CC00000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDDD000DDDDDDDDDDDDD000DDDDD000DDDDDDDDDDDDD0A0DDDDD000DDDD
          DDDDDDDDD0A0DDDDD000DDDDDDDDDDDDD0A0DDDDD000DDDDD000D00000A00000
          D000DDDDD0A0D0AAAAAAAAA0D000DDDDD0A0D00000A00000D000DDDDD0A0DDDD
          D0A0DDDDD000D00000A00000D0A0DDDDD000D0AAAAAAAAA0D0A0DDDDD000D000
          00A00000D000DDDDD000DDDDD0A0DDDDDDDDDDDDD000DDDDD0A0DDDDDDDDDDDD
          D000DDDDD0A0DDDDDDDDDDDDD000DDDDD000DDDDDDDDDDDDD000DDDDDDDDDDDD
          DDDDDDDDD000}
        OnClick = AddButtonClick
      end
      object DelSBtn: TSpeedButton
        Left = 4
        Top = 28
        Width = 26
        Height = 26
        Hint = 'Remove'
        Enabled = False
        Glyph.Data = {
          EE000000424DEE0000000000000076000000280000000F0000000F0000000100
          0400000000007800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF0FFF0FFFFFFF1FFF0FF091FFFFF091FF0F09991FFF09991F0FF19991F0999
          1FF0FFF199919991FFF0FFFF1999991FFFF0FFFFF99991FFFFF0FFFF0999991F
          FFF0FFF099919991FFF0FF09991F19991FF0F09991FFF19991F0FF191FFFFF19
          1FF0FFF1FFFFFFF1FFF0FFFFFFFFFFFFFFF0}
        OnClick = DelSBtnClick
      end
    end
  end
  object Panel6: TPanel
    Left = 519
    Top = 0
    Width = 9
    Height = 188
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 9
    Height = 188
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
end
