FROM ruby:2.7

ENV LC_ALL C.UTF-8

RUN mkdir gem
WORKDIR /gem
ADD . /gem
RUN bundle install
RUN bundle exec appraisal install
CMD bundle exec appraisal rake
