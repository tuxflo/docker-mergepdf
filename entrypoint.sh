#!/bin/bash

/bin/sed -i 's/TIMWOUT/'"$TIMEOUT"'/g' /opt/mergepdf.sh
exec "$@"
