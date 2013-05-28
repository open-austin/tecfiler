require "spec_helper"

describe FilersController do
  describe "routing" do

    it "routes to #index" do
      get("/filers").should route_to("filers#index")
    end

    it "routes to #new" do
      get("/filers/new").should route_to("filers#new")
    end

    it "routes to #show" do
      get("/filers/1").should route_to("filers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/filers/1/edit").should route_to("filers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/filers").should route_to("filers#create")
    end

    it "routes to #update" do
      put("/filers/1").should route_to("filers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/filers/1").should route_to("filers#destroy", :id => "1")
    end

  end
end
