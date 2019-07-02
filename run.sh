#!/bin/bash
set -ex

mix do deps.get, compile

cd assets && npm install && cd ..

chown -R $USR deps 
chown -R $USR _build
chown -R $USR assets/node_modules
chgrp -R $GRP deps
chgrp -R $GRP _build
chgrp -R $GRP assets/node_modules


mix phx.server