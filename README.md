BRAINSTORM
==========
BrainStorm is a quiz/treasure hunt hosting engine with highly flexible functionality and super cool analytics graphs (yay!).
It is also tightly integrated with Facebook API and can handle publicity and secondary registrations all by itself.
BrainStorm is developed by Test-Driven approach(TDD) and is backed by more than 250 examples.

Features (available for admins)
-------------------------------
* Registrations/Day chart available to give insight about growth and activity.
* Colleges Participation chart to list out the colleges/universities which are most active in gameplay.
* College's high-scores and regisrations bar chart to list which colleges are leading with scores and registrations count.
* Facebook-vs-Manual signups pie. Delight!
* Level-vs-Attempts chart. Interesting and highly useful feature. Tells:
   + How many _total attempts_ a level has took.
   + How many attempts did Top 3 rankers took to solve each level.
   + Helps understanding the complexity of each level from user's point of view.
* View attempts of any participant with timestamps.
* Observe a user: 
   + Provides a line chart(like stock market) and pinpoints tell how long that user is taking to solve any level.
   + Great utility for judging a user for using unfair means.
   + Also has bar chart listing how many attempts that user took to solve any level.
* If these features are not enough, BrainStorm also offers to update the user's FB wall(if signed up from FB) with euphoric status when level is solved.
* A user can enter his guess in any way his want, irrespective of punctuations, case and spaces. Strong regexp filter everything out.
* Admin can create/modify and add hints on levels dynamically. Everything available at admin board.

How to Install
--------------
* Get `ruby 1.9.3+`
* Fork the project.
* Run `bundle install` to install all gems required to run the application.
* Setup a Facebook application which will power secondary mode of registrations on application.
* Add *APP_ID* and *APP_SECRET* to config/secret_credentials.yaml
* Then, simply fire: 

```ruby
rake db:create
rake db:migrate
rake game:setup
```
**That's it!**

Running the Game
----------------
```ruby
rake game:start
```

Stopping the Game
----------------
```ruby
rake game:stop
```
Tests
-----
Backed by more than 260 requests, model and controller tests. Almost every level of code is test covered.
Run tests by following: 
```ruby
bundle exec rspec spec/ -f d
```

Statistics
----------
* First instance of this system was ran from 14 - 20th March 2013.
* Registered more than 3,400 users.
* Page Views > 254,471
* Visits > 16,000
![Registrations chart](http://i.imgur.com/hGyOPVV.png)
