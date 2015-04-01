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
			time = 5
			tweets = []
			words = []
			EM.run do
				client = TweetStream::Client.new
				EM::PeriodicTimer.new(time*60) do
					client.sample(language: 'en') do |tweet|
						tweets << tweet.text
						client.stop
					end
				end
			end
			tweets.each do |tweet|
				words << tweet.split(/\W+/)
			end
			top_words(words)
		end

		def stop_words
			file = File.open('stopwords.txt')
			@stopwords = []
			file.readlines.each do |line|
				@stopwords << line.strip
			end
		end

		def top_words(words)
			top = Hash.new(0)
			words.each do |tweet|
				tweet.inject(top){ |a,b| a[b] += 1; a }.max{ |word,count| word[1] <=> count[1] }
			end
			puts top
			filter(top, @stopwords)
		end

		def filter(top, stopwords)
			top_ten = Hash.new(0)
			sorted = top.sort_by{|word,count| count}.reverse
			puts sorted
				sorted.each do |word,count|
						if stopwords.include?(word.downcase)
							next
						elsif top_ten.length <= 9
							top_ten[word] = word && top_ten[count] = count
						end
					end
			puts top_ten
		end

	end
end
Tweets::Stream.new.collect_tweets