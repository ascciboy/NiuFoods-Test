FROM ruby:3.2

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential libpq-dev postgresql-client curl netcat-openbsd


WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY entrypoint-worker.sh /usr/bin/entrypoint-worker.sh
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/entrypoint-worker.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
