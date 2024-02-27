# MVP API...

NOTE: This repo is only the backend of the project. The React Native Mobile App is [here](https://github.com/macla7/materialUI).

## PLEASE READ

Due to large financial and peer pressure (from my startup mentors), the code in here is NOWHERE near as clean and organised as I would have liked. Minimal testing... etc. Learnt a lot of lessons from this. But yes, please don't look at it too harshly... 🙂

**How to switch between development and production:**

- Look at the '.env' files of both repo, and change the localhost (or specific IP address) url to the url of the heroku application.
- www.shiftmarket.com.au
- https://shiftmarket.herokuapp.com
- http://_IP ADDRESS_:3000

## CURRENT TODO's

Fixes for Anroid Launch:

- Figure out a user Flow.
- With Search, and Discover groups, change query/components so that the users/groups with invites already still show... but the checkbox is disabled and it says something like 'pending'.. cause atm it just disappears.
- make sure you can't comment nothing. Atm blank comments allowed.
- why are my push notifications not working.....?
- Check names of:
  - JavaScript
    - cleaning up the non-used API calls.
    - cleaning up the state and slices.
- do we need the pages/root?
  - do we want a root or any non-api routes?
- Rspec tests.
  - watch up to 3rd video in this guys series (about models)
  - go over my past saved bookmarks on rspec.
  - create the rest of my model tests
- Then submit to apple store (where current submission is)
- We don't want posts to disappear on running out of time... we simply want them to be greyed out... in the bidding section (and the ability to bid is over).. maybe some kind of (x).. won the bidding..
- Omniauth:

  1. deanin vid.. got to 15:00mins in.. hit snag that I need a bundle ID. Appears to be an apple thing. Put this on pause. Done all the 'rails code' for the video i believe.. (had to be edited for my api, jwt token auth setup).

- User Testing
- let's make some tests... shesh.
- add look at specific post ability from groupstack? THought it was already there

**Relevant Deanin videos I want to watch**

- Intro to Rich Comments in Rails 7
- N+1 Query And Performance Optizizations
- Devise Onboarding with Wicked Gem
- Monethly Subscriptions with Stripe and Pay Gem
- The VSCODE Rails Extentions Used in This Series
- notifications Sounds when Messages are Sent in Chat

**Misc Known Issues**

- the cache of user on index from post controller.
- Atm, if blueprint is made, and for some reason notifications and notificationOrigins aren't.. it won't throw any kind of exception. Is this end of the world..? Not ideal, at least. Fails silently.
- Random long logs on image upload
- db protection against lower bids ... ? (Not super necessary, just really doesn't make sense.. won't effect who wins tho)
- Can make a post in a group, then leave or get kicked.. and the post is still there.. but you can't see it? Not functionaly very useful.. should either still see JUST your posts from that group, not be allowed to leave with a live post or Bid (the problem is somewhat the same but not as sever with Bids).. orr red exclaimation mark over your DP on your bids/posts in groups you're no longer in... quirky weird unlikely bug.

**Non MVP features**

- leave group functionality
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
- Login flow that is less clunky than current state check way of doing it

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

**Reset password**

- somewhat based my workflow on suggestions from [this](https://www.truemark.dev/blog/reset-password-in-react-and-rails/) article.

**Email verification flow**

- Heavily based off [this](https://coderwall.com/p/u56rra/ruby-on-rails-user-signup-email-confirmation-tutorial) article

**Push notifications**

- For push notifications, we used the [expo docs](https://docs.expo.dev/push-notifications/push-notifications-setup/) a lot as well as the [ruby sdk community docs](https://github.com/expo-community/expo-server-sdk-ruby)

**SideKiq Jobs**

- [this article](https://prabinpoudel.com.np/articles/setup-active-job-with-sidekiq-in-rails/) helped a lot setting these bad boys up.
