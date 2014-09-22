---
layout: post
---

*This is part one in a two part series in which I explain how to set up a Jekyll site using Docker.*

I've been playing with [Docker](http://www.docker.com/) lately, the nifty container system that is going to save the world. The main selling point for Docker is the ability to layer "images" on top of one another, so you can start with a base operating system image (like Ubuntu), and build on it. The idea is to create lightweight images that only have the stuff that your application needs.

With that in mind, I decided to create a Docker image for Jekyll. Docker images by their nature should be pretty simple, and setting one up for Jekyll is no exception. In order to create your own Docker image, you need to write a [``Dockerfile``](https://docs.docker.com/reference/builder/) that tells Docker how to build the image.

The first step in creating a Docker image is figuring out which base image to use. In my case I decided to use Ubuntu Trusty. You can't really go wrong with Ubuntu. Here's what the first couple lines of the ``Dockerfile`` look like:

```
FROM ubuntu:trusty
MAINTAINER troyswanson <gerphimum@gmail.com>
```

From this point, you can run `docker build .` from the directory that contains this ``Dockerfile``, and you'll have an exact copy of Ubuntu Trusty. This isn't really helpful though, since you could just pull the image and run it by itself. The cool stuff comes when you run other commands in the ``Dockerfile``.

Once you have a fresh copy of Ubuntu to work with (the base image), the first thing to do is update the OS with the latest stuff from the package manager. A simple `apt-get update` handles that. Next, we need to install the stuff that Jekyll and nginx need to run.

*Note: Jekyll comes with a server (WEBrick, to be exact), but it's not well suited to be a production server. A dedicated web server like nginx is a much better option.*

Here's what the next few lines of the ``Dockerfile`` look like:

```
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    nginx \
    python \
    ruby \
    ruby-dev \
    nodejs
```

Now we have an Ubuntu image, as well as all the stuff we need to install Jekyll and eventually host the generated site with nginx. The next step is to install Jekyll itself. Here's what that looks like in the `Dockerfile`:

```
RUN gem install jekyll --no-ri --no-rdoc
```

The `--no-ri` and `--no-rdoc` options prevent all of the documentation files from being downloaded and installed, since we won't really be using them inside the container.

Next, we need to tweak the configuration of nginx just a little bit. The nature of Docker containers is to run until the program that they are executing exits. Out of the box, nginx runs in the background as a daemon when you run the `nginx` command. We need to tweak that so that it runs in the foreground and never exits.

In order to do this, we need to add a new line to the `nginx.conf` file that turns off the daemonization feature. The best way to do this is just to create a new file in the same directory as your `Dockerfile`, and then use the `ADD` command to copy it into the image.

*Note: I just copied the default `nginx.conf` file from Ubuntu and [added](https://github.com/troyswanson/docker-jekyll/commit/e6783047568aad4f232d81ffd6034e0d274889c0) `daemon off;` to it.*

```
ADD nginx.conf /etc/nginx/nginx.conf
```

The default config sets up the most basic nginx server imaginable, and will start hosting files that live in the `/usr/share/nginx/html` directory. Since all we're doing with nginx is hosting static files, this config will work just fine for us.

All that's left is to run the `nginx` command and expose port 80 from the container:

```
CMD ["nginx"]

EXPOSE 80
```

Time to test this thing to make sure it works! Run `docker build .` from the directory where the ``Dockerfile`` and `nginx.conf` files live. It will probably take a while to download the Ubuntu image, as well as installing all of the stuff, but once you are done building, you will see something like this:

```
Successfully built 4431996db701
```

This ID is the freshly built Docker image. The next step is to fire it up! Run `docker run -d -p 8080:80 [id]`, just replace `[id]` with the ID that Docker gave you after you built the image.

Once you run that command, Docker will return an ID for the container that was just created. The final step in testing is to try to hit the host machine with a web browser on port 8080. If you got a page that says "Welcome to nginx!", congratulations, you've successfully built a Docker image and created a container with it!

*Note: `docker run` accepts a bunch of options. `-d` tells Docker to run the container in the background, and `-p 8080:80` tells Docker to forward port 8080 from the host to port 80 in the container, since that's where nginx is expecting connections.*

If you have any questions about how this works, feel free to hit me up on Twitter [@gerphimum](https://twitter.com/gerphimum) or [create an issue](https://github.com/troyswanson/docker-jekyll/issues/new) in the [repo](https://github.com/troyswanson/docker-jekyll) for this project!

*In part two of this series, we will link up some Jekyll site source code with this image and host a generated site.*
