class ModifiedKeyActionType < KeyPressActionType
  acts_as_citier

  attr_accessible :metakeys

  validates :metakeys, :numericality => {:less_than => 0x8}

  CtrlMod = 0x1
  MetaMod = 0x2
  AltMod = 0x4

  def describe
    modifiers = ""
    if (CtrlMod & self.metakeys) != 0
      modifiers += "ctrl + "
    end
    if (AltMod & self.metakeys) != 0
      modifiers += "alt + "
    end
    if (MetaMod & self.metakeys) != 0
      modifiers += "meta + "
    end

    modifiers + "'#{self.keys}'"    
  end

  def self.make_metakeys_value(ctrl, meta, alt)
    ret = 0
    ret |= CtrlMod if ctrl
    ret |= MetaMod if meta
    ret |= AltMod if alt
    ret
  end

  def self.my_name
    "ModifiedKey"
  end
  def make_arguments
    ret = super.make_arguments
    ret <<
      Argument.new("metakeys", "Metakeys", self.metakeys || 0)
    
    ret
  end
end
