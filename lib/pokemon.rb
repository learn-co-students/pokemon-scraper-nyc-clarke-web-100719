class Pokemon
    attr_accessor :name, :type
    attr_reader :db, :id
    
    def initialize(new_hash)
        @id = new_hash[:id]
      @name = new_hash[:name]
      @type = new_hash[:type]
      @db = new_hash[:db]
    end
  
    # def self.create_table
    #   sql = <<-SQL
    #     CREATE TABLE IF NOT EXISTS pokemon (
    #       id INTEGER PRIMARY KEY,
    #       name TEXT,
    #       type TEXT
    #     );
    #   SQL
    #   @db.execute(sql)
    # end
  
    # def self.drop_table
    #   sql = <<-SQL
    #     DROP TABLE pokemon;
    #   SQL
    #   @db.execute(sql)
    # end
  
    def save
      if self.id
        self.update
      else
        sql = <<-SQL
          INSERT INTO pokemon (name, type)
          VALUES (?, ?)
        SQL
        @db.execute(sql, self.name, self.type)
        @id = @db.execute('SELECT last_insert_rowid() FROM pokemon')[0][0]  
      end 
    end
    

    def self.save(name, type, db)
      new_pokemon = self.new(id: nil, name: name, type: type, db: db)
      new_pokemon.save
      new_pokemon
    end

    def self.find(id, db)
        sql = <<-SQL
            SELECT * FROM pokemon
            WHERE id = ?
            LIMIT 1
        SQL

        db.execute(sql, id).map do |row|
            self.new_from_db(row, db)
        end.first
    end
  
    def self.new_from_db(row, db)
      id = row[0]
      name = row[1]
      type = row[2]
      self.new(id: id, name: name, type: type, db: db)
    end
  
    # def self.find_by_name(name)
    #   sql = <<-SQL
    #     SELECT * FROM pokemon
    #     WHERE name = ?
    #     LIMIT 1
    #   SQL
  
    #   DB[:conn].execute(sql, name).map do |row|
    #     self.new_from_db(row)
    #   end.first
    # end
  
    # def update
    #   sql = <<-SQL
    #     UPDATE pokemon
    #     SET name = ?, type = ?
    #     WHERE ID = ?; 
    #   SQL
  
    #   DB[:conn].execute(sql, self.name, self.type, self.id)
    # end
  
end
