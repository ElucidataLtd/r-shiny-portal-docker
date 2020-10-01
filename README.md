# r-shiny-portal-docker

This repo provides the base image for the MI Portal. Updates to the repo trigger builds at [https://hub.docker.com/r/elucidataltd/r-shiny-portal](https://hub.docker.com/r/elucidataltd/r-shiny-portal).

## Update Process

* Develop on feature branches.
* Update the CHANGELOG as part of a feature.
* Follow standard PR process.
* Merge to `master`.
* Create a Github release, with a version tag following semantic versioning.
* Wait for the build in Docker Hub before including the new version in the MI Portal's Dockerfile (never use `latest`).

