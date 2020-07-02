# cm-quiz
> A CLI tool to review your CodementorX project

## Installation💻
Make sure you have a working Ruby environment (2.3 or later is required).

### Install Ruby using [RVM](https://rvm.io/) (for those with older versions of Ruby)
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


## Using Docker

If you want to use it as a container and not install ruby dependencies in your local environment, you can build a docker image and run a container.

### Build the image

```sh
$ docker build -t cm-quiz .
```

### Run the container 

Typical way to run the container

```sh
$ docker run cm-quiz --endpoint=https://your-test-endpoint.com
```

If you're testing on your localhost, then add --net="host" to access from the container

```sh
$ docker run --net="host" cm-quiz --endpoint=http://localhost:5000
```


