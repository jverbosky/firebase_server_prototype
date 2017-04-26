require 'sqlite3'

# Open a database
db = SQLite3::Database.new "public/tokens.db"

# Create a table
rows = db.execute <<-SQL
  create table tokens (
    id int primary key,
    email varchar(100),
    fcm_id varchar(180)
  );
SQL

# Insert seed data
id_1 = {"id"=>1, "email"=>"mag@abc.com", "fcm_id"=>"b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"}
id_2 = {"id"=>2, "email"=>"meg@def.org", "fcm_id"=>"c0_N1zLfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-t"}
id_3 = {"id"=>3, "email"=>"mug@hij.com", "fcm_id"=>"d3_B4mJfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8bke-m"}

set_hash = [id_1, id_2, id_3]

set_hash.each do |id_hash|
  v_id = id_hash["id"]
  v_email = id_hash["email"]
  v_fcm_id = id_hash["fcm_id"]
  db.execute("insert into tokens (id, email, fcm_id)
              values (?, ?, ?)", [v_id, v_email, v_fcm_id])
end