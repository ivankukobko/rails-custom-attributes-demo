#!/usr/bin/env sh

rm /app/tmp/pids/*.pid
ruby -v
bundle install -j4 --retry 6

echo 'Running your scripts... '
$@
echo 'Done.'
