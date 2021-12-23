#!/bin/bash
SCRIPT_PATH="${BASH_SOURCE[0]}"
export "JAVA_HOME=/usr/share/opensearch/jdk"
if ! [ -x "$(command -v realpath)" ]; then
    if [ -L "$SCRIPT_PATH" ]; then

        [ -x "$(command -v readlink)" ] || { echo "Not able to resolve symlink. Install realpath or readlink.";exit 1; }

        # try readlink (-f not needed because we know its a symlink)
        DIR="$( cd "$( dirname $(readlink "$SCRIPT_PATH") )" && pwd -P)"
    else
        DIR="$( cd "$( dirname "$SCRIPT_PATH" )" && pwd -P)"
    fi
else
#    DIR="$( cd "$( dirname "$(realpath "$SCRIPT_PATH")" )" && pwd -P)"
# let's just stop this silliness and set it!
     DIR="/usr/share/opensearch/plugins/opensearch-security/tools"
fi

# add some verbosity for debugging
echo "script_path=${SCRIPT_PATH}"
echo "dir=${DIR}"

BIN_PATH="java"

if [ -z "$JAVA_HOME" ]; then
    echo "WARNING: JAVA_HOME not set, will use $(which $BIN_PATH)"
else
    BIN_PATH="$JAVA_HOME/bin/java"
fi

# set absolute path to /usr/share/opensearch/lib since we're keeping the plugins dir on persistent storage
"$BIN_PATH" $JAVA_OPTS -Dorg.apache.logging.log4j.simplelog.StatusLogger.level=OFF -cp "$DIR/../*:/usr/share/opensearch/lib/*:$DIR/../deps/*" org.opensearch.security.tools.SecurityAdmin "$@" 2>/dev/null

