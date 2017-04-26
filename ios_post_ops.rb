require 'sqlite3'

# Method to output data from iOS app post to a text file
def write_file(post_data)
  File.open("public/post_data.txt","w") do |f|  # open the user.json file in the /public directory (create if not present)
    f.write(post_data)  # add the hash to the JSON file and save it
  end
end

# Method to open and return the contents of SQLite database
def read_db()
  if File.exist?('public/tokens.db')
    db = SQLite3::Database.open './public/tokens.db'
  else
    db = []
  end
end

# Method to add current instance_id hash to SQLite db
def write_db(id_hash)
  db = read_db() # open database for updating
  db.results_as_hash  # determine current max index (id) in details table
  max_id = db.execute('select max("id") from tokens')[0][0]
  max_id == nil ? id = 1 : id = max_id + 1  # set index variable based on current max index value
  email = id_hash["email"]  # prepare data from user_hash for database insert
  fcm_id = id_hash["fcm_id"]
  db.execute('insert into tokens (id, email, fcm_id)
              values(?, ?, ?)', [id, email, fcm_id])
end

# Method to update existing record for device
# Write after detetermining what unique value to pass from iOS app
def update_db(id_hash)

end

# Method to return instance_id hash from SQLite db for specified instance_id
def get_data(fcm_id)
  db = read_db()
  db.results_as_hash = true
  user_hash = db.execute("select * from tokens where fcm_id = '#{fcm_id}'")
  return user_hash[0]  # get hash from array
end

#-------------------------------------------
# Sandbox testing
#-------------------------------------------

# write_file("test")

# id_hash_1 = {"email"=>"test@test.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# write_db(id_hash_1)

# id_hash_2 = {"email"=>"another_test@test.com", "fcm_id"=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"}
# write_db(id_hash_2)

# id_2 = "d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"
# p get_data(id_2)