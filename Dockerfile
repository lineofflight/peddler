FROM ruby:3.3

RUN mkdir gem
WORKDIR /gem
ADD . /gem
RUN bundle install
CMD bundle exec rake
