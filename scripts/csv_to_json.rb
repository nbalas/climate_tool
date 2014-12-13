#!/usr/bin/env ruby
require 'csv'
require 'json'
def csv_to_json(csv_file, json_file)
	lines = CSV.open(csv_file).readlines
	keys = lines.delete lines.first
	 
	File.open(json_file, 'w') do |f|
	  f.puts "#{csv_file[5,csv_file.size].chomp('.csv')} ="
	  data = lines.map do |values|
	    Hash[keys.zip(values)]
	  end
	  f.puts JSON.pretty_generate(data)
	end
end