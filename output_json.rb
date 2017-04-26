require 'json'

def write_file(post_data)
  File.open("public/post_data.txt","w") do |f|  # open the user.json file in the /public directory (create if not present)
    f.write(post_data)  # add the hash to the JSON file and save it
  end
end

def write_json(user_hash)
  File.open("public/user.json","w") do |f|  # open the user.json file in the /public directory (create if not present)
    f.write(JSON.pretty_generate(user_hash))  # add the hash to the JSON file and save it
  end
end

def append_json(user_hash)
  data_from_json = JSON[File.read('public/user.json')]  # ready/copy the contents of the user.json file
  File.open("public/user.json","w") do |f|  # open the user.json file in the /public directory
    f.write JSON.pretty_generate(data_from_json.merge(user_hash))  # combine the user.json and user_hash hashes and write to user.json
  end
end

def read_json()
  data_from_json = JSON[File.read('public/user.json')]  # read/copy the contents of the user.json file
end

# write_file("test")