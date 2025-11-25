FROM ruby:3.2

WORKDIR /sim

RUN gem install typhoeus

COPY load_test.rb /sim/

CMD ["ruby", "/sim/load_test.rb"]
