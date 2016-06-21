# Contributing

By contributing you agree to the [LICENSE](LICENSE) of this repository.

By contributing you agree to respect the [Code of Conduct](http://todogroup.org/opencodeofconduct/) of this repository.


## Issue Tracker

- before submitting a new issue, please:

    - check for existing related issues

    - check the issue tracker for a specific upstream project that may be more appropriate

    - check against supported versions of this project (i.e. the latest)

- please keep discussions on-topic, and respect the opinions of others



### Bug Reports

- please report bugs in the issue tracker

- please provide detailed steps to reproduce


### Feature Requests

- please suggest new features and improvements in the issue tracker

- suggestions for new features and improvements belong in Get Satisfaction


## Pull Requests / Merge Requests

- by submitting code for review and inclusion, we assume you have read and agree to our Contributor License Agreement

- **IMPORTANT**: by submitting a patch, you agree to allow the project owners to license your work under our this [LICENSE](LICENSE)

- please do not submit code for review and inclusion here

- provide tests for all features or bug fixes

- Pull / Merge Request descriptions should include a change summary that matches the [Keep a CHANGELOG](http://keepachangelog.com/) format

- this project uses the [GitHub Flow](https://guides.github.com/introduction/flow/) branching scheme, so changes should target the "master" branch

- please squash your commits if there is more than one


## Code Style and Code Quality

- Dockerfile
  - Use comments for each important step.
  - Separate similar commands (for example installing packages) in logical steps (for example, separate install of basic packages,
  developer packages, and server packages).


## Tests

- Use the specific runner of this project to build your image (see the [.gitlab-ci.yml](.gitlab-ci.yml)) of the project.