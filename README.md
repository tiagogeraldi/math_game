# Mind Math Game

This an experimental game to practice the combination of Ruby on Rails + Hotwire + Turbo.

Go to [https://mindmath.herokuapp.com/] to see it running. Invite a friend and play.

![alt text](https://github.com/tiagogeraldi/math_game/blob/master/public/demo.png?raw=true)

## The game

Two players answer simple math equations in five rounds, having four alternatives in each round. The game accepts only the first answer. If the answer is correct, who answered scores one point. If it is not, the opponent scores one point. The second player can't answer the equation if the opponent already answered it.

## Running locally

`bundle install`

`bin/rails db:create db:migrate`

`bin/rails s`

Then go to [http://localhost:3000]


## Tests

`bin/rails rake db:migrate RAILS_ENV=test`

`bin/rspec`
