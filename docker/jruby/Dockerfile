FROM jruby:9

RUN apt-get update -qq && apt-get install -y \
    mysql-client \
    postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY apartment.gemspec /app/
COPY lib/apartment/version.rb /app/lib/apartment/version.rb
COPY Gemfile /app/
COPY gemfiles/* /app/gemfiles/
COPY Appraisals /app/

RUN bundle install --without local --jobs=4 --path=vendor/bundle && \
    bundle exec appraisal install

COPY . /app
