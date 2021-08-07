## Getting start

### Prerequisites
Install [Docker](https://docs.docker.com/docker-for-mac/install/)

Install mysql version 5.7
```shell script
brew install mysql@5.7
brew services start mysql
```
Install redis
```shell script
brew install redis
brew services start redis
```

#### Clone repository and set environment variables

```shell script
git clone git@github.com:wf-janeterziev/demo_project.git

cp .env.sample .env
cp .env.sample .sidekiq_env
```
Fill the empty variables in .env
#### Running the app locally
```shell script
bundle install
rake db:create
rake db:migrate
redis-server
sidekiq
rails s
```

#### Running the app in docker
```shell script
docker-compose build
docker-compose run --rm api bundle install
docker-compose run --rm api rails db:create
docker-compose run --rm api rails db:migrate
docker-compose up
```