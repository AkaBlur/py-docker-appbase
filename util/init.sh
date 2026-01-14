#!/usr/bin/env bash

set -euo pipefail

die()
{
    printf "$1\n"
    exit 1
}

# ---------------------------------------------
# SETUP

_BASE_DIR=$(dirname $(readlink -f $0))
_USER_HOMEDIR=/home/python

if [ ${_BASE_DIR} != "${_USER_HOMEDIR}/util" ]; then
    die "Only run startup script from main ~/util directory!"
fi

source git_cloner.sh
source py_utils.sh

# ---------------------------------------------
# GIT REPOSITORY

# pull git repo if given by user
set +u
if [ ! -z ${GIT_REPOSITORY} ]; then
    set -u
    pushd /app > /dev/null
    git_check_repo
    git_clone
    git_checkout
    popd > /dev/null
fi

# ---------------------------------------------
# USER APPLICATION
_APP_DIR="/app"
set +u
if [ ! -z ${GIT_REPOSITORY} ]; then
    set -u
    _REPO_NAME=$(git_repo_name)

    _APP_DIR="${_APP_DIR}/${_REPO_NAME}"
fi

# add local binaries to path (for python binaries)
export PATH=${PATH}:~/.local/bin

# PYPROJECT SETUP
set +u
if [ ! -z ${INSTALL_PYPROJECT} ]; then
    set -u
    pushd ${_APP_DIR} > /dev/null
    pyproject_setup
    popd > /dev/null
fi

cd ${_APP_DIR}
if [ ! -f "bootstrap.sh" ]; then
    die "Application directory doesn't contain a 'bootstrap.sh' startup file!"
fi

bash -c "./bootstrap.sh"

exit 0
