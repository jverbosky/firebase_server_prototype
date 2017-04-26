require 'sqlite3'

# Open a database
db = SQLite3::Database.new "public/tokens.db"

# Create a table
rows = db.execute <<-SQL
  create table tokens (
    id int primary key,
    instance_id varchar(180)
  );
SQL

# Execute a few inserts
{
  1 => "b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y",
  2 => "c0_N1zLfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-t",
  3 => "d3_B4mJfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8bke-m"
}.each do |pair|
  db.execute "insert into tokens values ( ?, ? )", pair
end

# Find a few rows
# db.execute( "select * from tokens" ) do |row|
#   p row
# end