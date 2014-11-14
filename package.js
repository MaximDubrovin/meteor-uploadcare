
Package.describe(
	{
		summary: "Uploadcare handles uploads, so you don’t have to.",
		version: "1.4.5_1",
		name: "maximdubrovin:uploadcare",
		git: "https://github.com/MaximDubrovin/meteor-uploadcare.git"
	}
);

Package.on_use(function(api)
	{
		api.versionsFrom('0.9.0');
		api.add_files([ "lib/uploadcare-1.4.5.min.js" ], ["client"]);
	}
);