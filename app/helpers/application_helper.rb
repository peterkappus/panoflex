module ApplicationHelper
  def quarter_year(some_date)
    quarter = (Date.parse(some_date.to_s).strftime("%m").to_i)/3
    Date.parse(some_date.to_s).strftime("Q#{quarter} %Y")
  end

  def display_date(some_date_string)
    Date.parse(some_date_string.to_s).strftime("%d %h %Y")
  end
end
