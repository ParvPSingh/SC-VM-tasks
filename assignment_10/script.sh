#! /bin/bash
md5sum "$1" | awk '{print $1}'
