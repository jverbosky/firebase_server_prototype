require 'sinatra'
require_relative 'drop_table.rb'
require_relative 'seed_table.rb'
require_relative 'ios_post_ops.rb'

# Route to list all entries in database for easier review when app is hosted on Heroku
get "/" do
  records = get_data()
  erb :list_records, locals: {records: records}
end

get "/reset" do
  drop_table()
  seed_table()
  erb :reset
end

# Route to output post data from iOS app to text file (use for testing/troubleshooting)
# post '/post_id' do
#   id_hash = {"email"=>params[:email], "fcm_id"=>params[:fcm_id]}
#   write_file(id_hash)  # save user_hash to a file
#   "Post successful - thanks for the info!"  # feedback for Xcode console (successful POST)
# end

# Route to insert post data from iOS app into SQLite database (pre-production)
post '/post_id' do
  id_hash = {"email"=>params[:email], "pne_status"=>params[:pne_status], "fcm_id"=>params[:fcm_id]}
  check_db(id_hash)  # update/insert record with fcm_id
  "Post successful - thanks for the info!"  # feedback for Xcode console (successful POST)
end
