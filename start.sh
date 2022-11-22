#!/bin/sh

# migration
bin/rails db:migrate RAILS_ENV=production

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid

bin/rails s -p 8080 -b 0.0.0.0
