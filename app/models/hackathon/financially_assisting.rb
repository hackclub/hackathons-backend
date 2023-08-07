module Hackathon::FinanciallyAssisting
  def offers_financial_assistance?
    tagged_with? "Offers Financial Assistance"
  end
end
