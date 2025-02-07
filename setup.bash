#!/bin/bash

# read current script path
arg0=${BASH_SOURCE[0]}
if [ ! $arg0 ];
then
    arg0=$0
fi
_COIN_SETUP_DIR=$(realpath "$(dirname "$(realpath "${arg0}")")")

SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

function append_variable() {
    # check if the variable is already set
    if [[ "$(eval echo \${$1})" == *"$2"* ]]; then
        return
    fi
    # if not set, set the variable
    eval export $1=$2:\${$1}
    # remove trailing :
    eval export $1=\${$1%:}
}

# set bin path to PATN environment
append_variable PATH ${_COIN_SETUP_DIR}/bin

# set lib path to LD_LIBRARY_PATH environment
append_variable LD_LIBRARY_PATH ${_COIN_SETUP_DIR}/lib

# set pkgconfig path to PKG_CONFIG_PATH environment
append_variable PKG_CONFIG_PATH ${_COIN_SETUP_DIR}/lib/pkgconfig

# set site-packages path to PYTHONPATH environment
append_variable PYTHONPATH ${_COIN_SETUP_DIR}/lib/python/site-packages

# set root variable for coin
export COIN_ROOT=${_COIN_SETUP_DIR}
export Coin_ROOT=${COIN_ROOT}
export coin_ROOT=${COIN_ROOT}

# check is python3 installed, if not, install it
if ! command -v python3 &> /dev/null
then
    echo "python3 not found, installing python3..."
    $SUDO apt-get update
    $SUDO apt-get install python3 -y
fi

# check is python3-pip installed, if not, install it
if ! command -v pip3 &> /dev/null
then
    echo "python3-pip not found, installing python3-pip..."
    $SUDO apt-get update
    $SUDO apt-get install python3-pip -y
fi

# check is toml for python installed, if not, install it
if ! python3 -c "import toml" &> /dev/null
then
    echo "toml for python not found, installing toml..."
    pip3 install toml
fi

# check is distro for python installed, if not, install it
if ! python3 -c "import distro" &> /dev/null
then
    echo "distro for python not found, installing distro..."
    pip3 install distro
fi

unset _COIN_SETUP_DIR
unset SUDO