---

layout: post

title: Serve a Static Site with Rack

---

*NOTE: This blog post discusses hosting files produced by [Jekyll](http://jekyllrb.com), but the same technique could be used to host any static site. You may have to experiment a little bit to get the routes working, though.*

The CMS I use for this site - Jekyll - builds a directory and file structure into flat, static HTML files. This helps keep the site's responsiveness at an all-time high, as well as reducing the amount of complexity the server has to deal with upon each HTTP request. It also makes it pretty easy to serve up in a continuous integration environment in order to run front-end unit tests on.