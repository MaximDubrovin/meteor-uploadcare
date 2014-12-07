Tinytest.addAsync 'loads uploadcare when key is provided as parameter', (test, done) ->
  window.uploadcare = undefined

  loadUploadcare key: 'demopublickey', ->
    test.notEqual(window.uploadcare, undefined)
    done()

Tinytest.addAsync 'loads uploadcare when key is provided in settings', (test, done) ->
  window.uploadcare = undefined

  Meteor.settings =
    public:
      uploadcare:
        key: 'demopublickey'
  loadUploadcare ->
    test.notEqual(window.uploadcare, undefined)
    done()

Tinytest.addAsync 'does load uploadcare when is is already loaded', (test, done) ->
  window.uploadcare = undefined
  doubleLoad = false

  loadUploadcare ->
    loadUploadcare ->
      doubleLoad = true

  Meteor.setTimeout ->
    test.equal(doubleLoad, false)
    done()
  , 1000
