---
layout: post
title: GitHub Notifications on GitHub Enterprise
---

The great [Brandon Keepers](http://opensoul.org/) has come up with a really sweet interface for keeping track of notifications on GitHub. It's especially handy if you watch a whole bunch of repositories; lumping all of the comments into a big list and showing them in an email-style pane system. Definitely take some time to [see it in action](https://notifications.githubapp.com/) and check out the [code repo](https://github.com/bkeepers/github-notifications) that makes it hum.

This is all well and good, but what if you want to get this up and running on your GitHub Enterprise system? The point of most GHE installations is to be more secure by hosting the system inside a company's firewall. This means that traditional cloud hosts like Heroku won't have access to your internal GHE instance. However, the project is set up so that you can set it up on your own network and configure it to work your own GHE instance.

Hopefully you have access to some kind of virtualization system within your network that allows you to create a cheap and low-powered virtualized server. Just about anything will host this project. (I'm using a 1GB Ubuntu 12.04 instance on our internal OpenStack system.) The server actually does very little, as the code directs the browser to be responsible for hitting the API directly to get the data.

## Before we get crackin'

This tutorial doesn't cover the provisioning of a new server, be it physical or virtualized. Just about every organization is different when it comes to to provisioning boxes, so get with whoever is in charge of that to get some resources. As I mentioned before, I'm using an Ubuntu 12.04 instance, so this document assumes you're using the same.

*Full disclosure: I'm not a Linux admin by any stretch. If you think there's a better way to do this, please [hit me up](http://www.twitter.com/gerphimum) and let's chat about it. I'm always ready to learn new stuff from pros.*

## Get server dependencies

By now, I assume you've got a shiny new Ubuntu server ready to rock. Ubuntu doesn't come with Node.js or Ruby, which are required for this project to work.

There are only a couple `apt-get` dependencies that you need to install: a C compiler and git. Since this is a brand new installation, it's a good idea to update your package list and upgrade the stuff that's already on the server. Once you're done with that, grab the `build-essential` and `git` packages.

*Note: You need to be a `sudo`er in order to run these commands. If you can't get `sudo` access, just ask your server admin to install these.*

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get build-essential git
```

## Install Node.js

GitHub Notifications primarily runs as a node app, so obviously you have to install it. First, include `~/local/bin` in the `$PATH` environment variable stored in your `.bashrc` file. This gives us a nice new place to store the binary files for node and npm.

```
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
. ~/.bashrc
```

Next, make that `~/local` folder and another temporary folder to keep the source for node. It can be anything you want, really, but we'll use `~/node-latest-install`, since it's what they use in the [template](https://gist.github.com/isaacs/579814) I'm going off of. Once you've created that temporary folder, change into it.

```
mkdir ~/local
mkdir ~/node-latest-install
cd ~/node-latest-install
```

Once the folders are created and you're inside the temporary folder, use `curl` to get the tarball for the latest source code. Extract it once it's done, too.

```
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
```

Now that your server has finished downloading the source tarball and extracting it into the right directory, it's time to configure the build to point to our and start it up! The `make` process will probably take a while. Go get a snack or something.

```
./configure --prefix=~/local
make install
```

Everything should be good to go! You should now have two new commands: `node` and `npm`. See if they respond do a `--version` flag.

```
node --version
npm --version
```

If these commands responded with a version number, congrats! You've successfully installed Node.js! Change back to the home directory and move on to the next section.

```
cd ~
```

*Optional step: Now that everything has been installed, you can remove the temporary directory that you downloaded the node source into.*

```
rm -rf ~/node-latest-install
```

## Installing Ruby

This project uses Compass, which is a Ruby gem that makes life easier for folks writing stylesheets. My method of choice for installing Ruby is to use RVM. First step, download the installer and run it.

```
curl -sSL https://get.rvm.io | bash -s stable
```

The next step is to run a command that refreshes your shell windows. *Make sure you replace `[your-user]` with the user name you're using on your server.*

```
source /home/[your-user]/.rvm/scripts/rvm
```

You can now test to see if RVM installed correctly. The following command should output: *rvm is a function*.

```
type rvm | head -n 1
```

Now that you have RVM installed, you can tell it to install the latest and greatest version of Ruby. Check out for yourself which is the current stable on the [Ruby website](https://www.ruby-lang.org/en/downloads/). As of this writing, the most recent stable version is `2.1.0`, so I'll use that.

```
rvm install 2.1.0
```

You should now have two new commands: `ruby` and `gem`. Try checking their version number like you did with Node.js to make sure they're good to go.

```
ruby --version
gem --version
```

If these commands responded with a version number, congrats! You've successfully installed Ruby!

## Register the application on GitHub

Since this project relies on the use of GitHub's API, we will need to register the application in the GitHub Enterprise system. This isn't terribly hard, but you'll need to switch gears from terminal to web browser. Go through the following steps:

1. Log into your internal GitHub Enterprise instance
2. In the upper-right corner of the window, click the "Accout Settings" icon
3. On the left side bar, select the user or organization you want to register the application as
4. Click into the "Applications" section
5. Click "Register new application"
6. Fill out the for to register the new application
  * Application name: GitHub Notifications
  * Homepage URL: http://[server-ip]:8000/
  * Callback URL: http://[server-ip]:8000/
7. Click "Regiser application" button

Nice! Now your application has been registered on GitHub Enterprise. Keep this page open, since you'll need it for the Client ID and Client Secret values.

## Set up the GitHub Notifications project

Let's recap real quick. By now, your shiny new Ubuntu server has Node.js and Ruby installed and set up. It's now time to clone the project repository. Switch back to terminal, and get into whichever directory you'd like to clone the repo into. You can make a new directory for this project, or just use your home directory.

```
git clone https://github.com/bkeepers/github-notifications.git
cd github-notifications
```

By default, the project is set up to talk to github.com's endpoints. The configuration lines that you need to modify in order to point to your GitHub Enterprise endpoints are located in the `app/js/app.coffee` file. Getting into that file is a simple `vim` command away. (If you're more comfortable using a different text editor, go for it.)

```
vim app/js/app.coffee
```

Find the lines that define the `app` and `web` properties and change them to the endpoints for your GitHub Enterprise installation. *Be sure to include the trailing slash at the end of these strings.* Once these values have been changed, save and quit out of your text editor.

Next up, you'll need to update the Client ID and Client Secret values that you got after you registered the application on GitHub Enterprise. The place where these values live is `config/defaults.json`. Same thing as last time, edit this file.

```
vim config/defaults.json
```

Copy and paste the Client ID and Client Secret values into this file. Save and quit.

## Firing up the server

This project comes with some handy script files that make it ultra easy to prime the project.

```
script/bootstrap
```

This will install all of the node dependencies that this project uses. Once it's done setting everything up, fire up the server!

```
script/server
```

This will create a new HTTP listener server on port 8000. You should be able to hit the server from your own computer at this point! Try it out, and don't forget to include `:8000` at the end of the IP address or host name to force port 8000 use.
