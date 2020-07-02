FROM ruby:2.5-slim

LABEL Name=cm-quiz Version=0.0.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app
COPY . /app

COPY Gemfile Gemfile.lock ./
RUN gem install cm_quiz

ENTRYPOINT ["cm-quiz", "test"]
    