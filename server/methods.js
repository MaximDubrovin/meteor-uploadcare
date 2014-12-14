Future = Npm && Npm.require("fibers/future");

UploadcareMethods =
{
  _validateCall: function(args) {
    var defaults = {
      httpClient: HTTP,
      future: new Future()
    };
    if (args.checkPermissions === undefined) {
      throw new Meteor.Error(400, "checkPermissions function is not defined");
    }

    if (args.checkPermissions(_.pick(args, 'uuid')) !== true) {
      return false;
    }
    _.extend(defaults, args);
    return true;
  },
  store: function (args) {
    check(args.uuid, String);
    if(!this._validateCall(args)) {
      return;
    }

    uuid = args.uuid;
    httpClient = args.httpClient;
    future = args.future;

    // If running as part of meteor method
    // indicate that waiting for this method to finish is not required
    if(this.unblock)
      this.unblock();

    httpClient.call(
      "PUT",
      "https://api.uploadcare.com/files/" + uuid + "/storage/",
      {
        headers: {
          Accept: "application/vnd.uploadcare-v0.3+json",
          Date: new Date().toJSON(),
          Authorization: UploadcareSettings.authorization
        }
      },
      function (err) {
        if (err) {
          future.return(err, null);
        }
        else {

          future.return(null, true);
        }
      }
    );

    return future.wait();
  },

  delete: function (args) {
    check(args.uuid, String);
    if(!this._validateCall(args)) {
      return;
    }

    uuid = args.uuid;
    httpClient = args.httpClient;
    future = args.future;

    // If running as part of meteor method
    // indicate that waiting for this method to finish is not required
    if(this.unblock)
      this.unblock();

    httpClient.call(
      "DELETE",
      "https://api.uploadcare.com/files/" + uuid + "/",
      {
        headers: {
          Accept: "application/vnd.uploadcare-v0.3+json",
          Date: new Date().toJSON(),
          Authorization: UploadcareSettings.authorization
        }
      },
      function (err) {
        if (err) {
          future.return(err, null);
        }
        else {
          future.return(null, true);
        }
      }
    );

    return future.wait();
  }

};
Meteor.methods(
  {
    "Uploadcare.store": UploadcareMethods.store,
    "Uploadcare.delete": UploadcareMethods.delete
  });
