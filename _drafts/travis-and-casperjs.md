---

layout: post

title: Travis and CasperJS

---

I spent literally all day today trying to set up [Travis CI](http://travis-ci.org) to run [CasperJS](http://casperjs.org/) scripts against this very site. The goal is to create front-end unit tests that ensure peak performance. Test-driven development isn't something that is usually thought about from a presentation or network perspective, but it is certainly just as important. After all, the front-end of a website is what the user eventually sees. There are a ton of metrics that a unit test can check for, e.g. unused CSS selector count, time it takes for certain JavaScript events to fire, broken links, just to name a few.