require 'helper'
class TestRlpRuby < Test::Unit::TestCase
  context "decoding raw rlp values" do
    should "decode simple byte arrays" do
      assert_equal [[100,111,103],4], RLP.decode([131, 100, 111, 103],0)
    end

    should "decode array to a byte arrays" do
      assert_equal [[99, [99, 97, 116], [100, 111, 103]], 10], RLP.decode([201, 99, 131, 99, 97, 116, 131, 100, 111, 103],0)
      assert_equal [[[100, 111, 103], 15, [[99, 97, 116], [99, 97, 116], []], [4, 0], [116, 97, 99, 104, 105, 107, 111, 109, 97]], 29], RLP.decode([220,131, 100, 111, 103, 15, 201, 131, 99, 97, 116, 131, 99, 97, 116, 192, 130, 4, 0, 137, 116, 97, 99, 104, 105, 107, 111, 109, 97],0)
    end

    should "decode > 55 byte arrays" do
      assert_equal [[[116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 32, 108, 105, 115, 116],[121, 111, 117, 32, 110, 101, 118, 101, 114, 32, 103, 117, 101, 115, 115, 32, 104, 111, 119, 32, 108, 111, 110, 103, 32, 105, 116, 32, 105, 115],[105, 110, 100, 101, 101, 100, 44, 32, 104, 111, 119, 32, 100, 105, 100, 32, 121, 111, 117, 32, 107, 110, 111, 119, 32, 105, 116, 32, 119, 97, 115, 32, 116, 104, 105, 115, 32, 108, 111, 110, 103],[103, 111, 111, 100, 32, 106, 111, 98, 44, 32, 116, 104, 97, 116, 32, 73, 32, 99, 97, 110, 32, 116, 101, 108, 108, 32, 121, 111, 117, 32, 105, 110, 32, 104, 111, 110, 101, 115, 116, 108, 121, 121, 121, 121, 121]], 146], RLP.decode([248, 144, 152, 116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 32, 108, 105, 115, 116, 158, 121, 111, 117, 32, 110, 101, 118, 101, 114, 32, 103, 117, 101, 115, 115, 32, 104, 111, 119, 32, 108, 111, 110, 103, 32, 105, 116, 32, 105, 115, 169, 105, 110, 100, 101, 101, 100, 44, 32, 104, 111, 119, 32, 100, 105, 100, 32, 121, 111, 117, 32, 107, 110, 111, 119, 32, 105, 116, 32, 119, 97, 115, 32, 116, 104, 105, 115, 32, 108, 111, 110, 103, 173, 103, 111, 111, 100, 32, 106, 111, 98, 44, 32, 116, 104, 97, 116, 32, 73, 32, 99, 97, 110, 32, 116, 101, 108, 108, 32, 121, 111, 117, 32, 105, 110, 32, 104, 111, 110, 101, 115, 116, 108, 121, 121, 121, 121, 121],0)
    end
  end

  context "decoding to primatives" do
    should "decode back to a string" do
        ba = RLP.decoder([131, 100, 111, 103])
        assert_equal "dog", ba.as_string
    end

    should "decode back to a character" do
        ba = RLP.decoder([99])
        assert_equal "c", ba.as_string
    end

    should "decode back to a small int" do
      ba = RLP.decoder([15])
      assert_equal 15, ba.as_int
    end

    should "decode back to a large int" do
      ba = RLP.decoder([0x82, 0x04, 0x00])
      assert_equal 1024, ba.as_int
    end

    should "decode a 1-dimensional list" do
      ba = RLP.decoder([201, 99, 131, 99, 97, 116, 131, 100, 111, 103])
      assert_equal "c", ba.get(0).as_string
      assert_equal "cat", ba.get(1).as_string
      assert_equal "dog", ba.get(2).as_string
    end

    should "decode a very long list" do
      ba = RLP.decoder(["this is a very long list", "you never guess how long it is", "indeed, how did you know it was this long", "good job, that I can tell you in honestlyyyyy"].to_rlp)

      assert_equal "this is a very long list", ba.get(0).as_string
      assert_equal "you never guess how long it is", ba.get(1).as_string
      assert_equal "indeed, how did you know it was this long", ba.get(2).as_string
    end

    should "decode mixed byte arrays" do
      ba = RLP.decoder(["dog", 15, ["cat", "cat", []], 1024, "tachikoma"].to_rlp)
      assert_equal "dog", ba.get(0).as_string
      assert_equal 15, ba.get(1).as_int
      assert_equal "cat", ba.get(2).get(0).as_string
      assert_equal [], ba.get(2).get(2)
      assert_equal 1024, ba.get(3).as_int
      assert_equal "tachikoma", ba.get(4).as_string
    end
  end

  context "encoding rlp values" do
    should "encode short (<56 bytes) strings" do
      assert_equal "dog".to_rlp, [131, 100, 111, 103]
      assert_equal "cat".to_rlp, [131, 99, 97, 116]
    end

    should "encode long (>55 bytes) strings" do
      assert_equal "Lorem ipsum dolor sit amet, consectetur adipisicing elit".to_rlp, [184, 0x38, 76, 111, 114, 101, 109, 32, 105, 112, 115, 117, 109, 32, 100, 111, 108, 111, 114, 32, 115, 105, 116, 32, 97, 109, 101, 116, 44, 32, 99, 111, 110, 115, 101, 99, 116, 101, 116, 117, 114, 32, 97, 100, 105, 112, 105, 115, 105, 99, 105, 110, 103, 32, 101, 108, 105, 116]
    end

    should "encode simple characters" do
      assert_equal "d".to_rlp, [100]
    end

    should "encode short arrays" do
      assert_equal [ [], [[]], [ [], [[]] ] ].to_rlp,[199, 192, 193, 192, 195, 192, 193, 192]
      assert_equal ["cat", "dog"].to_rlp, [200, 131, 99, 97, 116, 131, 100, 111, 103]
      assert_equal ["c", "cat", "dog"].to_rlp, [201, 99, 131, 99, 97, 116, 131, 100, 111, 103]
    end

    should "encode long arrays" do
      assert_equal ["this is a very long list", "you never guess how long it is", "indeed, how did you know it was this long", "good job, that I can tell you in honestlyyyyy"].to_rlp, [248, 144, 152, 116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 32, 108, 105, 115, 116, 158, 121, 111, 117, 32, 110, 101, 118, 101, 114, 32, 103, 117, 101, 115, 115, 32, 104, 111, 119, 32, 108, 111, 110, 103, 32, 105, 116, 32, 105, 115, 169, 105, 110, 100, 101, 101, 100, 44, 32, 104, 111, 119, 32, 100, 105, 100, 32, 121, 111, 117, 32, 107, 110, 111, 119, 32, 105, 116, 32, 119, 97, 115, 32, 116, 104, 105, 115, 32, 108, 111, 110, 103, 173, 103, 111, 111, 100, 32, 106, 111, 98, 44, 32, 116, 104, 97, 116, 32, 73, 32, 99, 97, 110, 32, 116, 101, 108, 108, 32, 121, 111, 117, 32, 105, 110, 32, 104, 111, 110, 101, 115, 116, 108, 121, 121, 121, 121, 121]
    end

    should "encode integer" do
        assert_equal 1024.to_rlp, [0x82, 0x04, 0x00]
        assert_equal 15.to_rlp, [0x0f]
        assert_equal 128.to_rlp, [129, 128]
    end

    should "encode empty structures" do
        assert_equal "".to_rlp, [0x80]
        assert_equal [].to_rlp, [0xc0]
    end

    should "encode mixing everything togther" do
      assert_equal ["dog", 15, ["cat", "cat", []], 1024, "tachikoma"].to_rlp, [220,131, 100, 111, 103, 15, 201, 131, 99, 97, 116, 131, 99, 97, 116, 192, 130, 4, 0, 137, 116, 97, 99, 104, 105, 107, 111, 109, 97]
    end
  end
end

