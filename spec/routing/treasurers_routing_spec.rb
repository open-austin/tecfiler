require "spec_helper"

describe TreasurersController do
  describe "routing" do

    it "routes to #index" do
      get("/treasurers").should route_to("treasurers#index")
    end

    it "routes to #new" do
      get("/treasurers/new").should route_to("treasurers#new")
    end

    it "routes to #show" do
      get("/treasurers/1").should route_to("treasurers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/treasurers/1/edit").should route_to("treasurers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/treasurers").should route_to("treasurers#create")
    end

    it "routes to #update" do
      put("/treasurers/1").should route_to("treasurers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/treasurers/1").should route_to("treasurers#destroy", :id => "1")
    end

  end
end
