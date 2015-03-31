require 'tweetstream'

module Tweets
	class Stream

		def initialize
    		TweetStream.configure do |config|
    			config.consumer_key       = 'd8mwHtVXWjXRWsEp4VuoNuL6U'
    			config.consumer_secret    = 'S6zB0g4sSTKsVnxdoWWBMFkjkHGQhWfY0fWNVaXaRuLtTkAcpf'
    			config.oauth_token        = '1280452981-MfMI0Rhtfef3O556EOT4Id8kpjsH3SQeWLqbhSA'
    			config.oauth_token_secret = 'no7q9T5GJxlttn5K62adeaYzsPA9IcWsNg3wP1dLil099'
    			config.auth_method        = :oauth
			end
		end

		def collect_tweets
			tweets = []
			time = 5
			EM.run do
				client = TweetStream::Client.new
				EM::PeriodicTimer.new(60) do
					client.sample do |tweet|
						tweets << tweet.text
						client.stop
					end
				end
			end
		end

	private

		def stop_words
			file = File.open('stopwords.txt')
			@stopwords = []
			file.readlines.each do |line|
				stopwords << line
			end
		end

	end
end
p Tweets::Stream.new.collect_tweets