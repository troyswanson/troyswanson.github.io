---

layout: post

title: GitHub as a CMS

---

This post was created and published entirely using GitHub. And it was easy. Remember, I'm using [Jekyll](http://jekyllrb.com) and [GitHub Pages](http://pages.github.com/), but you can set up this process to work with basically any flat file content management system. Also, this process isn't specific to blog posts. It can work for any kind of flat file content that your site uses.

## Why?

In a world where there are literally hundreds of content management systems, each somehow falling in between stupidly simple and insanely complex, you need to evaluate your options carefully and determine which makes the most amount of sense for you and your project. During the research process, one of the most common selling points is the power of the back-end admin interface.

I submit that the best back-end interface out there right now is GitHub.

Take a look at the ultra-popular Drupal module, [Workbench](https://drupal.org/project/workbench). From their module page, Workbench gives a Drupal site a few important solutions:
* A unified and simplified user interface for users who *only* have to work with content
* The ability to control who has access to edit any content based on an organization's structure not the web site structure
* A customizable editorial workflow that integrates with the access control feature described above or works independently on its own

Before I go any further, I have to say that Workbench is a great module and I applaud the efforts of maintainers. If you have to use Drupal, it's pretty much a must have. That said, I think the spirit of the module has it wrong. It's obvious that any large scale website needs to have editorial review, but the idea that you can and should lock down specific parts of content so that only certain people can propose changes on a page seems wrong to me.

A support person who answers a phone call from a confused customer should have just as much power to propose a change to the content as a copy writer or a marketing manager.

## The Process

1. To work on a new post, create a new branch off of `master` for it
2. [Move and rename](https://github.com/blog/1436-moving-and-renaming-files-on-github) a draft to the `_posts` directory, or [create a new file](https://github.com/blog/1327-creating-files-on-github) for the post
3. Write and commit the post
4. Create a pull request (for CI and any peer review)
5. If the build passed and the post looks good, merge!
6. Deploy your new post (if it hasn't already been done automatically)

If this looks familiar, that might because you've seen out [the GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html) before. This process is basically just a specialized version of it.

If you're not familiar with the GitHub Flow, here's a little cheat sheet.

1. Anything in the `master` branch is deployable
2. To work on something new, create a descriptively named branch off of `master`
3. Commit to that branch locally and regularly push your work to the same named branch on the server
4. When you need feedback or help, or you think the branch is ready for merging, open a pull request
5. After someone else has reviewed and signed off on the feature, you can merge it into master
6. Once it is merged and pushed to `master`, you can and should deploy immediately

## Warning

Using this process makes it pretty difficult to preview the changes on your site. To make sure nothing exploded, set up a CI system that crawls your site and checks for broken links, images, and other stuff that might cause a site to behave improperly. Whenever you push a commit to the branch that you created, make sure that it has passed before you merge to `master`.

It also might make sense to have your CI system take screenshots of each page during its crawl so that you can make sure the styling is all good. This is one of those things where you need to have a fully baked set of CSS rules that can cover any kind of formatting that your posts might contain.
