#!/bin/bash
set -euo pipefail

# Ensure gems are installed inside the mounted bundle volume.
bundle check || bundle install

# Rails stores a PID file that blocks restarts when the app volume is mounted.
rm -f tmp/pids/server.pid

exec "$@"
