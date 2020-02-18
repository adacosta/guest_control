#!/usr/bin/env bash
#   Use this script to create a migrate the db

amber db create
# sleep because we leave this container running
#  and only want it to migrate once
#  updates will cause a container restart
amber db migrate && sleep infinity