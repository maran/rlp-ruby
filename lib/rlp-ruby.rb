require_relative 'encode'
require_relative 'core_ext/array'
require_relative 'core_ext/fixnum'
String.send(:include, RLP::Encode)

module RLP
  def self.log(message)
    if false
      puts(message)
    end
  end

  def self.decoder(data)
    return self.decode(data,0)[0]
  end

  def self.decode(data, pos)
    value = data[pos]
    RLP.log("Data: #{data}")
    result = []

    # Reading a single byte
    if value <= 0x7f
      RLP.log("<= 0x7f, reading 1 byte")
      RLP.log("=> Read: #{value}")
      return value, pos+1
    # Reading a string up to and including 55 bytes long 
    elsif value <= 0xb7
      start_at = pos + 1
      read_length = value - 0x80
      RLP.log("<= 0xb7, starting reading at the #{start_at}th byte and reading #{read_length} bytes")
      read_data = data[start_at..(start_at+read_length-1)]
      RLP.log("=> Read: #{read_data}")
      return read_data, (start_at + read_length)
    # Reading a string that is longer than 55 bytes
    elsif value <= 0xbf
      start_at = pos + 1
      read_length = value - 0xb7

      read_length_length = data[start_at..(start_at+read_length-1)].reverse_bytes
      RLP.log("<= 0xbf, starting reading at the #{start_at}th byte and reading #{read_length_length} bytes")
      RLP.log("=> Read: #{read_data}")
      read_data = data[(start_at+read_length),read_length_length]

      return read_data, start_at+read_length+read_length_length
    # Reading a list that is up to (and including) 55 bytes long
    elsif value <= 0xf7
      amount = value - 0xc0
      RLP.log("<= 0x7f, starting reading at the #{start_at}th byte and reading #{amount} bytes")
      pos += 1
      i = 0
      while i < amount do
        decoded, prev_pos = decode(data,pos)
        result << decoded
        i += (prev_pos - pos)
        pos = prev_pos
      end
      RLP.log("=> Read: #{result}")

      return result,pos
    # Reading a list that is longer then 55 bytes
    elsif value <= 0xff
      length = value - 0xf7
      start_at = pos + 1
      read_length_length = data[start_at..start_at+length-1]

      pos = length + start_at
      RLP.log("<= 0xff, starting reading at the #{start_at}th byte and reading #{read_length_length} bytes")
      prev_pos = read_length_length
      i = 0
      while i < read_length_length.reverse_bytes do
        decoded,prev_pos = decode(data,pos)
        result << decoded
        i += (prev_pos - pos)
        pos = prev_pos
      end

      RLP.log("=> Read: #{result}")
      return result, pos
    end
  end
end
