require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
   attr_accessor :name, :grade, :id

   def initialize(name, grade, id = nil)
      @name = name
      @grade = grade
      @id = id
   end

   def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
         id INTEGER PRIMARY KEY,
            name TEXT,
            grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
   end

   def self.drop_table
      sql = "DROP TABLE students"
      DB[:conn].execute(sql)
   end

   def save
      if self.id
         # self.update
         sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
         DB[:conn].execute(sql, self.name, self.grade, self.id)
      else
         sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
         DB[:conn].execute(sql, self.name, self.grade)
         @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
   end
   
   def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
   end


   def self.new_from_db(student)
      id = student[0]
      name = student[1]
      grade = student[2]
      new_student = Student.new(name, grade, id)
      new_student.update
      new_student
   end

   def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?;"
      DB[:conn].execute(sql, name).map{|row| self.new_from_db(row)}[0]
   end

   def update
   sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.grade, self.id)
   # binding.pry
   end

end
