require 'sqlite3'

# Method to output data from iOS app post to a text file (use for testing/troubleshooting)
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

# Method to insert record for device into SQLite db
def write_db(id_hash)
  db = read_db()  # open database for querying
  db.results_as_hash  # format query results as a hash so columns available as keys
  max_id = db.execute('select max("id") from tokens')[0][0]  # determine current max index (id) in details table
  max_id == nil ? id = 1 : id = max_id + 1  # set index variable based on current max index value
  email = id_hash["email"]  # prepare email address for database insert
  fcm_id = id_hash["fcm_id"]  # prepare Firebase token for database insert
  db.execute('insert into tokens (id, email, fcm_id)
              values(?, ?, ?)', [id, email, fcm_id])
end

# Method to update existing record for device in SQLite db
def update_db(id_hash)
  email = id_hash["email"]  # prepare email address for db record selection
  fcm_id = id_hash["fcm_id"]  # prepare Firebase token for record update
  db = read_db() # open database for updating
  db.execute('update tokens set fcm_id = ? where email = ?', fcm_id, email)
end

# Method to determine whether to insert or update record
def check_db(id_hash)
  email = id_hash["email"]  # prepare email address for database query
  db = read_db()  # open database for querying
  db.results_as_hash = true  # format query results as a hash so columns available as keys
  result = db.execute('select email from tokens where email = ?', email)
  result == [] ? write_db(id_hash) : update_db(id_hash)
end

# Method to return all records from SQLite db for reviewing entries via Heroku
def get_data()
  db = read_db()  # open database for querying
  db.results_as_hash = true  # format query results as a hash so columns available as keys
  all_records = db.execute('select * from tokens')
  return all_records  # get hash of arrays
end

#-------------------------------------------
# Sandbox testing
#-------------------------------------------

#-------------------------------------------
# 1 - File write test
#-------------------------------------------

# write_file("test")

#-------------------------------------------
# 2 - Database insert tests
#-------------------------------------------

# id_hash_1 = {"email"=>"test@test.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# write_db(id_hash_1)

# id_hash_2 = {"email"=>"another_test@test.com", "fcm_id"=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"}
# write_db(id_hash_2)

#-------------------------------------------
# 3 - Database read test
#-------------------------------------------

# id_2 = "d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"
# p get_data(id_2)

#-------------------------------------------
# 4 - Database update test
#-------------------------------------------

# update_1 = {"email"=>"mag@abc.com", "fcm_id"=>"m7_F8mLbKeD:WKD91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# update_db(update_1)

#-------------------------------------------
# 5 - Database check tests (insert/update)
#-------------------------------------------

# Test for existing record
# record_1 = {"email"=>"mag@abc.com", "fcm_id"=>"m8_F8mLbKeD:WKD91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# check_db(record_1)
# Output of result using p:
# [{"email"=>"mag@abc.com", 0=>"mag@abc.com"}]

# Test for no record
# record_2 = {"email"=>"new@user.com", "fcm_id"=>"r9_G5qPaCfW:LWK72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# check_db(record_2)
# Output of result using p:
# []

#-------------------------------------------
# 6 - Get database records
#-------------------------------------------

# p get_data()
# Output:
# [{"id"=>1, "email"=>"mag@abc.com", "fcm_id"=>"m8_F8mLbKeD:WKD91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y", 0=>1, 1=>"mag@abc.com", 2=>"m8_F8mLbKeD:WKD91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"},
#  {"id"=>2, "email"=>"meg@def.org", "fcm_id"=>"c0_N1zLfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-t", 0=>2, 1=>"meg@def.org", 2=>"c0_N1zLfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-t"},
#  {"id"=>3, "email"=>"mug@hij.com", "fcm_id"=>"d3_B4mJfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8bke-m", 0=>3, 1=>"mug@hij.com", 2=>"d3_B4mJfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8bke-m"},
#  {"id"=>4, "email"=>"test@test.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y", 0=>4, 1=>"test@test.com", 2=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"},
#  {"id"=>5, "email"=>"another_test@test.com", "fcm_id"=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m", 0=>5, 1=>"another_test@test.com", 2=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"},
#  {"id"=>6, "email"=>"new@user.com", "fcm_id"=>"r9_G5qPaCfW:LWK72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y", 0=>6, 1=>"new@user.com", 2=>"r9_G5qPaCfW:LWK72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"},
#  {"id"=>7, "email"=>"test@test.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y", 0=>7, 1=>"test@test.com", 2=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"},
#  {"id"=>8, "email"=>"another_test@test.com", "fcm_id"=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m", 0=>8, 1=>"another_test@test.com", 2=>"d7_F8mLmIqA:JDM72bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-m"},
#  {"id"=>9, "email"=>"user@company.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y", 0=>9, 1=>"user@company.com", 2=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
# ]