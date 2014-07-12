require 'twitter'

require 'dotenv'
Dotenv.load

#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |c|
  c.consumer_key = ENV['TWITTER_CONSUMER_KEY'] 
  c.consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] 
  c.access_token = ENV['TWITTER_ACCESS_TOKEN'] 
  c.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET'] 
end

search_term = URI::encode('#govhack')

SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end