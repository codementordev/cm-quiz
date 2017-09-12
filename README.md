# cm-quiz
> A CLI tool to review your CodementorX project

## Installation💻
Make sure you have a working Ruby environment (2.3 or later is required).

### Install Ruby using [RVM](https://rvm.io/) (If you don't have Ruby or your Ruby is too old)
```sh
$ ruby -v
# Make sure your Ruby version is at least 2.3.0, below will demo how to install required Ruby version

$ curl -sSL https://get.rvm.io | bash -s stable

# restart your terminal

$ rvm install 2.3.0
$ rvm use 2.3.0
```


### Install `cm-quiz`
```sh
$ gem install cm_quiz
```


## Start review your quiz🕵️
```sh
$ cm-quiz test --endpoint=https://your-test-endpoint.com
```