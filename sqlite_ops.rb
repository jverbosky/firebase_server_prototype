require 'sqlite3'
require 'base64'

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
  instance_id = id_hash["instance_id"]  # prepare data from user_hash for database insert
  db.execute('insert into tokens (id, instance_id)
              values(?, ?)', [id, instance_id])
end

# Method to update existing record for device
# Write after detetermining what unique value to pass from iOS app
def update_db(id_hash)

end

# Method to return instance_id hash from SQLite db for specified instance_id
def get_data(instance_id)
  db = read_db()
  db.results_as_hash = true
  user_hash = db.execute("select id, instance_id from tokens where instance_id = '#{instance_id}'")
  return user_hash[0]  # get hash from array
end

# id_1 = "b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"
# get_data(id_1)

# id_hash_1 = {"instance_id" => "d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"}
# write_db(id_hash_1)

# id_2 = "d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"
# p get_data(id_2)