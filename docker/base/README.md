Support for auto proxy detection taken from
http://askubuntu.com/questions/53443/how-do-i-ignore-a-proxy-if-not-available

We take a guess at the docker main interface IP based on the default route.

If you run any container based on this image with "--link <name>:aptcacher",
then that container will be used as the proxy instead. This allows for running
a particular container for the proxy, but be aware that the link cannot be
provided to the build command - you'd need to set an ENV instead in the
Dockerfile to trigger this.
