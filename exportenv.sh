#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# export | egrep '( BUILT_PRODUCTS_DIR)|(CURRENT_ARCH)|(OBJECT_FILE_DIR_normal)|(SRCROOT)|(OBJROOT)' >> ${DIR}/envs.sh
export | egrep '(CURRENT_ARCH)|(OBJECT_FILE_DIR_normal)' >> ${DIR}/envs.sh
