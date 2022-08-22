FROM ruby:3.5

ENV LC_ALL C.UTF-8

RUN mkdir gem
WORKDIR /gem
ADD . /gem
RUN bundle install
CMD bundle exec rake
