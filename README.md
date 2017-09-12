# cm-quiz
> A cli tool to review your Codementor quiz

## How to install

```sh
$ ruby -v
# Make sure your Ruby version is at least 2.3.0, below will demo how to install required Ruby version

$ gem install cm_quiz
```

### Install Ruby using [RVM](https://rvm.io/)
```sh
$ curl -sSL https://get.rvm.io | bash -s stable

# restart your terminal

$ rvm install 2.3.0
$ rvm use 2.3.0
```


## Start review your quiz
```sh
$ cm-quiz test --endpoint=https://your-test-endpoint.com
```