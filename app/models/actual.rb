require 'csv'

class Actual < ActiveRecord::Base
  scope :reversals, ->() { Actual.where("reference ilike '%revers%'")}

  monetize :debit, :credit, :total

  #TODO: error reporting
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      #make a new actual to store our data
      actual = Actual.new

      #new hash with correct keys
      fixed_row_hash = {}

      #parameterize the CSV headers so they match our database col names
      #assign to new hash
      row.to_hash.map{|key,value| fixed_row_hash[key.to_s.parameterize("_")] = value}

      #loop through our keys
      Actual.new.attributes.keys.each do |col_name|
        #assign values from our fixed hash
        actual.send("#{col_name}=",fixed_row_hash[col_name])
      end

      #save it
      actual.save!
    end
  end
end
