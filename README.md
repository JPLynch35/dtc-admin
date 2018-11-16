# Dress The Child Admin Dashboard

Dress The Child Admin Dashboard is a web portal for the Dress The Child Donation site.  It allows admins to track the electronic donations, along with CRUD functionality to manually track check donations.

## Production Site
---
Coming soon

## Navigating the App
---
All functionality is on the main dashboard page:
* Filter DOnations: Filters the electronic and check donations by date, defaults to all donations within the current calendar year.
* Add Check Donation: Create a donation with a donation_type of "Check". Check donations are tracked in the lower table.

## Getting Started
---
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

This application was created in Rails v5.1.6, utilizing Ruby v2.4.1.

### Installing

Clone the project down locally to your machine.  
```
git clone https://github.com/emmiehayes/dtc-admin.git
```  
Inside the project directory, prepare the gems for development with bundler.  
```
bundle install
``` 
Now create the database and prep the migrations.
```
rake db:{create,migrate}
``` 

### Running the tests

This application is tested with RSpec.  In order to run this test suite, simply call upon RSpec in the terminal while in the project folder.  To produce passing tests, the app requires a Stripe API key which is not provided.
```
rspec
```

## Built With
---
* Ruby 2.4.1- The code language
* Rails 5.1.6- Ruby's web framework
* Stripe API

## Contributors
---
* [Cody Taft](https://github.com/codytaft)
* [Emmie Hayes](https://github.com/emmiehayes)
* [Jesse McFadden](https://github.com/JesseMcBrennan)
* [JP Lynch](https://github.com/JPLynch35)
