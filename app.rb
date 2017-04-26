require 'sinatra'
require_relative 'sqlite_ops.rb'
require_relative 'output_json.rb'

# class FirebaseServerPrototypeApp < Sinatra::Base

  get "/" do
    erb :start
  end

  post '/post_id' do
    post_data = params[:id]  # assign the user hash to the user_hash variable
    # "Got it: #{params}"  # testing - validate the contents of user_hash (user_name only)
    write_file(post_data)  # save user_hash to a new JSON file (delete & re-create if already present)
    # backend_name = user_hash["user_name"]  # get user_name from hash for listing in get_age.erb
    "Thanks for the info!"
    # erb :get_id, locals: {id_hash: id_hash}
  end

  # post '/post_id' do
  #   id_hash = params[:hash]  # assign the user hash to the user_hash variable
  #   # "Got it: #{params}"  # testing - validate the contents of user_hash (user_name only)
  #   write_json(id_hash)  # save user_hash to a new JSON file (delete & re-create if already present)
  #   # backend_name = user_hash["user_name"]  # get user_name from hash for listing in get_age.erb
  #   # "Thanks for the info: #{backend_name}"
  #   # erb :get_id, locals: {id_hash: id_hash}
  # end


  # post '/post_id' do
  #   id = params[:id]
  #   "#{id}"
  #   # write_db(id_hash)
  #   # instance_id = get_data(id_hash[1])
  #   # erb :get_id, locals: {id_hash: id_hash}
  # end

# end