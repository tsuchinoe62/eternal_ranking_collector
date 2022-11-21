FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
COPY start.sh /myapp/bin
RUN chmod +x /myapp/bin/start.sh
ENTRYPOINT ["start.sh"]
EXPOSE $PORT

CMD ["bin/start"]
