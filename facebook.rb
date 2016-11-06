require 'csv'

class FacebookDay

  PROPERTIES = [
    :new_page_likes,
    :engaged_users,
    :reach,
    :impressions,
    :post_impressions,
    :post_mentions,

  ]

  PROPERTIES.each {|property| attr_accessor property}

  def initialize(args)
    args.key.each {|attr| self.send("#{attr}=", args[key])}
  end

end

data = CSV.read './october_to_december_2015.csv'

puts data[0].each_with_index.select {|col, i| col.include?('Daily')}#.select{|col| col.include?('28')}

# data.each {|row| puts row[3452]}

puts data[0][3446]

'28 Days Positive Feedback from Users - comment'
