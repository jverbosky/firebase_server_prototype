require 'sinatra'
require_relative 'ios_post_ops.rb'

get "/" do
  erb :start
end

# Route to output post data from iOS app to text file (use for testing/troubleshooting)
# post '/post_id' do
#   id_hash = {"email"=>params[:email], "fcm_id"=>params[:fcm_id]}
#   write_file(id_hash)  # save user_hash to a file
#   "Post successful - thanks for the info!"
# end

# Route to insert post data from iOS app into SQLite database (pre-production)
post '/post_id' do
  id_hash = {"email"=>params[:email], "fcm_id"=>params[:fcm_id]}
  write_db(id_hash)  # save user_hash to a file
  "Post successful - thanks for the info!"
end
