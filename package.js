Package.describe({
	name: 'petsetgo:uploadcare',
	summary: 'Wrapper around uploadcare for meteor. Inspired by filepicker-plus',
	version: '1.0.0',
	git: 'https://github.com/petsetgo/meteor-uploadcare.git'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.add_files([ "client/loader.js" ], ["client"]);
	api.export('loadUploadcare', ['client'])
});

Package.onTest(function(api) {
	api.use('petsetgo:uploadcare');
	api.use(['tinytest','coffeescript']);
	api.addFiles('tests/loader_tests.coffee', ['client']);
});
