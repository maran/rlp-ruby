module RLP
  module Extensions
    module Fixnum
      include RLP::Encode

      def as_int
        return self
      end

      def as_string
        return self.chr
      end

      def bytesize
        self.bytes.length
      end

      # This makes sure for isntance 1024 becomes [0,0,0,0,0,0,4,0] and in turn [4,0]
      def bytes
        [self].pack("q>").bytes.to_a.drop_while{|x| x == 0}
      end
    end
  end
end

Fixnum.send(:include, RLP::Extensions::Fixnum)
