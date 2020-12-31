# README

This web application will crawl through the webpages and get the Frequent Words and Frequent Word-Pair 
with their count, also this app will crawl through the child links of the parent. 

This app might give you some inconsistent results when you compare the results from the 'control+f '
search command from the browser , this is because I have assumed certain tags to get the text
data from and this data might repeat when fetched.

The tags which I have assumed are

`'p','span','br','h1','h2','h3','h4','h5','h6','strong','em','q','hr','code','li','dt','dd',
'mark','ins','del','sup','sub','small','i','b'`

### Technical Details
* Ruby version 2.6.5
* Rails 6.0.3

### How to run this app ?

Recommended (This way you dont need to do any setup in local) just ensure you have docker installed locally
* Docker pull using command : `docker pull saiprasad0902/314e-hackathon:1.0.0`
* Docker run using : `docker run -d -p 3000:3000 saiprasad0902/314e-hackathon:1.0.0`
* visit `http://localhost:3000/` 

If you wish to build the docker image , then check out the project and run
* `docker-compose build`
* `docker-compose up`
* visit `http://localhost:3000/`
* Please note **UnitTest** case are executed during compose build 

else if you want to run it raw. 

* Install ruby 2.6.4 on your machine 
* check-out the project and run below commands. 
* `bundle install`
* `rails s `
* visit `http://localhost:3000/`

### How to run UnitTest's ?

* check-out the project and run below commands.
* `bundle install`
* `rake test:prepare `
* `rake db:migrate RAILS_ENV=test`
* `bundle exec rake test`

### How to configure CI/CD ?

* Install Jenkins on your machine 
* Create a new PipeLine project 
* Install Docker and Git Plugins
* Setup the GitHub , Docker credentials 
* Install docker client into Jenkins 
* Edit Jenkinsfile in this project as required 
* Run the build

### Other project details for the evaluation

You can find the controller code in : app/controllers/urlparser_controller.rb
Core logic is present in helper file : app/helpers/urlparser_helper.rb
View logic is in : app/views/urlparser/index.html.erb

UnitTest cases can be found in
test/controllers/urlparser_controller_test.rb
test/helpers/urlparser_helper_test.rb

if you have any difficulties in running the application please reach-out to me on
`saiprasad0902@gmail.com `

Cheers! 

