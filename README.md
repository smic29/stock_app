# Stock App
A Ruby on Rails project made for Avion School

## Requirements
### User
- [x] I want to create an account to buy and sell stocks
- [ ] I want to log in my credentials so that I can access my account on the app
- [x] I want to receive an email to confirm my pending Account signup
- [ ] I want to receive an approval Trader Account email to notify me once my account has been approved
- [ ] I want to buy a stock to add to my investment (Signup should be approved)
- [ ] I want to have a My Portfolio page to see all my stocks
- [ ] I want to have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- [ ] I want to sell my stocks to gain money
### Admin
- [ ] I want to create a new trader to manually add them to the app
- [ ] I want to edit a specific trader to update his/her details
- [ ] I want to view a specific trader to show his/her details
- [ ] I want to see all the trader that registered in the app so I can track all the traders
- [ ] I want to have a page for pending trader sign up to easily check if there's a new trader sign up
- [ ] I want to approve a trader sign up so that he/she can start adding stocks
- [ ] I want to see all the transactions so that I can monitor the transaction flow of the app.

## Styles & Tests
- Bootstrap 
  - [Installation](https://www.rubydoc.info/gems/bootstrap/5.3.2)
- Rspec 
  - [Installation](https://rubygems.org/gems/rspec)

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
#### Thoughts:
The overall idea of this is to have a controller that would provide all of the admin functions and can only be rendered through the admin layout. But that isn't possible, I will just opt for having the admin role display a separate layout from what the users see.