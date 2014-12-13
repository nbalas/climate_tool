require "geocoder"
require "./csv_to_json"

# Sample input: ruby binData.rb data/modis_2001_states.csv data/modis_2001_states.jsonp
if ARGV.size != 2
  puts 'Usage: csv_to_json input_file.csv output_file.jsonp'
  puts 'This script uses the first line of the csv file as the keys for the JSON properties of the objects'
  exit(1)
end

$data = CSV.read(ARGV[0])
p $data[1][0].to_f

$arr_of_arrs = CSV.read("data/us_states.csv")
$state_ranges = []
$states = []

i = 0
while i < $arr_of_arrs.length do
	$state_ranges.push([$arr_of_arrs[i][0], [$arr_of_arrs[i][1].to_f, $arr_of_arrs[i][2].to_f], [$arr_of_arrs[i][3].to_f, $arr_of_arrs[i][4].to_f]])
	p $state_ranges[i]
	i = i + 1
end

def in_state(lat, lon)
	i = 1
	state = "NaN"
	found = false
	while i < $state_ranges.length && !found do
		lon_b = $state_ranges[i][1][0] <= lon && lon <=  $state_ranges[i][1][1]
		lat_b = $state_ranges[i][2][1] <= lat && lat <=  $state_ranges[i][2][0]
		found = lat_b && lon_b
		state = $state_ranges[i][0] if found
		i = i + 1
	end
	state
end

def process_data(l_range, h_range)
	binned_states = []
	i = l_range
	while i < h_range do
		state = in_state($data[i][0].to_f, $data[i][1].to_f)
		p "#{i}: #{state}"
		binned_states.push(state)
		i = i + 1
	end
	$states = binned_states
end
now = Time.now
puts "Started At #{now}"
# Multithread if needed
t1=Thread.new{process_data(1, $data.length)}
t1.join
# Save cvs file
CSV.open("#{ARGV[1].chomp('jsonp')}.csv", "w+b") do |csv|
	i = 0
	csv << [$data[i][0], $data[i][1], $data[i][2], $data[i][3], $data[i][4], $data[i][5], $data[i][6], $data[i][7], $data[i][8], $data[i][9], $data[i][10], $data[i][11], "State"]
	i = 1
	for data in $states
		csv << [$data[i][0], $data[i][1], $data[i][2], $data[i][3], $data[i][4], $data[i][5], $data[i][6], $data[i][7], $data[i][8], $data[i][9], $data[i][10], $data[i][11], data]
		i = i + 1
	end
end

csv_to_json ARGV[0], ARGV[1]
puts "End at #{Time.now}"
puts "Time elapsed: #{Time.now - now}"