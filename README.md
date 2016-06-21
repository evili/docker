# Docker Builds

Docker Automated Builds for use in IRI's GitLab Server.

You can use it in your `.gitlab-ci.yml` build file with the tag `image: docker.io/evili/build-image-name`.

## `labrobotica`
Ubuntu-based image with the iriutil packages, ros, and TeXLive packages. If in doubt use this one.

## `gitlabci`
Ubuntu-based image with the minimal devel packages (gcc, git, cmake, python, etc.) required for a generic project.

## `geodjango`
CenOs-based image with all packages needed to build a geodjango application.

## `postgis`
CenOs-based image with a postgis server. To use as a service with the former.
