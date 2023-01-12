#!/bin/sh

FILE="$1"

sha256sum "${FILE}" | tee "${FILE}.sha256sum"

