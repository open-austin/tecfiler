module TECFiler
  module Test
    
    TESTDIR = File.dirname(__FILE__) + "/.."
    
    PATH_SAMPLE_DATA_CONTRIBUTIONS = "#{TESTDIR}/data/Schedule_A.csv"
    
    PARAMS_COH = {
      :coh_name_first => "Moe",
      :coh_name_last => "Howard",
      :coh_address_street => "100 Congress Ave",
      :coh_address_city => "Austin",
      :coh_address_state => "TX",
      :coh_address_zip  => "78701",
      :coh_phone  => "512-555-0000",
      :treasurer_name_first => "Larry",
      :treasurer_name_last => "Fine",
      :treasurer_address_street => "100 E 1st St",
      :treasurer_address_city => "Austin",
      :treasurer_address_state => "TX",
      :treasurer_address_zip  => "78701",
      :treasurer_phone  => "512-867-5309",
      :period_begin => "2012-01-01",
      :period_end => "2012-03-31",
      :report_type => :ELECTION_8DAY,
    }
    
    PARAMS_CONTRIBUTION = {
      :rec_type => :RECEIPT,
      :form_type => :A1,
      :contributor_type => :INDIVIDUAL,
      :name_first => "Moe",
      :name_last => "Howard",
      :address => "100 Congress Ave",
      :city => "Austin",
      :state => "TX",
      :zip => "78701",
      :date => "20120301",
      :amount => 31.41,
      :employer => "Dewey, Cheatem, and Howe",
      :occupation => "stooge",
    }

    def self.new_thingy(klass, params)
      if params.delete(:create)
        klass.send(:create, params)
      else
        klass.send(:new, params)
      end
    end
    
    def self.new_coh(params = {})
      new_thingy(TECFiler::Model::COH, PARAMS_COH.merge(params))
    end
    
    def self.new_contribution(params = {})
      new_thingy(TECFiler::Model::Contribution, PARAMS_CONTRIBUTION.merge(params))
    end
    
  end # module Test
end # module TECFiler

