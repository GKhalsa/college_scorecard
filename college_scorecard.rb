require 'csv'
require 'pry'

class ScoreCard
  attr_reader :contents, :max

  def search_file(attribute)
    @contents.select { |row| row[:instnm] if (row[:stabbr] == attribute) }
  end

  def open_file
    @contents = CSV.open "./2013_college_scorecards.csv",
                    headers: true,
                    header_converters: :symbol
  end

  def get_colleges(state)
    results = search_file(state)
  end

  def get_top_sal(num)
    salaries_by_college = {}
    @contents.each { |row| salary = row[:avgfacsal].rjust(10, "0")
                           salary = "0000" if salary == "NULL"
                          college = row[:instnm]
      salaries_by_college[salary] = college
                    }
    return_sorted_sal(num, salaries_by_college).reverse
  end

  def return_sorted_sal(num, salaries_by_college)
    sorted = salaries_by_college.sort_by { |key, value| key }.last(num)
    universities = sorted.map { |array| array[1] }
  end

  def college_debt
    debt_by_college = {}
    @contents.each { |row| debt = row[:grad_debt_mdn]
                        college = row[:instnm]
          debt_by_college[debt] = college
                    }
    debt_sorter(debt_by_college)
  end

  def debt_sorter(debt_by_college)
    schools = debt_by_college.sort.to_h.find_all { |k, v| k.between?("1500", "1600") }
    format_schools_by_debt(schools)
  end

  def format_schools_by_debt(schools)
    list = schools.each { |debt, school| school }
                  .reverse
                  .map { |debt, school| [school, debt].join(" ") }
  end
end

#  max = @contents.max(num) { |row_a, row_b| row_a[:avgfacsal]<=>row_b[:avgfacsal] }
#  @max = max.select {|row| row[:instnm]}
#  @max

sc = ScoreCard.new
sc.open_file
# puts sc.get_top_sal(10)
puts sc.college_debt
