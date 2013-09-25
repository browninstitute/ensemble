Story-Collab (Working Title)
============================

Notes
-----

* If errors happen, +bundle update+ and +rake db:migrate+ are your friends!

Setup
-----
* Run `bundle install`
* Rename `/config/initializers/constants.rb.sample` to `constants.rb` and modify the Facebook APP_ID and SECRET.
* Set reconfirmable to false in `devise.rb` if needed.
* Run `rake db:migrate`
* Run `rails server` and you're up and running!

Tests
-----
* Run `rspec spec` to run all tests.

Arrowhead
---------
* Edit `config.arrowhead` in `config/environments/production.rb` if you want.
* Edit `ARROWHEAD_USERIDS` in `config/initializers/constants.rb` and pick user ids that belong to Arrowhead authors!
