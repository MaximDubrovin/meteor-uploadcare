# meteor-uploadcare

Uploadcare library packed for Meteor. 

Uploadcare is a service that helps media creators, businesses and developers store, process and deliver visual content to their clients. 

Learn more on <a href="https://uploadcare.com" target="_blank">uploadcare.com</a>

*Library version: 1.3.1*

## How to use?

### Install via Meteorite

```bash
mrt add uploadcare
```

### Files uploading from client:

To upload files from client via [Javascript API](https://uploadcare.com/documentation/javascript_api/), [widget](https://uploadcare.com/documentation/widget/) or [REST Upload API](https://uploadcare.com/documentation/upload/) only required parameter is a *public key*.

Place your public key in ```<head/>```
```html
<head>
  ...
  <script>
      UPLOADCARE_PUBLIC_KEY = 'your_public_key';
  </script>
  ...
<head/>
```

That's all! You are ready to upload files from client which way you like. It's a magic pill. 

```<head/>``` is a monolith place to store your public key in dynamic Meteor applications.

### Files and projects manipulating via REST API
It's funny but you can do it without this package.

For example, if you want to delete file from Uploadcare you are going to use REST API and you gonna do it via server method (for the sake of *secret key* privacy). 

[Whatta hell is REST API?](#whatta-hell-is-rest-api)

#### Set your secret key
We gonna place it in dark room of ```Meteor.settings```. According to [docs](http://docs.meteor.com/#meteor_settings) «If the settings object contains a key named public, then Meteor.settings.public will be available on the client as well as the server. All other properties of Meteor.settings are only defined on the server.»

Create ```settings.json``` in your meteor app directory.

Add this chunk to it and fill keys according to your credentials:
```javascript
{
	"uploadcare": {
		"public_key": "blya",
		"secret_key": "kto_pishet_open_source_readmy_v_5_utra?"
	}
}
```

To run local Meteor app with this settings start like this:
```bash
meteor --config /path/to/settings.json
```

On deploy case see [Meteor Up](https://github.com/arunoda/meteor-up#creating-a-meteor-up-project)

For example, you can create server method to delete file from Uploadcare:
```javascript
if (Meteor.isServer) {
  Meteor.methods({
    deleteFileFromUploadcare: function(uuid) {
      if (
          uuid && typeof uuid === 'string' &&
          Meteor.settings && typeof Meteor.settings === 'object' &&
          Meteor.settings.uploadcare && typeof Meteor.settings.uploadcare === 'object' &&
          Meteor.settings.uploadcare.public_key && typeof Meteor.settings.uploadcare.public_key === 'string' &&
          Meteor.settings.uploadcare.secret_key && typeof Meteor.settings.uploadcare.secret_key === 'string' &&
          HTTP) {
          
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
              function(error, result) {
              if (error) {
            	  console.log('App Error: Deletion of a file from Uploadcare failed. Details:', error);
              } else {
                //console.log('Farewell file!');
              }
            });
        }
      }
  })
}
```

Info for code above: [uuid](https://uploadcare.com/documentation/javascript_api/#file), [HTTP package](http://docs.meteor.com/#http)

#### Whatta hell is REST API?
Link to page is a *request*. You click it — request goes to server by browser according to domain. Server reads link. It's like a newspapper for him. He reads ```blog.com/post/s23fs3```. If he understand it he sends a *response* back to your browser. In this case it will be ```some.html```. If he don't understand request he responds with some error codes like mystic ```404``` or ```503```. Maybe because he wants that we don't understand him too. Who knows.

So by clicking a link we actually manipulate server.

So if we want manipulate Uploadcare server from our code we need to construct our own request and send it to server. How to construct it? OK guy uses ```$.ajax```, Meteor girl may use built-in HTTP package.

REST it is backbone of the web. It's beautiful.
