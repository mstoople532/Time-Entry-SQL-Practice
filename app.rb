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

  def test_all_Ohio_Sheep_developers
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT developers.name FROM developers INNER JOIN group_assignments ON developers.id = group_assignments.developer_id INNER JOIN groups ON group_assignments.group_id = groups.id WHERE groups.name='Ohio sheep'"
    assert_equal [["Bruce Wisoky Jr."], ["Eli Wunsch MD"], ["Reyes Vandervort IV"]], db.execute(sql)
  end

  def test_total_hours_per_client
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT SUM(duration), clients.name FROM time_entries INNER JOIN projects ON time_entries.project_id = projects.id INNER JOIN clients ON projects.client_id = clients.id GROUP BY clients.id"
    assert_equal [238, "Goodwin Group"], db.execute(sql).last
  end

  def test_client_lupe_worked_most_hours_for
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT SUM(duration), developers.name, clients.name FROM developers INNER JOIN time_entries ON developers.id = time_entries.developer_id INNER JOIN projects ON time_entries.project_id = projects.id INNER JOIN clients ON projects.client_id = clients.id WHERE developers.name = 'Mrs. Lupe Schowalter' GROUP BY clients.id ORDER BY SUM(duration) DESC LIMIT 1"
    assert_equal [[11, "Mrs. Lupe Schowalter", "Kuhic-Bartoletti"]], db.execute(sql)
  end

  def test_list_all_client_names_with_their_project_names
    db = SQLite3::Database.new "time_entries.sqlite3"
    sql = "SELECT clients.name, projects.name FROM clients LEFT JOIN projects ON clients.id = projects.client_id"
    assert_equal 33, db.execute(sql).length
  end
end
