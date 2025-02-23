require "sinatra"
require "sinatra/reloader"
require "http"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_TOKEN']}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data["currencies"].keys

  # @html_list_items = ""
  # @symbols.each do |code, name|
  #   @html_list_items += "<li><a href=\"/#{code}\">Convert 1 #{code} to...</a></li>\n"
  # end

  # render a view template where I show the symbols
  erb(:homepage)
end


get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_TOKEN']}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)

  @symbols = parsed_data["currencies"].keys
  
  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_TOKEN']}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  @parsed_data = JSON.parse(raw_data_string)
  @amount = @parsed_data["info"]["quote"].to_s

  erb(:to_currency)
end
