FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
ADD . /myapp
CMD ["rails","server","-b","0.0.0.0"]
