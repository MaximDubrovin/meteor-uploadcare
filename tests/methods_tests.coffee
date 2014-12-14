# storeOnUplodcare
Tinytest.add "fails without check permission function", (test) ->
  test.throws ->
    UploadcareMethods.store(uuid: "123")
  , (exception) ->
    test.equal(exception.error, 400)
    true

Tinytest.addAsync "does not proceed when check permission returns non true", (test, done) ->
  called = false
  mockHTTP =
    call: ->
      called = true

  UploadcareMethods.store
    httpClient: mockHTTP
    uuid: "123"
    checkPermissions: -> undefined

  Meteor.setTimeout ->
    test.equal(called, false)
    done()
  , 500

Tinytest.add "calls http api with uuid if permission check passed", (test) ->
  actualUrl = ""
  mockHTTP =
    call: (method, url, headers, callback)->
      actualUrl = url


  UploadcareMethods.store
    uuid: "123"
    httpClient: mockHTTP
    future:
      wait: ->
    checkPermissions: -> true

  test.equal(actualUrl, "https://api.uploadcare.com/files/123/storage/")

Tinytest.add "returns true on success", (test) ->
  mockHTTP =
    call: (method, url, headers, callback)->
      callback()

  futureResult = undefined
  UploadcareMethods.store
    uuid: "123"
    httpClient: mockHTTP
    future:
      return: (err, result) -> futureResult = result
      wait: ->
    checkPermissions: -> true

  test.equal(futureResult, true)

Tinytest.add "returns error on failure", (test) ->
  mockHTTP =
    call: (method, url, headers, callback)->
      callback(error: true)

  futureResult = undefined
  actualErr = undefined
  UploadcareMethods.store
    uuid: "123"
    httpClient: mockHTTP
    future:
      return: (err, result) ->
        actualErr = err
        futureResult = result
      wait: ->
    checkPermissions: -> true

  test.equal(futureResult, null)
  test.equal(actualErr, error: true)
