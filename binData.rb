require "geocoder"

$data = CSV.read("data/modis_2001.csv")
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

def process_data(l_range, h_range, name)
	binned_states = []
	i = l_range
	# success = 0
	while i < h_range do
		# begin
		# 	results = Geocoder.search("#{$arr_of_arrs[i][0]},#{$arr_of_arrs[i][1]}");
		# 	for result in results[0].data['address_components']
		# 		if result['types'].include?('administrative_area_level_1') then
		# 			binned_states.push(result['short_name'])
		# 			success = 1
		# 		end
		# 	end
		# 	binned_states.push('NaN') unless success 			
		# 	i = i + 1
		# 	success = 0
		# 	p i
		# rescue Exception => e 
		# 	p e
		# 	sleep 1
		# 	retry
		# end
		state = in_state($data[i][0].to_f, $data[i][1].to_f)
		p "#{i}: #{state}"
		binned_states.push(state)
		i = i + 1
	end
	$states = binned_states
	# Save cvs file
	# CSV.open(name, "w+b") do |csv|
	#   for strike in binned_states
	#   	csv << [strike]
	#   end
	# end
end

puts "Started At #{Time.now}"
t1=Thread.new{process_data(1, $data.length, "modis1")}
# t2=Thread.new{process_data(($data.length/2.0).ceil, $data.length, "modis2")}
t1.join
# t2.join
# $data1 = CSV.read("modis1.csv")
# $data2 = CSV.read("modis2.csv")
# $states = $data1.push($data2)
# Save cvs file
CSV.open("modis_2001_states.csv", "w+b") do |csv|
	i = 0
	csv << [$data[i][0], $data[i][1], $data[i][2], $data[i][3], $data[i][4], $data[i][5], $data[i][6], $data[i][7], $data[i][8], $data[i][9], $data[i][10], $data[i][11], "State"]
	i = 1
	for data in $states
		csv << [$data[i][0], $data[i][1], $data[i][2], $data[i][3], $data[i][4], $data[i][5], $data[i][6], $data[i][7], $data[i][8], $data[i][9], $data[i][10], $data[i][11], data]
		i = i + 1
	end
end
puts "End at #{Time.now}"