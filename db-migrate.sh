#!/usr/bin/env bash
#   Use this script to create a migrate the db

amber db create
amber db migrate
exit $?