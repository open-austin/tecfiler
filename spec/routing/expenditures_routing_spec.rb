require "spec_helper"

describe ExpendituresController do
  describe "routing" do

    it "routes to #index" do
      get("/expenditures").should route_to("expenditures#index")
    end

    it "routes to #new" do
      get("/expenditures/new").should route_to("expenditures#new")
    end

    it "routes to #show" do
      get("/expenditures/1").should route_to("expenditures#show", :id => "1")
    end

    it "routes to #edit" do
      get("/expenditures/1/edit").should route_to("expenditures#edit", :id => "1")
    end

    it "routes to #create" do
      post("/expenditures").should route_to("expenditures#create")
    end

    it "routes to #update" do
      put("/expenditures/1").should route_to("expenditures#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/expenditures/1").should route_to("expenditures#destroy", :id => "1")
    end

  end
end
