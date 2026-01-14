#!/usr/bin/env bash

pyproject_setup()
{
    if [ ! -f "pyproject.toml" ]; then
        echo "No pyproject.toml found, aborting!"
        exit 1
    fi

    set +u
    if [ ! -z ${PYPROJECT_TARGET} ]; then
        set -u
        pip install -e ".[${PYPROJECT_TARGET}]"
    else
        pip install -e .
    fi
}

export -f pyproject_setup
