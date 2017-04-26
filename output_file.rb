# Method to output data from iOS app post to a text file
def write_file(post_data)
  File.open("public/post_data.txt","w") do |f|  # open the user.json file in the /public directory (create if not present)
    f.write(post_data)  # add the hash to the JSON file and save it
  end
end

# write_file("test")