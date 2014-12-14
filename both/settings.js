UploadcareSettings = {
  public_settings: function() {
    if (Meteor.settings && Meteor.settings.public && Meteor.settings.public.uploadcare) {
      return Meteor.settings.public.uploadcare;
    }
  },
  private_settings: function() {
    if (Meteor.settings && Meteor.settings.uploadcare) {
      return Meteor.settings.uploadcare;
    }
  },
  authorization: function() {
    if(this.public_settings && this.private_settings) {
      "Uploadcare.Simple " + public_settings.key + ":" + private_settings.uploadcare_secret_key
    } else {
      ""
    }
  }
}
