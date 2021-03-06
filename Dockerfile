# Use the barebones version of Ruby 2.3.1
FROM ruby:2.3.1-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Nathan Disidore <ndisidore@gmail.com>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql: In case you want to talk directly to postgres
RUN apt-get update && \
    apt-get install build-essential \
                    git \
                    nodejs \
                    libpq-dev \
                    postgresql \
                    postgresql-contrib \
                    -qq -y --fix-missing --no-install-recommends && \
    apt-get autoremove -y && \
    apt-get clean

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /square-plutonium
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Clear the cache
RUN bundle exec rake tmp:cache:clear

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake  RAILS_ENV=production \
                      DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname \
                      SECRET_TOKEN=pickasecuretoken \
                        assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec unicorn -c config/unicorn.rb
