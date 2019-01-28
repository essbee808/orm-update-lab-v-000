require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = nil
    @name = name
    @grade = grade
    
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      
     DB[:conn].execute(sql, self.name, self.grade)
     #grab the ID of the row just inserted into the database and assign it to the value of @id attribute of this instance
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade) #create instance with two attributes
    student.save #save instance into students table
    student
  end
  
  def self.new_from_db(row)
    binding.pry
    new_student = self.new()
    
  end
end
