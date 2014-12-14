UploadcareSettings = {
  publicSettings: function() {
    if (Meteor.settings && Meteor.settings.public && Meteor.settings.public.uploadcare) {
      return Meteor.settings.public.uploadcare;
    }
  },
  privateSettings: function() {
    if (Meteor.settings && Meteor.settings.uploadcare) {
      return Meteor.settings.uploadcare;
    }
  },
  authorization: function() {
    var publicSettings = this.publicSettings();
    var privateSettings = this.privateSettings();
    if(publicSettings && this.privateSettings) {
      return "Uploadcare.Simple " + publicSettings.key + ":" + privateSettings.uploadcare_secret_key;
    } else {
      return "";
    }
  }
};
