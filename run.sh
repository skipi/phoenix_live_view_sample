#!/bin/bash
set -ex

mix do deps.get, compile

chown -R $USR deps 
chown -R $USR _build
chgrp -R $GRP deps
chgrp -R $GRP _build

mix phx.server