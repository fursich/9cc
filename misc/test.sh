#!/bin/bash

gcc -o ${1%.c} $1
./${1%.c}
exit $?
