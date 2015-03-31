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
			stop_words
		end

		def collect_tweets
			tweets = []
			time = 5
			@words = []
			EM.run do
				client = TweetStream::Client.new
				EM::PeriodicTimer.new(30) do
					client.sample(language: 'en') do |tweet|
						tweets << tweet.text
						client.stop
					end
				end
			end
			tweets.each do |tweet|
				@words << tweet.split(/\W+/)
			end
			top_words(@words, @stopwords)
		end

		def stop_words
			file = File.open('stopwords.txt')
			@stopwords = []
			file.readlines.each do |line|
				@stopwords << line
			end
		end

		def top_words(words, stopwords)
			top = {}
			puts words
			puts stopwords
			words.each do |word|
				word.each do |w|
					top[w] = 1
					if stopwords.include?("#{w}".downcase)
						next
					elsif top.include?(w)
						top[w] =+ 1 
					end
				end
			end
			puts top
		end

	end
end
Tweets::Stream.new.collect_tweets