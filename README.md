# meteor-uploadcare

<a href="https://uploadcare.com" target="_blank">Uploadcare</a> library wrapped into Meteor package.

_Uploadcare handles uploads, so you don’t have to!_

_Beautiful upload widget, API to manage files in cloud storage, smart and fast CDN to deliver them to your end users._

_Crop, resize and transform uploaded images using URL commands._

__Real life Meteor app example:__

Look at beautiful Uploadcare <a href="https://vimeo.com/111023471" target="_blank">integration</a> in <a href="https://alpheratz.co" target="_blank"> Alpheratz</a> — personal gallery service on Meteor.

## Install

```bash
meteor add maximdubrovin:uploadcare
```

## Start uploading right now:

Set your <a href="https://uploadcare.com/documentation/widget/#UPLOADCARE_PUBLIC_KEY" target="_blank">public key</a>. This can go to the `<head>` of your page:
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

Place this file input somewhere in your templates:

```html
<input type="hidden" name="picture" role="uploadcare-uploader" />
```

To run local Meteor app with this settings start like this:
```bash
meteor --config /path/to/settings.json
```

On deploy Meteor app with `settings.json` see notes at <a href="https://github.com/arunoda/meteor-up" target="_blank">Meteor Up</a>
