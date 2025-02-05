#!/bin/bash

# read current script path
arg0=${BASH_SOURCE[0]}
if [ ! $arg0 ];
then
    arg0=$0
fi
_COIN_SETUP_DIR=$(realpath "$(dirname "$(realpath "${arg0}")")")

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

unset _COIN_SETUP_DIR
