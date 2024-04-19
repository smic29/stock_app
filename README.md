# Stock App
A Ruby on Rails project made for Avion School

## Requirements
### User
- [x] I want to create an account to buy and sell stocks
- [x] I want to log in my credentials so that I can access my account on the app
- [x] I want to receive an email to confirm my pending Account signup
- [x] I want to receive an approval Trader Account email to notify me once my account has been approved
- [x] I want to buy a stock to add to my investment (Signup should be approved)
- [x] I want to have a My Portfolio page to see all my stocks
- [x] I want to have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- [x] I want to sell my stocks to gain money
### Admin
- [x] I want to create a new trader to manually add them to the app
- [x] I want to edit a specific trader to update his/her details
- [x] I want to view a specific trader to show his/her details
- [x] I want to see all the trader that registered in the app so I can track all the traders
- [x] I want to have a page for pending trader sign up to easily check if there's a new trader sign up
- [x] I want to approve a trader sign up so that he/she can start adding stocks
- [x] I want to see all the transactions so that I can monitor the transaction flow of the app.

## Styles & Tests
- Bootstrap 
  - [Installation](https://www.rubydoc.info/gems/bootstrap/5.3.2)
- Rspec 
  - [Installation](https://rubygems.org/gems/rspec)
- Font Awesome
  - [Installation](https://docs.fontawesome.com/web/use-with/ruby-on-rails#add-those-icons)

## Processes
### Implementing Mailers:
#### Resources:
- [Devise Wiki](https://github.com/heartcombo/devise/wiki/How-To:-Add-:confirmable-to-Users)
- [Adding Custom mailer](https://github.com/heartcombo/devise/wiki/How-To:-Use-custom-mailer)
  - Experienced an issue wherein I was getting a name error, but simple troubleshooting was able to resolve this issue.
  - The custom mailer should be saved in `app/mailers`
#### Thoughts:
I should look more into how mailer works overall. At the time of writing, I'm activating the accounts by clicking on the links generated on the console, but I am still unsure of how this will turn out in production.
### Implementing the Admin role & having a separate admin layout:
#### Resources:
- [YouTube Video](https://www.youtube.com/watch?v=SxwFyK9OtfY)
#### Process:
Added a boolean `admin` column to my user model, then from there, I followed the video resource to create a function in `application_controller` that would check if `current_user.admin?`. If this returns true, it will render that `admin.html.erb` instead of `application.html.erb`.

On adding the admin role to a user, I opted to just use a console rather than creating a separate sign up page. Simply put, I just used a `<% console %>` on my view then accessed `current_user.admin = true`
#### Thoughts:
The overall idea of this is to have a controller that would provide all of the admin functions and can only be rendered through the admin layout. But that isn't possible, I will just opt for having the admin role display a separate layout from what the users see.
### Using custom views after generating using `rails g devise:views`
#### Resources:
- [Stack Overflow](https://stackoverflow.com/questions/31219466/devise-rails-4-cant-edit-my-new-html-erb-file-under-devise-registration)
#### Thoughts:
Spent a considerable amount of time finding out why my turbo frames weren't able to render `sessions/new` under users properly. Apparently, a configuration needs to be enabled within `devise.rb`, then restart server.
### Making sure admin and user are shown different pages on login
#### Process:
Made an admin controller that would do checks on whether there is a `current_user` and if that user is an admin: `current_user&.admin` (saw this shorthand code from somewhere, it's meant to simplify this: `current_user && current_user.admin`). This is also to make sure that the manual routes I intend to add for the admin controller cannot be utilized if the user isn't an admin. 

Since my login page is located at the root, I also added a redirect on my pages controller so that when a login is completed and it's found that the user is an admin, they would get routed to the proper page.
#### Thoughts:
This could've probably be done better, but I chose to try and implement this on my own using minimal resources. I'll probably circle back to this at a later time or will keep as is -- really depends if I find it necessary.

I also made an admin method in my pages controller just to have a landing page for the admin. Doing this, I felt like there should be a much better method of implementation here, but I can't figure it out right now.

Ideas to make it better:
- Alter devise's `after_sign_in_path_for` helper and have checks made there? 
  - [Resource that could help](https://github.com/heartcombo/devise/blob/main/lib/devise/controllers/helpers.rb#L217)
### Implementing admin manual user creation with confirmation mailer
#### Resources:
- [Ruby docs: Devise skip_confirmation!](https://www.rubydoc.info/github/plataformatec/devise/Devise%2FModels%2FConfirmable:skip_confirmation!)
- [Stack Oveflow: disabled inputs will not be submitted](https://stackoverflow.com/questions/1355728/values-of-disabled-inputs-will-not-be-submitted)
- [Ruby Guides: ActionMailer](https://guides.rubyonrails.org/action_mailer_basics.html)
- [Turbo Handbook: Form events with Turbo](https://turbo.hotwired.dev/reference/events#forms)
#### Process:
Once the logged-in admin initiates a user creation, a form will need to be filled up. The password is randomly generated just to add some privacy for the would-be user. A `skip_confirmation!` is also done in the `create` action to make sure an email confirmation is no longer required.

A hidden field is also added within the form for the `password_confirmation` needed for the registration to be successful. The password is also saved as an instance variable using `user_params[:password]` so that it could be passed on to the mailer.

On successful creation, an email will be sent to the email address provided which includes the user's password and a reminder to change it right away.
#### Learnings:
- Learned that disabled `<input>` would not be included on the params on form submit. Instead, a good way would to just use `readonly`. Since it would have the same effect of not allowing selection and editing.
- In mailer view, using `_path` would not work. Tried out a bunch of things, including `url_for`, but what ultimately fixed the issue is using `_url` instead.
- Files under `app/mailer` act similar to a controller and would look for a corresponding `.html.erb` file with the same action name. Like how this action:
  ```ruby
    def welcome_email
        @user = params[:user]
        @password = params[:password]
        mail(to: @user.email, subject: 'Welcome to Stock App')
    end
    ```
    would look for a file named `welcome_email.html.erb` under the `views/mailer` folder. I opted to add a `default template_path: 'admin/mailer'` to my `admin_mailer.rb` file in order to have mailers generating from the admin organized.
- In order to close the modal and reset the form when a successful form submission is made, I made use of the `turbo:submit-end` event. I added a stimulus action to the form with `data: { action: "turbo:submit-end->modal#submit" }`. To close the modal, it took a bit of googling, but I found that bootstrap has jQuery code for its modal components:
  ```js
    $('#appModal').modal('hide')
  ```
#### Thoughts:
While I think that the password thing is a nice touch. I think it could be done a bit better. Looking into how I've implemented everything, I noticed that I was exposing the password in a lot of places. Once all requirements are done, I may come back to this and implement it a bit better.
### Routes Organization
#### Resources:
- [Rails Guides: Routes](https://guides.rubyonrails.org/routing.html)
#### Process:
Coming into this project, I still had some confusion with regards to routes. So I spent time trying to understand it more.

When I was implementing user actions with regard to the admin, I checked my routes and noticed that while I using `resources :admin`, the routes really didn't make much sense. Since I was creating and updating a user using `/admin` via post.

Looking into how routes, controllers, and views interact with each other. I learned that it's possible to just have an `admin_controller` which would be in the `/admin` route, and use a namespace with the `user_controller` so that I could have routes like `/admin/users`, for example.

This led to me updating my `routes.rb` file to:
```ruby
resources :admin, only: [:index]
namespace :admin do
  resources :users
end
```
This would let me have a `/admin` route where I could stage my turbo frames, and have dedicated routes for RESTful actions for users, such as `/admin/users`, `admin/users/new`, et.al.

While this helped with my routes, I was still confused with how a namespace would interact(or connect?) with these routes. Studying the code and guides more, I noticed that namespacing in the `routes.rb` would also make rails look into the controllers and views folder structure the same way. Like how with `/admin` it would look for an `admin_controller.rb` file in `app/controllers/`.

With that in mind, if I had a route that is `admin/users` it would look for a `users_controller.rb` file in my `app/controllers/admin/` folder. I would just have to namespace that controller with `Admin::UsersController`. This would then work the same way with views.

After looking more into scopes, I found that the routes I intended to have were possible. The idea is to have restful actions for user under the admin namespace, but what I couldn't figure out is how to use `/admin` for my `AdminController`. From studying and testing, I found that I can scope it like so:
```ruby
scope '/admin' do
  get "/" => "admin#home", as: :admin
  get "pending" => "admin#pending", as: :pending_approval
end
namespace :admin do
  resources :users
end
```
I'll be using `/admin` for other stuff besides doing CRUD actions with the user, I chose to scope it.
#### Thoughts
Moving forward, I'll be studying modules and object-oriented programming more to understand how everything works. I think this is just surface-level understanding, but I'm proud and happy with myself that I finally understood how routing works.

After learning about scopes, I think I'll continue to study more about routing just to make sure all my routes are optimal.

### Implementing a dedicated page for pending trader approval
#### Resources:
- [Ruby Guides: How to Use Scopes](https://www.rubyguides.com/2019/10/scopes-in-ruby-on-rails/)
#### Process:
I decided to use the admin controller to display the current pending user trader approvals just so I don't put to many non-CRUD actions in the namespaced admin controller for user.

First I made some scopes in my user model:
```ruby
scope :is_verified_trader, -> { where(approved: true, admin: false).where.not(confirmed_at:nil) }
scope :is_pending_approval, -> { where(approved: false, admin: false).where.not(confirmed_at:nil) }
scope :is_a_user, -> { where(admin: false) }
```
This is so that my admin controller won't have long code and some scopes are also used in the namespaced admin controller.

After which I've made a `pending` action that would display users by running `User.is_pending_aprroval.order(:confirmed_at)`. As per the scope, only users which have confirmed their emails would be eligible to be approved.
#### Thoughts:
I plan to add some more methods in the user model just to abstract away some of the long code I'm using in controllers and views. Some studying is still required, but I'll get it eventually. As of writing, I don't see anything wrong with my implementation of this, but still, this could prove wrong when I start coding tests -- which I should've done alongside coding everything, but I was lazy. Yeah, gots to change that.
### Endpoint for Stock Prices
#### Resources:
- [Basic Yahoo Finance Gem](https://github.com/towards/basic_yahoo_finance/blob/main/README.md)
#### Process:
With the basis of the Basic Yahoo Finance gem, I made a `yahoo_finance.rb` file under the project's `/lib` folder. The file is closely built around how the gem makes external API requests and parsing of the json response from the request made.

In order to use it, a controller needs to require it:
```ruby
require 'yahoo_finance'

# And to initialize the code:
query = YahooFinance::Query.new
data = query.quote('symbol')
```

The url we make requests from is from Yahoo Finance, and since the gem no longer has the updated url to make requests from, I chose to just reference the gem and create my own file.

As to how I found the url to use, I did a project for CS50 and upon reading the provided helper code, I found the base url used to make queries. When I found the basic_yahoo_finance gem, I found that it used the same url, but it was no longer working. Also, the project I was doing under CS50, didn't really utilize JSON responses, but instead was downloading CSV files then parsing that.

I'm still in the process of exploring what data I want to parse from the response, so at this time I'm only getting a `.sample` from the array returned from getting a particular time period's adjusted closing prices. I guess this is also to simulate the changing prices over time.
#### Thoughts:
After finishing the base code for this that works for my specific purpose, I'm contemplating if I should refactor the `lookup_symbol` method to a concern. This is because in the future, I would need to make a portfolio page and I plan to display the current prices from there. Maybe this is just a 'cross that bridge when you get there' kind-of thing.