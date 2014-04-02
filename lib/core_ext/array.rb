module RLP
  module Extensions
    module Array
      def to_rlp
        return [0xc0] if self == []

        result = self.collect do |item|
          rlp = item.to_rlp
          if rlp.is_a?(Array)
            rlp.to_a.collect{|x| x.chr}
          else
            rlp.chr
          end
        end.flatten

        result = result.join.to_rlp(true)
        return result
      end

      def reverse_bytes
        bytes = self.collect do |item|
          item.chr
        end
        (8 - bytes.length).times do
          bytes.insert(0, 0.chr)
        end
        bytes.join.unpack("q>").first
      end
    end
  end
end

Array.send(:include, RLP::Extensions::Array)
