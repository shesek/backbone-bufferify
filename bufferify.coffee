parser = (model, defs) -> parse=model::parse; (attrs) ->
  attrs = parse.call this, attrs
  for key, encoding of defs when key of attrs \
                            and not Buffer.isBuffer attrs[key]
    attrs[key] = new Buffer attrs[key], encoding
  attrs

jsonifier = (model, defs) -> toJSON = model::toJSON; ->
  attrs = toJSON.call this
  for key, encoding of defs when key of attrs \
                            and Buffer.isBuffer attrs[key]
    attrs[key] = attrs[key].toString(encoding)
  attrs

install = (model, defs) ->
  model::parse = parser model, defs
  model::toJSON = jsonifier model, defs
  model

module.exports = exports = install
exports.parser = parser
exports.jsonifier = jsonifier
