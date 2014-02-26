## yeoman


**Dockerfile** for base yeoman install, with a few generators pre-installed.

### Installation

1. Install [Docker](https://www.docker.io/).

2. `docker run -i -t silarsis/yeoman`

    (alternatively, build from github: `docker build -t="silarsis/yeoman" github.com/silarsis/yeoman`)

### Usage

`docker run -i -t silarsis/yeoman`

This will run the container and log you in as the "yeoman" user, ready to "yo".

`docker run -i -t silarsis/yeoman -c grunt serve`

This will run the grunt server inside the container.

### Notes

"sudo" works - if you need root, `sudo -s` will get you there.

The default grunt port (9000) is exposed by default.

Docker hints:

  - `docker start -a -i <containerid>` will restart a stopped container and re-attach you to the bash process
  - `docker inspect -format '{{ .NetworkSettings.IPAddress }}' <containerid>` will give you the IP address of the currently running container
  - `docker run -P -i -t silarsis/yeoman` will map port 9000 to a port on the host, and `docker port <containerid> 9000` will show you what port that ends up on

This Dockerfile should provide a good base image for development work - as an example, based on the [Docker Node.js example](http://docs.docker.io/en/latest/examples/nodejs_web_app/), you could have a Dockerfile that looks like (**untested**, assumes your code is in the same directory as your Dockerfile):

```
  FROM silarsis/yeoman
  MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
  ADD . /src
  RUN cd /src; npm install
  EXPOSE 9000
  USER yeoman
  CMD ["grunt", "serve"]
```

and run with `docker build -t <username>/yeoman-dev .`; `docker run -P -d <username>/yeoman-dev`
