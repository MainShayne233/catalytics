require 'csv'

class FacebookDay

  PROPERTIES = [
    :date,
    :new_page_likes,
    :engaged_users,
    :impressions,
    :page_views
  ]

  PROPERTIES.each {|property| attr_accessor property}

  def initialize(args)
    args.keys.each {|attr| self.send("#{attr}=", args[attr])}
  end

  def month
    Time.new(*self.date).strftime('%B %Y')
  end

end

data = []

[
  './october_to_december_2015.csv',
  './january_to_march_2016.csv',
  './april_to_june_2016.csv',
  './july_to_october_2016.csv',
].each do |csv|
  csv_data = CSV.read csv
  csv_data.shift
  csv_data.shift
  csv_data.each  do |day|
    args = {
      date: day[0].split('-')[0..1].map(&:to_i),
      new_page_likes: day[2].to_i,
      engaged_users: day[4].to_i,
      impressions: day[16].to_i,
      page_views: day[27].to_i,
    }
    data << FacebookDay.new(args)
  end
end

grouped_days = data.group_by {|day| day.month}

csv = ['Month,New Page Likes,Engaged Users,Impressions,Page Views']

grouped_days.reverse_each do |month, days|
  row = [
    month,
    days.collect {|day| day.new_page_likes}.reduce(:+),
    days.collect {|day| day.engaged_users}.reduce(:+),
    days.collect {|day| day.impressions}.reduce(:+),
    days.collect {|day| day.page_views}.reduce(:+),
  ].join(',')
  csv << row
end

File.write 'facebook.csv', csv.join("\n")
