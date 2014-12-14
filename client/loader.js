loadUploadcare = function () {
  var config = {};
  var callback = _.noop;
  if (UploadcareSettings.public_settings) {
    config = UploadcareSettings.public_settings;
  }
  var firstArg = [].shift.apply(arguments);
  if (typeof(firstArg) === "object") {
    config = _.extend(config, firstArg);
    callback = [].pop.apply(arguments)
  }
  else if (typeof(firstArg) === "function") {
    callback = firstArg
  }


  if (uploadcare === undefined) {
    var key = config.key;
    if (key) {
      // Functions to run after the script tag has loaded
      var uploadcareLoadCallback = function () {
        window.UPLOADCARE_PUBLIC_KEY = key;

        if (callback && typeof(callback) == "function")
          callback();
        };

        // If the script doesn't load
        var uploadcareErrorCallback = function (error) {
          if (console !== undefined) {
            console.log(error);
          }
        };

        // Generate a script tag
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "//ucarecdn.com/widget/1.4.6/uploadcare/uploadcare-1.4.6.min.js";
        script.onload = uploadcareLoadCallback;
        script.onerror = uploadcareErrorCallback;

        // Load the script tag
        document.getElementsByTagName("head")[0].appendChild(script);

      } else {
        if (console !== undefined) {
          console.log("uploadcare - tried to load but key not supplied");
        }
      }
    }
  };
