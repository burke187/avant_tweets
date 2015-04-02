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
# Obviously the above info should not be in a public file, however to make it easier for a reviewer 
# to just run the code instead of pluggin in their own keys, secrets, etc. I'm just going to leave this here.
#GoodGuy
		def collect_tweets
			tweets = []
			words = []
				EM.run do
					client = TweetStream::Client.new 
					EM::PeriodicTimer.new(300) do # Running an EM to run the task over a given period of time 300sec = 5min...in case you were wondering
						client.stop
						end
						client.sample(language: 'en') do |tweet| # English tweets only for the sake of ease and familiarity
							tweets << tweet.text.strip
					end
				end
				tweets.each do |tweet| # Complete tweets return as arrays, so we need to split them into individual word 
						words << tweet.split(/\W+/)
			end
			top_words(words) # Driver code to call next method
		end

		def stop_words # Method to parse our stopwords file containing all the stopwords
			@stopwords = []
			file = File.open('stopwords.txt')
			file.readlines.each do |line|
				@stopwords << line.strip
			end
		end

		def top_words(words) # Method to inject our words stored in arrays into a hash with their corresponding count
			top = Hash.new(0)
			words.each do |tweet|
				tweet.inject(top){ |a,b| a[b] += 1; a }.max{ |word,count| word[1] <=> count[1] }
			end
			filter(top, @stopwords) # Driver code
		end

		def filter(top, stopwords) # Method to sort our words based on count and then filter out stopwords
			top_ten = Hash.new(0)
			sorted = top.sort_by{|word,count| count}.reverse
				sorted.each do |word, count|
						if stopwords.include?(word.downcase) # Tweet cases are all over the place, so just downcase them all to make sure
							next
						elsif top_ten.length <= 9 # We only want the top 10!
							top_ten[word] = count
						end
				end
			puts top_ten
		end

	end
end
Tweets::Stream.new.collect_tweets # Driver code