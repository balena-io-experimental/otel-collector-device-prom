#!/bin/sh
# Echo the arch-specific name of the generated OTel collector builder binary.
# Example:
#   $ echo-ocb-archfile.sh aarch64
#   ocb_linux_arm64

basename=ocb_linux_
case "$1" in
  "aarch64" )
    echo ${basename}arm64
    ;;
  "amd64" )
    echo ${basename}amd64
    ;;
  "armv7hf" )
    echo ${basename}armv7
    ;;
  "rpi" )
    echo ${basename}armv6
    ;;
  * )
    echo unknown
    ;;
esac

