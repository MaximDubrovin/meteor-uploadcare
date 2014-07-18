Package.describe({
	summary: "1.3.1 Uploadcare library packed for Meteor. Uploadcare is a service that helps media creators, businesses and developers store, process and deliver visual content to their clients. Learn more on uploadcare.com"
});

Package.on_use(function(api) {
	api.add_files([ "lib/uploadcare-1.3.1.min.js" ], ["client", "server"]);
});