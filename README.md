# webhooks.kaplon.us

This is a node.js/express server for processing GitHub webhook requests.
It uses the more secure webhook option to include a secret when calculating hash values.
It's part of my complicated (but useful!) podcast feed workflow.
Whenever I push an update to the [At Least You're Trying podcast feed repository](https://github.com/jkaplon/alytfeed), its webhook contacts this server running on my [Linode VPS](https://www.linode.com/?r=30991a143a3c99716fbc7fdcf81355338c4d2b64).
This server then clones a new copy of my podcast feed and upates its canonical location on the web.
The code assumes it's running with access to the same file-system as the web server hosting the podcast feed.

Is all of this rather complex?...Yes.
Couldn't I _just_ serve my podcast feed as a GitHub page and call it a day?...Sure.
But then I would miss out on building this fun project!
Also, I'd rather host my podcast feed from a web-server completely under my control.

Initially this project used Ruby, Sinatra, and Thin.
I decided to port it over to node.js after struggling to get my Ruby project into a Docker container.
My other side-projects all use node.js, so it was more familiar ground to me.
