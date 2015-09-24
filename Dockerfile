FROM ruby:2.2.2
# Install system dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm imagemagick netcat

RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile* /myapp/
RUN bundle install --jobs 4
RUN npm install

EXPOSE 3000
ADD . /myapp

CMD bundle exec puma -b tcp://0.0.0.0 -p 3000 -t 5:16
