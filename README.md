# Python Docker Application Template

A simple Docker image to provide a straigh-forward way to deploy a single
python service as container (e.g. ASGI applications).

App implementation can be achieved via a locally mounted directory or a
single git repository as remote source.

## Prerequisites

- Docker
- Python application
  - Locally deployed
  - Available as git repository

> [!IMPORTANT] - Python Application
> 
> The used Python application needs a startup-file called `bootstrap.sh` in the
> top-level directory.
>
> This file will act as startup by the container. Thus it needs to setup the
> application and run the initial start command.

## Usage

Best experience can be have with a Docker compose setup. Simply create a compose
file that sets up the container. Based on the implementation of the application
(git repo or locally) either a mount or environment settings are required.

### Local Application

```yaml
services:
  webserver:
    image: ghcr.io/akablur/py-docker-appbase:latest
    volumes:
      - "./app:/app"
    ports:
      - 80:80
```

This will mount the Python application under `app` into the container. Inside
the `app` directory a `bootstrap.sh` startup file needs to exist.

### Git Repository

To use an application from a remote repository only environment variables need
to be set.

```yaml
services:
  webserver:
    image: ghcr.io/akablur/py-docker-appbase:latest
    environment:
      - GIT_REPOSITORY=https://github.com/AkaBlur/py-docker-appbase.git
      - GIT_BRANCH=master
      - INSTALL_PYPROJECT=1
    ports:
      - 8000:8000
```

This will clone the repository from the given URL (GitHub in this case) and
**checks out the branch** specified with `GIT_BRANCH` (optionally). The main
application directory `app` is generally available as **Docker volume**. Thus
the main app structure will **persist container rebuilds** (volume should be
declared e.g. through docker-compose).

In the case of an already existing repository under `app` only a `git pull`
command will be issued. Generally the repository is instantiated **recursively**
(cloned with all submodules).

## Application Structure

An example project could look like

```
.
|- 📁 src/AkaBlur/app
|- 🔧 pyproject.toml
|- 💲 bootstrap.sh
```

When specifying `INSTALL_PYPROJECT=1` (as shown in [Git Repository](#git-repository))
a **pyproject.toml** in the local path will be installed as local installation.
This also enables automatic dependency installation via `pip`.

If `PYPROJECT_TARGET` is specified too this target will be used as install:

```bash
pip install -e '.[${PYPROJECT_TARGET}]'
```

Otherwise only `pip install -e .` will be run.

---

The given `bootstrap.sh` could then for example start a simple `fastapi` server:

**bootstrap.sh**
```bash
#!/usr/bin/env bash

fastapi run src/AkaBlur/app
```
