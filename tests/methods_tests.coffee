# storeOnUplodcare
@mockHTTP =
  lastCall: {}
  callbackArgs: undefined
  call: (method, url, headers, callback)->
    @lastCall.method = method
    @lastCall.url = url
    @lastCall.headers = headers

    callback(@callbackArgs) if callback
@subject = (args)->
  UploadcareMethods.store
    uuid: "uuid"
    httpClient: @mockHTTP
    future: _.extend({wait: ->},args.future)
    checkPermissions: -> args.isPermitted

Tinytest.add "throws an error without check permission function", (test) ->
  test.throws ->
    UploadcareMethods.store(uuid: "uuid")
  , (exception) ->
    test.equal(exception.error, 400)
    true

Tinytest.add "does not proceed when check permission fails", (test) ->
  @subject(isPermitted: false)

  test.equal(@mockHTTP.lastCall, {})

Tinytest.add "calls http api with uuid if permission check passed", (test) ->
  @subject
   future:
    return: ->
   isPermitted: true

  test.equal(@mockHTTP.lastCall.url, "https://api.uploadcare.com/files/uuid/storage/")

Tinytest.add "returns true on success", (test) ->
  futureResult = undefined
  @subject
   future:
      return: (err, result) -> futureResult = result
   isPermitted: true

  test.equal(futureResult, true)

Tinytest.add "returns error on failure", (test) ->
  futureResult = undefined
  actualErr = undefined
  @mockHTTP.callbackArgs = error: true

  @subject
   future:
      return: (err, result) ->
        actualErr = err
        futureResult = result
   isPermitted: true

  test.equal(futureResult, null)
  test.equal(actualErr, error: true)
