require "minitest/autorun"
require "minitest/focus"
require "minitest/pride"
require "bundler/setup"
require "sqlite3"

class TimeEntryTest < Minitest::Test

  def test_time_entries
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT * FROM time_entries"
    assert_equal 500, db.execute(sql).length
  end

  def test_most_recent_developer
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT name FROM developers ORDER BY joined_on DESC LIMIT 1"
    assert_equal [["Dr. Danielle McLaughlin"]] , db.execute(sql)
  end

  def test_number_of_projects_per_client
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT COUNT(client_id) FROM projects GROUP BY client_id"
    assert_equal [[3], [3], [3], [3], [6], [3], [3], [3], [3]], db.execute(sql)
  end
end
