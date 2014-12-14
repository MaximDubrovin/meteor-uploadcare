Future = Npm && Npm.require("fibers/future");

UploadcareMethods =
{
  store: function (args) {
    check(args.uuid, String);
    var defaults = {
      httpClient: HTTP,
      future: new Future()
    };
    if (args.checkPermissions === undefined) {
      throw new Meteor.Error(400, "checkPermissions function is not defined");
    }

    if (args.checkPermissions() !== true) {
      return;
    }
    _.extend(defaults, args);


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

  delete: function (uuid) {
    check(uuid, String);

    this.unblock();

    var future = new Future();

    HTTP.call(
      "DELETE",
      "https://api.uploadcare.com/files/" + uuid + "/",
      {
        headers: {
          Accept: "application/vnd.uploadcare-v0.3+json",
          Date: new Date().toJSON(),
          Authorization: "Uploadcare.Simple " + Meteor.settings.public.uploadcare.key + ":" + Meteor.settings.uploadcare.secret_key
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
