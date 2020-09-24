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
