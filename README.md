[![Build Status](https://travis-ci.org/Chuckame/post-config.svg?branch=master)](https://travis-ci.org/Chuckame/post-config)

Scripts run following a Linux fresh install, adding a bunch of stuff so that I feel right at home.

# Installation on an  OVH Kimsufi-class Dedicated Servers

Registering the post-installation configuration script can be done in two different ways:

* using a *custom installation*,
* creating a new template.

In both cases, the *Post installation script link* URI should be set to  ``https://raw.githubusercontent.com/Chuckame/post-config/master/scripts/ovh/ovh.sh``

If you fork this repo, you do change variables :
- scripts/ovh/ovh_debian : DOMAIN=your.domain
- scripts/ovh/ovh.sh : URI_ROOT="https://raw.githubusercontent.com/YourGithubName/post-config/master/"
