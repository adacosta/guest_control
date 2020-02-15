#!/usr/bin/env bash
#   Use this script to create/migrate the db and start the app

amber db create
amber db migrate

bin/guest_control

exit $?