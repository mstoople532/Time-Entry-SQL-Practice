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

  def test_time_entries_with_client_name
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT clients.name, time_entries.id, developer_id, project_id, worked_on, duration, time_entries.created_at, time_entries.updated_at FROM time_entries INNER JOIN projects ON time_entries.project_id = projects.id INNER JOIN clients ON projects.client_id = clients.id"
    assert_equal ["Goodwin Group", 500, 50, 30, "2014-09-22", 4, "2015-07-14 16:15:19.621743", "2015-07-14 16:15:19.621743"], db.execute(sql).last
  end
end
