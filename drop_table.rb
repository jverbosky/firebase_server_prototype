# Example program to drop (delete) and create tokens tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

def drop_table()

  begin

    # connect to the database
    db_params = {
          host: ENV['host'],  # AWS link
          port:ENV['port'],  # AWS port, always 5432
          dbname:ENV['dbname'],
          user:ENV['dbuser'],
          password:ENV['dbpassword']
        }
    conn = PG::Connection.new(db_params)

    # drop tokens table if it exists
    conn.exec "drop table if exists tokens"

    # create the tokens table
    conn.exec "create table tokens (
               id int primary key,
               email varchar(100),
               fcm_id varchar(180))"

  rescue PG::Error => e

    puts 'Exception occurred'
    puts e.message

  ensure

    conn.close if conn

  end

end