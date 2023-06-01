# Look on my works, ye mighty, and despair !

How to switch between development and production:

- Look at the '.env' files of both repo, and change the localhost (or specific IP address) url to the url of the heroku application.
- www.shiftmarket.com.au
- _IP ADDRESS_:3000

## CURRENT TODO's

- Check names of:
  - Methods
  - Objects and variables
  - functions
    In:
  - Models
  - Controllers
  - JavaScript
- Refactor functions to be:
  - Smaller
  - 1 or 2 parameters
  - dependency injection
  - No train wrecks
- Address possible active record / model design issues?
  - Is my business logic in the data structures..?
- Rspec tests.
- Then submit to apple store (where current submission is)
- Omniauth:

  1. deanin vid.. got to 15:00mins in.. hit snag that I need a bundle ID. Appears to be an apple thing. Fuck. Put this on pause. Done all the 'rails code' for the video i believe.. (had to be edited for my api, jwt token auth setup).

- User Testing
- let's make some damn tests... shesh.

**Relevant Deanin videos I want to watch**

- Intro to Rich Comments in Rails 7
- N+1 Query And Performance Optizizations
- Devise Onboarding with Wicked Gem
- Monethly Subscriptions with Stripe and Pay Gem
- The VSCODE Rails Extentions Used in This Series
- Notificaiton Sounds when Messages are Sent in Chat

**Misc Known Issues**

- the cache of user on index from post controller.
- Atm, if blueprint is made, and for some reason notifications and notificationOrigins aren't.. it won't throw any kind of exception. Is this end of the world..? Not ideal, at least. Fails silently.
- Random long logs on image upload
- db protection against lower bids ... ? (Not super necessary, just really doesn't make sense.. won't effect who wins tho)

**Non MVP features**

- calendar view
- Put groups under home.
  - Nest all the group screens under home.
- Stripe
  - research into Stripe
  - research into pay gem
- Twilio (maybe when I get a feaking phone number again)
- Limit retrieved notifications, and then just have a 'view more' to retrieve the next older batch.
- follow posts ( followers (?))
- Viewed (Shows number of views on posts)
- DB protections to stop duplicate memberships.
- Ejecting from Expo?
- Using variable font?
- Maybe 10 or so default DP's to choose from
- Reacts (likes and what not)

## Design Notes

**To get the API signin / signup working, I follow Deanin's videos:**

- [Devise API](https://www.youtube.com/watch?v=PqizV5l1yFE&ab_channel=Deanin)
- [Doorkeeper API (devise also..)](https://www.youtube.com/watch?v=Kwm4Edvlqhw&ab_channel=Deanin)

But the following articles helped even more I reckon

- [This guide](https://rubyyagi.com/rails-api-authentication-devise-doorkeeper/) seems to be basially what he built his doorkeerer video off. Also it can be found in the guides in doorkeeper gem on github
- Followed only some parts of [this guide](https://www.bluebash.co/blog/rails-6-7-api-authentication-with-jwt/), roughly, to get my JWT up and running.

**Other articles and notes**

- Invites is the trickest of my tables.. There is a boolean "request" that essentially determines whether the invite was sent to an external user, or requested by an external user. This means the API and controller is a bit more clunky.
- For notifications, primairly followed [this guide](https://tannguyenit95.medium.com/designing-a-notification-system-1da83ca971bc) but changed a fair amount of the naming.
- [Deanin video](https://www.youtube.com/watch?v=_rLMRd676-I&ab_channel=Deanin) that helped get me off the ground re avatar upload to api from react frontend. Articles he uses are in the comments.
- To store my JWT cookies in native app, using [SecureStore from Expo](https://docs.expo.dev/versions/latest/sdk/securestore/)

**React DateTimePicker**

-[Docs here](https://github.com/react-native-datetimepicker/datetimepicker)

**LinearGradient in Expo**

-[Docs here](https://docs.expo.dev/versions/latest/sdk/linear-gradient/#usage)

**React Native SVG**

-[Docs here](https://github.com/react-native-svg/react-native-svg#use-with-svg-files)

- Need the [transformer](https://github.com/kristerkari/react-native-svg-transformer#installation-and-configuration) too if importing from files.

**S3 Storage**

- heavily based off [this](https://www.honeybadger.io/blog/rails-app-aws-s3/) article.

**ActionCable**

- [This guide](https://dev.to/tegandbiscuits/using-action-cable-with-react-native-jk0) helped me a fair bit get the code implemented.
- The [ActionCable](https://guides.rubyonrails.org/action_cable_overview.html) docs themselves also helped a fair bit.
- Probably a big TODO with production is to figure out / learn how it'll work if I use redis to implement it, which seems to be the way most guides do. Atm development I've just revereted back to 'async'. So I don't have to manually start some redis server I don't know much about.
- [This](https://www.youtube.com/watch?v=NwQEZXnVXJ8&ab_channel=SaloniMehta) video was also pretty good in terms of high level example of what was going on. Don't try to implement the details tho..

**ENV Variables**

- EDITOR="code --wait" rails credentials:edit .. NOT using anymore
- Using two separate dotenv setups.. one .env file for API and another for react-native app.
- Just go into .env to edit
- Theoretically in prod, I am simply going to set with heroku interface somehow..

**Splash Screen and Icons**

- Created using Figma as per the expo guides [here](https://docs.expo.dev/guides/app-icons/)

**BIG ISSUES BEATEN**

- Spent probably all day, 5+hrs, trying to get fonts to work by customising react native base themes. What seemed to fix it in the end was a version update of 'native-base' itself using 'yarn upgrade native-base'..
- Now it seems native-base doesn't like it if I try to set a customer font-Weight..
- Uploading images via expo image picker, using form data as per [this SO Post](https://stackoverflow.com/a/46740071/17632294)

# STAPI

**Reset password**

- somewhat based my workflow on suggestions from [this](https://www.truemark.dev/blog/reset-password-in-react-and-rails/) article.

**Email verification flow**

- Heavily based off [this](https://coderwall.com/p/u56rra/ruby-on-rails-user-signup-email-confirmation-tutorial) article
