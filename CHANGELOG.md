# Changelog
All notable changes to this project will be documented in this file.

Note this file did not exist at the start of the project so does not
contain the full history.

The format is based on [Keep a Changelog] and this project adheres to
[Semantic Versioning].

Types of changes are:
* **Security** in case of vulnerabilities.
* **Deprecated** for soon-to-be removed features.
* **Added** for new features.
* **Changed** for changes in existing functionality.
* **Removed** for now removed features.
* **Fixed** for any bug fixes.

Breaking changes should be marked as "BREAKING" before the tickets:

```markdown
* BREAKING NDMS-yyy NTOS-xxx - Description of the breaking change
```

## [Unreleased]

## [1.4.7] - 2021-03-05
### Changed
* NMIS-1226 - The package shinyalert has been added to support ticket NMIS-1217.

## [1.4.6] - 2020-10-01
### Changed
* NMIS-1108 - The repository was changed to CRAN and packages httr and zip were
  updated.
* NMIS-1105 - Shinyjs was updated to version 2.0.0 for license purposes.

## [1.4.5] - 2020-09-11
### Changed
* Reduce the number of stages building stage to reduce the size of the image.

## [1.4.4] - 2020-09-10
### Changed
* The base image now uses renv and a renv.lock file to install R packages.

## [1.4.3] - 2020-08-26
### Changed
* Update libraries and remove tar.gz from the R packages installation in /tmp.

## [1.4.2] - 2020-08-18
### Changed
* Force the update of javascript.

## [1.4.1] - 2020-08-18
### Changed
* Warnings present during the build were removed.

## [1.4.0] - 2020-08-17
### Changed
* No longer require elucidataltc/tidyverse-plus and change to Ubuntu 20.04 as
  base image.

## [1.2.0] - 2020-07-30
### Changed 
* Functionality is now split across two Dockerfiles,
  elucidataltd/tidyverse-plus to provide the base image, and this
  repo for additions specific to the MI Portal.

## [1.0.5] - 2020-06-11
### Added 
* Added openxlsx library.

## [1.0.4] - 2020-05-27
### Added 
* Added AzureAuth library.

[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html
