require 'csv'
require 'pry'

class ScoreCard

  def search_file(attribute)
    @contents.select do |row|
      row[:instnm] if (row[:stabbr] == attribute)
    end
  end

  def open_file
    @contents = CSV.open "./2013_college_scorecards.csv", headers: true, header_converters: :symbol
  end

  def get_colleges(state)
    results = search_file(state)
  end
end

binding.pry
