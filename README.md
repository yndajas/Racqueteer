<img src="public/favicons/mstile-70x70.png" alt="app icon" title="app icon">

# Racqueteer
Keep track of your racquet sports activities with this lightweight web app. Record and review your matches, coaching and racquets, and access a breakdown of each by sport, opponent, coach and more!

You can view a demo of the app over on YouTube: <a href="https://www.youtube.com/watch?v=nK35Tuxfkso" target="_blank" title="app demo on YouTube">youtube.com/watch?v=nK35Tuxfkso</a>.

## Online use

The app is available to use for free at <a href="https://racqueteer.herokuapp.com">racqueteer.herokuapp.com</a>!

## Local use

You can run a copy of the app offline for local use. After cloning or downloading the repository, follow the instructions below.

### Installation

The following instructions are for Windows Subsystem for Linux/Ubuntu, but it's also possible to run the app on other systems. The only difference should be the method for starting the PostgreSQL server - I don't have instructions for this, but <a href="https://www.postgresql.org" target="_blank">check the PostgreSQL website</a> for more information.

Install Ruby (<a href="https://www.ruby-lang.org/en/documentation/installation" target="_blank" title="Ruby installation">help</a>), then in a terminal:
1. `gem install bundler`
2. change directory to Racqueteer (e.g. `cd /mnt/c/Users/yndaj/Documents/GitHub/Racqueteer`, replacing the path with wherever you've downloaded/moved the repository)
3. `bundle install`
4. if you don't have PostgreSQL installed: `sudo apt-get install postgresql`
5. `sudo service postgresql start` (if you get an error saying a user doesn't exist, try the following first, changing '<USERNAME>' to the username mentioned in the error: `sudo -u postgres createuser --superuser <USERNAME>`)
6. `rake resetdb` - or, if you want to start with a clean database (no test data), run `rake db:drop`, `rake db:create` and `rake db:migrate`

### Usage

In a terminal:
1. Make sure you're in the Racqueteer directory (via `cd`)
2. `shotgun`
3. the first line after you execute `shotgun` should contain an address like http://127.0.0.1:9393 - open this address in your browser to start using Racqueteer!

## Features

Record, view, edit and delete information about your racquet sports activities. The following is a breakdown of the structure of Racqueteer, including the information you can record and view.

### Dashboard
Up to five recent matches and coaching sessions, plus a list of all sports and racquets.

### Sports
A list of all sports, and per sport:
- list of matches
- list of coaching sessions
- list of racquets

### Racquets
A list of all racquets grouped by sport, and per racquet:
- sport
- frame brand/model
- string brand/model
- list of matches

### Matches
A list of all matches grouped by sport, and per match:
- sport
- date (start and end if applicable)
- location
- opponent
- result
- score
- list of racquets

### Coaching sessions
A list of all coaching sessions grouped by sport, and per coaching session:
- sport
- date
- location
- list of coaches
- focus
- notes (optional)

### Frame and string brands/models
Lists of all frame brands/models and string brands/models, and per each brand/model:
- list of racquets
- list of matches

### Opponents
A list of all opponents, and per opponent:
- list of matches

### Locations
A list of all locations, and per location:
- list of matches
- list of coaching sessions

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/yndajas/Racqueteer](https://github.com/yndajas/Racqueteer).

## Licence

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits
Logo/favicon made by <a href="https://www.flaticon.com/authors/freepik" target="_blank">Freepik</a>, available <a href="https://www.flaticon.com/free-icon/tennis_3445655" target="_blank" title="Logo/favicon">here</a>.

Background image based on art by <a href="https://www.freepik.com/macrovector" target="_blank">Macrovector</a>, available <a href="https://www.freepik.com/free-vector/vintage-hand-drawn-sports-action-games-seamless-pattern_10603523.htm" target="_blank" title="Background image">here</a>.
