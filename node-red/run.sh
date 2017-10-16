#!/bin/bash
CONFIG_PATH=/data/options.json

SSL=$(jq --raw-output ".ssl" $CONFIG_PATH)
KEYFILE=$(jq --raw-output ".keyfile" $CONFIG_PATH)
CERTFILE=$(jq --raw-output ".certfile" $CONFIG_PATH)

if [ ! -e /data/settings.js ]; then
    cp /settings.js /data/settings.js
fi

# Add ssl configs
if [ "$SSL" == "true" ]; then
    sed -i 's/.*var fs = require("fs")/var fs = require("fs")/g' /data/settings.js
    sed -i '/https: {/,/}/ s/\/\///' /data/settings.js
    sed -i "s/.*key: fs.readFileSync('.*'),/        key: fs.readFileSync(\'\/ssl\/$KEYFILE\'),/g" /data/settings.js
    sed -i "s/.*cert: fs.readFileSync('.*')/        cert: fs.readFileSync(\'\/ssl\/$CERTFILE\')/g" /data/settings.js
else
    sed -i 's/.*var fs = require("fs")/\/\/var fs = require("fs")/g' /data/settings.js
    sed -i '/^[ ]*https: {/,/}/ s/^[ ]*/    \/\//' /data/settings.js
    sed -i "s/.*key: fs.readFileSync/    \/\/    key: fs.readFileSync/g" /data/settings.js
    sed -i "s/.*cert: fs.readFileSync/    \/\/    cert: fs.readFileSync/g" /data/settings.js
fi

[ -d /data/node_modules/node-red-contrib-home-assistant ] || { \
    cd /data && npm install node-red-contrib-home-assistant ; }

cd /usr/src/node-red
npm start -- --userDir /data
