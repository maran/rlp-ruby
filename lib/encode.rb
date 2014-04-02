module RLP
  module Encode;
    def to_rlp(is_array = false)
      return [0x80] if self == ""

      length = self.bytes.to_a.length

      offset = [0x80, 0xb7]
      offset = [0xc0, 0xf7] if is_array

      if length == 1 && !is_array && self.bytes.first <= 0x7f
        return [self.bytes.first]
      elsif length <= 55
        return [(offset[0]+length), *self.bytes]
      elsif length > 55
        return [(offset[1]+length.bytesize),*length.bytes, *self.bytes]
      end
    end
  end
end
