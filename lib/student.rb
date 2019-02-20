require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name:, grade:)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM student WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    self.new(result[0], result[1], result[2])
  end

  def self.new_from_db(row)
   new_student = self.new
   new_student.id = row[0]
   new_student.name =  row[1]
   new_student.grade = row[2]
   new_student
   # create a new Student object given a row from the database
 end

end
