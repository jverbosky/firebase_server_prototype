# Example program to insert data into tokens tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

begin

  # fcm_id data sets
  entry_1 = ["mag@abc.com", "b1_D2qKfFdM:APA91bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR76WC1-8GH1cgrCdjDIt7BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-y"]
  entry_2 = ["meg@def.com", "c0_N1zLfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8fjg-t"]
  entry_3 = ["mig@ghi.com"]
  entry_4 = ["mog@jkl.com", "d3_B4mJfFdM:APA32bGUvD0qnBQ9hf4NtJHkuWBBvzHM3mYddRunvGOwgdCLEu0h3EQJF_f9mND7WkxUBR78WC1-8GH1cgrCdjDIt8BzHu9qx7_FLiQSpSvwfzxXfsqaeiqh3r7y30IVwRP5ic8bke-m"]
  entry_5 = ["mug@mno.com"]

  # aggregate entry data into multi-dimensional array for iteration
  entry_list = []
  entry_list.push(entry_1, entry_2, entry_3, entry_4, entry_5)

  # connect to the database
  db_params = {
        host: ENV['host'],  # AWS link
        port:ENV['port'],  # AWS port, always 5432
        dbname:ENV['dbname'],
        user:ENV['dbuser'],
        password:ENV['dbpassword']
      }
  conn = PG::Connection.new(db_params)

  # determine current max index (id) in tokens table
  max_id = conn.exec("select max(id) from tokens")[0]

  # set index variable based on current max index value
  max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1

  # iterate through multi-dimensional entry_list array for data
  entry_list.each do |entry|

    # initialize variables for SQL insert statements
    v_email = entry[0]
    v_fcm_id = entry[1]

    # prepare SQL statement to insert entry data into tokens table
    conn.prepare('q_statement',
                 "insert into tokens (id, email, fcm_id)
                  values($1, $2, $3)")  # bind parameters

    # execute prepared SQL statement
    conn.exec_prepared('q_statement',
                       [v_id, v_email, v_fcm_id])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # increment index value for next iteration
    v_id += 1

  end

rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end