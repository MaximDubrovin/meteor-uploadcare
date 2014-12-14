@mockHTTP =
  lastCall: {}
  callbackArgs: undefined
  call: (method, url, headers, callback)->
    @lastCall.method = method
    @lastCall.url = url
    @lastCall.headers = headers

    callback(@callbackArgs) if callback
# store

describe '#store', ->
  @store = (args)->
    UploadcareMethods.store
      uuid: "uuid"
      httpClient: @mockHTTP
      future: _.extend({wait: ->},args.future)
      checkPermissions: -> args.isPermitted

  it "throws an error without check permission function", (test) ->
    test.throws ->
      UploadcareMethods.store(uuid: "uuid")
    , (exception) ->
      test.equal(exception.error, 400)
      true

  it "does not proceed when check permission fails", (test) ->
    @store(isPermitted: false)

    test.equal(@mockHTTP.lastCall, {})

  it "calls http api with uuid if permission check passed", (test) ->
    @store
     future:
      return: ->
     isPermitted: true

    test.equal(@mockHTTP.lastCall.url, "https://api.uploadcare.com/files/uuid/storage/")

  it "returns true on success", (test) ->
    futureResult = undefined
    @store
     future:
        return: (err, result) -> futureResult = result
     isPermitted: true

    test.equal(futureResult, true)

  it "returns error on failure", (test) ->
    futureResult = undefined
    actualErr = undefined
    @mockHTTP.callbackArgs = error: true

    @store
     future:
        return: (err, result) ->
          actualErr = err
          futureResult = result
     isPermitted: true

    test.equal(futureResult, null)
    test.equal(actualErr, error: true)
