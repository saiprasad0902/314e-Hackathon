FROM ruby:2.6.5

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz

# Yarn(Node package manager) installation
RUN apt-get update && apt-get install -y nodejs yarn


RUN mkdir /314e_WordFrequency
WORKDIR /314e_WordFrequency
COPY Gemfile /314e_WordFrequency/Gemfile
COPY Gemfile.lock /314e_WordFrequency/Gemfile.lock


RUN gem update --system
RUN gem update bundler

RUN bundle install
COPY . /314e_WordFrequency


# Run Tests
RUN bundle install
RUN rake test:prepare
RUN rake db:migrate RAILS_ENV=test
RUN bundle exec rake test


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

