# meteor-uploadcare

Uploadcare library wrapped into a Meteor package.

<a href="https://uploadcare.com" target="_blank">Uploadcare</a> handles uploads, so you don’t have to!
Beautiful upload widget, API to manage files in cloud storage, smart and fast CDN to deliver them to your end users.
Crop, resize and transform uploaded images using URL commands.

__Real life Meteor app example:__

Look at the beautiful Uploadcare <a href="https://vimeo.com/111023471" target="_blank">integration</a> in <a href="https://alpheratz.co" target="_blank"> Alpheratz</a> — personal gallery service on Meteor.

## Install

```bash
meteor add maximdubrovin:uploadcare
```

## Start uploading right now:

Set your <a href="https://uploadcare.com/documentation/widget/#UPLOADCARE_PUBLIC_KEY" target="_blank">public key</a>. This can go to the `<head>` of your Meteor app:
```html
<head>
  ...
  <script>
      UPLOADCARE_PUBLIC_KEY = 'demopublickey';
  </script>
  ...
<head/>
```

`demopublickey` will work for testing purpose.

Place this `input` element somewhere in your templates:

```html
<input type="hidden" name="picture" role="uploadcare-uploader" data-crop />
```

The library looks for an input with special `role` attribute, and places a widget there.

As soon as the file is uploaded, this `input` will receive file UUID or CDN link.

To get file URL and other info after upload is finished,
you need to get the widget instance for a given input element.

```javascript
var widget = uploadcare.Widget('[role=uploadcare-uploader]');
```

And listen `widget.onUploadComplete()`

```javascript
widget.onUploadComplete(function(fileInfo) {
  console.log('fileInfo,' fileInfo);
  console.log('file UUID', fileInfo.uuid);
  console.log('fileInfo.originalUrl', fileInfo.originalUrl); // Public CDN URL of the uploaded file, without any operations.
});
```

Now you can save file `URL` and  `UUID`  to the database for further usage.

## Image operations

You can apply various <a href="https://uploadcare.com/documentation/cdn/#image-operations" target="_blank">image operations</a> on uploaded images, such as resize, crop, blur, rotate, return progressive jpeg image, set image quality and much more, by appending CDN commands on the original URL.

_Examples of URL image operations:_

http://www.ucarecdn.com/c5b7dd84-c0e2-48ff-babc-d23939f2c6b4/-/preview/480x480/-/quality/lightest/

http://www.ucarecdn.com/9eaf4b7b-6688-43e9-a6e5-9690142d765a/-/preview/-/blur/10/

http://www.ucarecdn.com/13448644-f240-4171-bad7-8e079eee491a/-/preview/-/grayscale/

http://www.ucarecdn.com/ec8850a1-7d02-4af0-ad92-dbac0d169408/-/preview/-/quality/best/-/progressive/yes/

## Storing and Deleting files via REST API

The widget starts uploading immediately after user chooses a file. It speeds up interaction with your app, and makes UI async, allowing users to do other stuff while the file is still uploading. This can be a real time saver.

By default uploaded __files will be available in Uploadcare storage for 24 hours__ from URL or UUID (via REST API).

Why? To prevent overwhelming your project with unneeded files, to avoid exceeding your plan limits, and to protect you from risk of abusing your public key by malicious users. You may __store__ each uploaded file permanently, or __delete__ it, using <a href="https://uploadcare.com/documentation/rest/" target="_blank">REST API</a> on your Meteor back-end.

Since REST API manipulations must be secure, they require both your <a href="https://uploadcare.com/documentation/keys/" target="_blank">public and secret keys</a>.


### Placing your secret and public keys into Meteor back-end code

Easiest and the most _secure_ way to provide your Uploadcare keys to Meteor back-end code is placing them to <a href="http://docs.meteor.com/#/full/meteor_settings" target="_blank">Meteor.settings</a> by creating a `settings.json` file:

```json
{
  "uploadcare": {
  	"public_key": "xxx...",
  	"secret_key": "yyy..."
  }
}
```

Use the command to run local Meteor app with these settings:

```bash
meteor --config /path/to/settings.json
```

See notes on deploying Meteor app with `settings.json` at <a href="https://github.com/arunoda/meteor-up" target="_blank">Meteor Up</a> tool.

### Add HTTP package

To use Uploadcare REST API within Meteor back-end code, you have to make HTTP requests to Uplodacare infrastructure using <a href="http://docs.meteor.com/#/full/http" target="_blank">HTTP package</a>:

```bash
meteor add http
```

### Storing and Deleting files

Client-side call to your back-end:

```javascript
checkPermissions = function(args) {
  # canAccess is an example of a custom method you need to check permissions
  if(Meteor.call('canAccess', args.uuid)) {
    return true;
  }
  else {
    return false;
  }
}
Meteor.call('Uploadcare.store', { uuid: uuid, checkPermissions: checkPermissions }, function(err, res) {});
Meteor.call('Uploadcare.delete', { uuid: uuid, checkPermissions: checkPermissions }, function(err, res) {});
```

_Notes:_

`checkPermissions` function is required since any UUID can be passed to `Uploadcare.store` and `Uploadcare.delete`.

_Example:_
```javascript
Meteor.methods({
  canAccess: function(uuid)
	{
		check(uuid, String);

		return AlbumItems.find(
			{
				owner: this.userId,
				uuid: uuid
			}
		).count();
	},
})
```
