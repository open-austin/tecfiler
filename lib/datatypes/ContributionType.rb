module ContributionType
  RECEIPT = "receipt"
  PLEDGE = "pledge"
  def self.values
    [RECEIPT, PLEDGE]
  end
end