require 'csv'

class Tweet

  PROPERTIES = [
    :date,
    :impressions,
    :engagements,
    :retweets,
    :replies,
    :likes,
    :url_clicks,
    :hashtag_clicks,
    :follows,

  ]

  PROPERTIES.each {|property| attr_accessor property}


  def initialize args
    args.keys.each {|attr| self.send("#{attr}=", args[attr])}
  end

  def month
    Time.new(*self.date).strftime('%B %Y')
  end

end

tweets = CSV.read './tweets.csv'

tweets.shift

tweets.map! do |tweet|
  args = {
    date:           tweet[3].split('-')[0..1].map(&:to_i),
    impressions:    tweet[4].to_i,
    engagements:    tweet[5].to_i,
    retweets:       tweet[7].to_i,
    replies:        tweet[8].to_i,
    likes:          tweet[9].to_i,
    url_clicks:     tweet[11].to_i,
    hashtag_clicks: tweet[12].to_i,
    follows:        tweet[17].to_i,
  }
  Tweet.new args
end

grouped_tweets = tweets.group_by {|tweet| tweet.month}

csv = ['Month,Tweets,Likes,Retweets,Replies,Engagements,Impressions,Follows from tweets']

grouped_tweets.each do |month, tweets|
  row = [
    month,
    tweets.size,
    tweets.collect {|tweet| tweet.likes}.reduce(:+),
    tweets.collect {|tweet| tweet.retweets}.reduce(:+),
    tweets.collect {|tweet| tweet.replies}.reduce(:+),
    tweets.collect {|tweet| tweet.engagements}.reduce(:+),
    tweets.collect {|tweet| tweet.impressions}.reduce(:+),
    tweets.collect {|tweet| tweet.follows}.reduce(:+)
  ].join(',')
  csv << row
end

File.write 'cats.csv', csv.join("\n")
