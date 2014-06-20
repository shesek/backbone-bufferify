{ Model } = require 'backbone'
{ equal: eq, ok } = require 'assert'
bufferify = require '../bufferify.coffee'

describe 'backbone-bufferfy', ->
  class Foo extends Model
    bufferify this, bar: 'hex', qux: 'base64'
  
  it 'parses strings into buffers in parse()', ->
    foo = new Foo { bar: 'aa', qux: 'uw==' }, parse: true

    ok Buffer.isBuffer foo.get('bar')
    eq foo.get('bar').toString('hex'), 'aa'

    ok Buffer.isBuffer foo.get('qux')
    eq foo.get('qux').toString('hex'), 'bb'

  it 'leaves buffers as-is', ->
    foo = new Foo { bar: new Buffer([0xaa]), qux: new Buffer([0xbb]) }, parse: true

    ok Buffer.isBuffer foo.get('bar')
    eq foo.get('bar').toString('hex'), 'aa'

    ok Buffer.isBuffer foo.get('qux')
    eq foo.get('qux').toString('hex'), 'bb'

  it 'turns it back to strings in toJSON()', ->
    foo = new Foo { bar: new Buffer([0xaa]), qux: new Buffer([0xbb]) }, parse: true

    eq JSON.stringify(foo), '{"bar":"aa","qux":"uw=="}'

  it 'allows setting custom toJSON/parse methods', ->
    class Bar extends Model
      parse: (attrs) -> attrs.qux += 'aa'; attrs
      toJSON: -> attrs = super; attrs.qux = attrs.qux.slice(0,1); attrs
      bufferify this, qux: 'hex'
    bar = new Bar { qux: 'cc' }, parse: true
    eq bar.get('qux').toString('hex'), 'ccaa'
    eq bar.toJSON().qux, 'cc'

  it 'allows specifying "keep_buff" option in toJSON to disable stringification', ->
    foo = new Foo foo: new Buffer [0xaa]
    eq foo.toJSON(keep_buff: true).foo[0], 0xaa
