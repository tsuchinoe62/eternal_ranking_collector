#!bin/sh

RAILS_PORT=3000
if [ -n "$PORT" ]; then
  RAILS_PORT=$PORT
fi

bin/rails db:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
rm -f tmp/pids/server.pid
bin/rails s -p $RAILS_PORT -b 0.0.0.0
