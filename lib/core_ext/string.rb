class String
  include RLP::Encode
end

Module.send(:include, RSpec::Core::DSL)
