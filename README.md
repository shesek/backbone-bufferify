# backbone-bufferify

Backbone utility for working with Buffers.

### Install

```bash
  $ npm install backbone-bufferify
```

### Use

```js
  var bufferify = require('backbone-bufferify');
  var User = Backbone.Model.extend(...);
  
  // Setup the attributes with the used encoding
  bufferify(User, { public_key: 'hex', signature: 'base64' });

  // User::parse() turns strings into Buffers
  var user = new User({
    public_key: '023bb45c5a5c167e3b3a996a3081c0938a7497b2f12b511d174848d3c1d7abd12f',
    signature: 'MEYCIQCanWQvmsuECBjPl3z9GjIhB0x/nYpaJ40cGOgFBuxSbQIhANVlp6VhZl0hPkD8/ZydHupssbIdbuh1IRck9cg5Yivv'
  }, { parse: true });

  assert(Buffer.isBuffer(user.get('public_key')));
  assert(Buffer.isBuffer(user.get('signature')));

  // User::toJSON() turns them back into strings
  var plain = user.toJSON();
  assert(typeof plain.public_key == 'string');
  assert(typeof plain.signature == 'string');
```

Note: if you're setting a custom `parse()`/`toJSON()` method on your models,
do that before calling `bufferify()` and it'll internally call your methods
first. Setting your methods after calling `bufferify()` will disable it.

### License
MIT
