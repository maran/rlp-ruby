# rlp-ruby

rlp-ruby is a ruby implementation of the [recursive length prefix](https://github.com/ethereum/wiki/wiki/%5BEnglish%5D-RLP) (RLP) that can be found in [Ethereum](http://
ethereum.org).

rlp-ruby works by extending the ruby primitve classes with rlp oriented functions.

## Encoding to RLP
```
>"dog".to_rlp
=> [131, 100, 111, 103]
>["c", "cat", "dog"].to_rlp
=> [201, 99, 131, 99, 97, 116, 131, 100, 111, 103]
```

## Decoding from RLP
```
>rlp_array = RLP.decoder([201, 99, 131, 99, 97, 116, 131, 100, 111, 103])
>ba.get(0).as_string
=>"c"
>ba.get(1).as_string
=>"cat"
```

Please review the tests for more examples.

### Contributing to rlp-ruby
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2014 Maran. See LICENSE.txt for
further details.

