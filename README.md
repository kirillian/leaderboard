# leaderboard
## How to install
### Vagrant
Install vagrant if you don't have it:
http://docs.vagrantup.com/v2/installation/

### Clone the repo
```bash
git clone https://github.com/kirillian/leaderboard.git
cd leaderboard
```

### Create config files
```bash
cp vagrant.yml.example vagrant.yml
cp config/database.yml.example config/database.yml
```

Edit the two config files you just created and add the database password you want to use to line 5 in ```vagrant.yml``` and line 26 in ```database.yml```

### Generate Vagrant
**This step may take 30minutes or more depending on how long it takes you to download all the necessary installers and build Ruby.**

You may need to install some vagrant plugins if you don't have them yet. The ```vagrant up``` step below should tell you the EXACT commands you need to install them.

```bash
vagrant up
```

### Log into the Vagrant Client
```bash
vagrant ssh
```

### Initialize the environment
```bash
rake db:create
rake db:schema:load
```

### Start the services
```bash
sudo service redis6379 start
bundle exec sidekiq
rails s puma
```

### Start the rest_client script
Open another tab in your console and cd into the leaderboard folder
```bash
cd <path>/leaderboard
ruby rest_client.rb
```

### Watch the magic happen
Open a browser to http://localhost:3000

The Rest Client script is constantly adding and removing scores from the leaderboard using the application's API. The page you have navigated to will update approximately once per second with the latest high scores.

