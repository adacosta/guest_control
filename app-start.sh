#!/usr/bin/env bash
#   Use this script to create/migrate the db and start the app

if [ "$AMBER_ENV" = "production" ]
then
  amber db create
  amber db migrate

  ./bin/guest_control
else
  amber watch
fi

exit $?