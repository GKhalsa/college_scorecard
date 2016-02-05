require 'csv'
require 'pry'

class ScoreCard

 attr_reader :contents, :max

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

  def get_top_sal(num)
    salaries_by_college = {}
    @contents.each do |row|
      salary = row[:avgfacsal].rjust(10, "0")
      college = row[:instnm]
      if salary == "NULL"
        salary = "0000"
      end
    salaries_by_college[salary] = college
    end
    return_sorted_sal(num, salaries_by_college).reverse
  end

  def return_sorted_sal(num, salaries_by_college)
    sorted = salaries_by_college.sort_by do |key, value|
      key
    end.last(num)
    universities = sorted.map do |array|
      array[1]
    end
  end

  def college_debt
    debt_by_college = {}
    @contents.each do |row|
      debt = row[:grad_debt_mdn]
      college = row[:instnm]
      debt_by_college[debt] = college
    end
    debt_sorter(debt_by_college)
  end

  def debt_sorter(debt_by_college)
    sorted = debt_by_college.find_all do |k,v|
      k.to_i.between?(1500, 2300)
    end
  end

end

#  max = @contents.max(num) { |row_a, row_b| row_a[:avgfacsal]<=>row_b[:avgfacsal] }
#  @max = max.select {|row| row[:instnm]}
#  @max

sc = ScoreCard.new
sc.open_file
# puts sc.get_top_sal(10)
puts sc.college_debt
