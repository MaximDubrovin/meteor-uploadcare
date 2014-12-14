class mockHTTP
  constructor: ->
    @lastCall = {}
    @callbackArgs = undefined

  call: (method, url, headers, callback)->
    @lastCall.method = method
    @lastCall.url = url
    @lastCall.headers = headers

    callback(@callbackArgs) if callback
  reset: ->
    @lastCall = {}
# store

describe '#store', ->
  @beforeEach = ->
    @httpClient = new mockHTTP()
  @store = (args) ->
    UploadcareMethods.store
      uuid: "uuid"
      httpClient: httpClient
      future: _.extend({wait: ->},args.future)
      checkPermissions: -> args.isPermitted

  it "throws an error without check permission function", (test) ->
    @beforeEach()
    test.throws ->
      UploadcareMethods.store(uuid: "uuid")
    , (exception) ->
      test.equal(exception.error, 400)
      true

  it "does not proceed when check permission fails", (test) ->
    @beforeEach()
    @store(isPermitted: false)

    test.equal(@httpClient.lastCall, {})

  it "calls http api with uuid if permission check passed", (test) ->
    @beforeEach()
    @store
     future:
      return: ->
     isPermitted: true

    test.equal(@httpClient.lastCall.url, "https://api.uploadcare.com/files/uuid/storage/")

  it "returns true on success", (test) ->
    @beforeEach()
    futureResult = undefined
    @store
     future:
        return: (err, result) -> futureResult = result
     isPermitted: true

    test.equal(futureResult, true)

  it "returns error on failure", (test) ->
    @beforeEach()
    futureResult = undefined
    actualErr = undefined
    @httpClient.callbackArgs = error: true

    @store
     future:
        return: (err, result) ->
          actualErr = err
          futureResult = result
     isPermitted: true

    test.equal(futureResult, null)
    test.equal(actualErr, error: true)

describe '#delete', ->
  @beforeEach = ->
    @httpClient = new mockHTTP()
  @delete = (args)->
    UploadcareMethods.delete
      uuid: "uuid"
      httpClient: @httpClient
      future: _.extend({wait: ->},args.future)
      checkPermissions: -> args.isPermitted

  it "throws an error without check permission function", (test) ->
    @beforeEach()

    test.throws ->
      UploadcareMethods.store(uuid: "uuid")
    , (exception) ->
      test.equal(exception.error, 400)
      true

  it "does not proceed when check permission fails", (test) ->
    @beforeEach()

    @delete(isPermitted: false)

    test.equal(@httpClient.lastCall, {})

  it "calls http api with uuid if permission check passed", (test) ->
    @beforeEach()

    @delete
     future:
      return: ->
     isPermitted: true

    test.equal(@httpClient.lastCall.url, "https://api.uploadcare.com/files/uuid/")
    test.equal(@httpClient.lastCall.method, "DELETE")

  it "returns true on success", (test) ->
    @beforeEach()
    futureResult = undefined
    @delete
     future:
        return: (err, result) -> futureResult = result
     isPermitted: true

    test.equal(futureResult, true)

  it "returns error on failure", (test) ->
    futureResult = undefined
    actualErr = undefined
    @httpClient.callbackArgs = error: true

    @delete
     future:
        return: (err, result) ->
          actualErr = err
          futureResult = result
     isPermitted: true

    test.equal(futureResult, null)
    test.equal(actualErr, error: true)
