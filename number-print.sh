#!/bin/bash
# SPDX-License-Identifier: WTFPL

# Simple script to update a Nextube gallery with a number.

# Warning: It is not yet known how much wear the flash can take, so please
# don't update this very frequently (i.e. a few updates a day max for now).

num=${2?

Usage: bash $0 ip number
Example: bash $0 192.168.1.22 42
}
ip="$1"
debug="$3" # e.g. -v

fail() {
  echo "$@" >&2
  exit 1
}

if ! [[ -f 0.jpg ]]; then
  fail "Please run in a directory containing number images, 0.jpg, etc."
fi

len="${#num}"

if [[ $len -gt 6 ]]; then
  fail "Number too large"
fi

pad=$(printf "%6s" "$num")

if [[ -n $debug ]]; then
  set -x
fi

seq=1
while [[ -n $pad ]]; do
  first="${pad:0:1}"

  if [[ "$first" = " " ]]; then
    first=blank
  fi

  curl $debug -F "file=@${first}.jpg" "http://${ip}/api/file/upload?path=/images/album/0${seq}.jpg"

  pad="${pad:1}"
  seq=$[$seq + 1]
done

curl $debug -d '' "http://${ip}/api/reset"
