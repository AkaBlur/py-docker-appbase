#!/usr/bin/env bash

git_repo_name()
{
    _REPO_NAME=${GIT_REPOSITORY##*/}
    _REPO_NAME=${_REPO_NAME%.*}

    printf ${_REPO_NAME}
}

git_check_repo()
{
    # check if repository exists
    _REPO_NAME=$(git_repo_name)

    if [ -d ${_REPO_NAME} ]; then
        echo "Repository exists already!"
        echo "Pulling latest"

        pushd ${_REPO_NAME} > /dev/null
        git pull
        popd > /dev/null
    fi
}

git_checkout()
{
    _REPO_NAME=$(git_repo_name)

    set +u
    if [ ! -z ${GIT_BRANCH} ]; then
        set -u
        pushd ${_REPO_NAME} > /dev/null
        git checkout ${GIT_BRANCH}
        popd > /dev/null
    fi
}

git_clone()
{
    _REPO_NAME=$(git_repo_name)

    if [ ! -d ${_REPO_NAME} ]; then
        # clone with recursive enabled
        git clone ${GIT_REPOSITORY} --recursive
    fi
}

export -f git_repo_name
export -f git_check_repo
export -f git_checkout
export -f git_clone
