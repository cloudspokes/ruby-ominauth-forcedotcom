# Salesforce Strategy for OmniAuth

Included is a Salesforce strategy for OmniAuth along with
a demo application that works on Heroku and is currently
hosted at https://omniforce.heroku.com/

There were a number of challenges building this strategy
and many of them seem to be problems on Salesforce's side.
The authentication flow currently throws 500 errors more
often than it succeeds (I have opened a support request
with Salesforce to find out why).

## Code

The strategy is located at `lib/omniauth/strategies/salesforce.rb`.
Once I have resolution on the 500 error issue, I will be
rolling this into the official OmniAuth repository as well
(I'm the original author of OmniAuth).

The Sinatra demo application is located at `lib/demo_application.rb`.
It's pretty basic but authenticates the user and subsequently
retrieves a list of accounts (even taking into account the
user's instance url, which is provided by my OmniAuth strategy).

## Contact

If you have any questions, feel free to contact me at
michael@intridea.com
