# meteor-uploadcare

<a href="https://uploadcare.com" target="_blank">Uploadcare</a> library wrapped into Meteor package.

Uploadcare handles uploads, so you don’t have to!

Beautiful upload widget, API to manage files in cloud storage, smart and fast CDN to deliver them to your end users.

Crop, resize and transform uploaded images using URL commands.

__Real life Meteor app example:__

Look at beautiful Uploadcare <a href="https://vimeo.com/111023471" target="_blank">integration</a> in <a href="https://alpheratz.co" target="_blank"> Alpheratz</a> — personal gallery service on Meteor.

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

The library looks for inputs with special `role` attribute, and places widgets there. 

As soon as the file is uploaded, this `input` will receive file UUID or CDN link. 

To get file URL and other info after upload, you need to get the widget instance for a given input element.

```javascript
var widget = uploadcare.Widget('[role=uploadcare-uploader]');
```

And listen `widget.onUploadComplete()`

```javascript
widget.onUploadComplete(function(fileInfo) {
  console.log('fileInfo,' fileInfo);
  console.log('file UUID', fileInfo.uuid);
  console.log('fileInfo.originalUrl', fileInfo.originalUrl); // Public file CDN URL without any operations.
});
```

Now you can save file `URL` and  `UUID`  to Database for further usage.

## Image operations

Knowing image's original URL you can apply various <a href="https://uploadcare.com/documentation/cdn/#image-operations" target="_blank">image operations</a> on it such as resize, crop, blur, rotate, return progressive jpeg image,  set image quality and much more.

_Examples of URL image operations:_
http://www.ucarecdn.com/c5b7dd84-c0e2-48ff-babc-d23939f2c6b4/-/preview/480x480/-/quality/lightest/
http://www.ucarecdn.com/9eaf4b7b-6688-43e9-a6e5-9690142d765a/-/preview/-/blur/10/
http://www.ucarecdn.com/13448644-f240-4171-bad7-8e079eee491a/-/preview/-/grayscale/
http://www.ucarecdn.com/ec8850a1-7d02-4af0-ad92-dbac0d169408/-/preview/-/quality/best/-/progressive/yes/

## Storing and Deleting files vie REST API

Widget uploads files immediately after choosing to speed up users interaction with you app and makes UI async which allows user to do other stuff. This can be a real time saver.

By default uploaded __files will be available in Uploadcare storage for 24 hours__ from URL or UUID (via REST API). 

Why? To not pollute you project with unneeded files, exceed you plan limit and from malicious user that uses public key to upload and upload to you Uploadcare project storage.

Knowing file UUID after file upload you can decide to _store_ this file until you explicitely delete (or not) this file later.

Files __storing__ and __deleting__ you do via <a href="https://uploadcare.com/documentation/rest/" target="_blank">REST API</a> in your Meteor server side methods code.

Since REST API manipulations are crucial to your files it requires both your <a href="https://uploadcare.com/documentation/keys/" target="_blank">public and secret keys</a>


### Provide your private key to Meteor server code

Easiest and _secure_ way to provide your private key to Meteor server code is via <a href="http://docs.meteor.com/#/full/meteor_settings" target="_blank">Meteor.settings</a>

Create `settings.json` file with

```json
{
  "uploadcare": {
	    "public_key": "xxx...",
      "secret_key": ""yyy..."
  }
}
```

To run local Meteor app with this settings start like this:
```bash
meteor --config /path/to/settings.json
```

On deploy Meteor app with `settings.json` see notes at <a href="https://github.com/arunoda/meteor-up" target="_blank">Meteor Up</a>

### Add HTTP package

For using Uploadcare REST API from Meteor server code you'll need to make http requests to Uplodacare servers.

add <a href="http://docs.meteor.com/#/full/http" target="_blank">HTTP package</a>

```bash
meteor add http
```

### Store and Delete file server methods
Client side call to server method:
```javascript
Meteor.call('storeOnUplodcare', uuid, function(err, res) {});
Meteor.call('deleteFromUploadcare', uuid, function(err, res) {});
```
Server side method (place server methods code `/server/methods_server.js` directory):
```javascript
Future = Npm && Npm.require('fibers/future');

Meteor.methods({
	
	storeOnUplodcare: function(uuid)
	{
		check(uuid, String);

		this.unblock();

		var future = new Future();

		HTTP.call(
			'PUT',
			'https://api.uploadcare.com/files/' + uuid + '/storage/',
			{
				headers: {
					Accept: 'application/vnd.uploadcare-v0.3+json',
					Date: new Date().toJSON(),
					Authorization: 'Uploadcare.Simple ' + Meteor.settings.uploadcare.public_key + ':' + Meteor.settings.uploadcare.secret_key
				}
			},
			function(err)
			{
				if (err)
				{
					future.return(err, null)
				}
				else
				{

					future.return(null, true)
				}
			}
		);

		return future.wait();
	},

	deleteFromUploadcare: function(uuid)
	{
		check(uuid, String);

		this.unblock();

		var future = new Future();

		HTTP.call(
			'DELETE',
			'https://api.uploadcare.com/files/' + uuid + '/',
			{
				headers: {
					Accept: 'application/vnd.uploadcare-v0.3+json',
					Date: new Date().toJSON(),
					Authorization: 'Uploadcare.Simple ' + Meteor.settings.uploadcare.public_key + ':' + Meteor.settings.uploadcare.secret_key
				}
			},
			function(err)
			{
				if (err)
				{
					future.return(err, null)
				}
				else
				{
					future.return(null, true)
				}
			}
		);

		return future.wait();
	}

});
```

_Note:_

I use `fibers/future` to get async callback on client.

If users makes call to this methods add check that ensures that users owns this files (has documents in database that contains uuid, for example).


