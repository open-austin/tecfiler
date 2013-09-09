ActiveAdmin.register Treasurer do

  menu :priority => 3

  actions :all, :except => [:destroy, :new, :edit, :show]

  index do
    selectable_column
    column :id
    column "Name" do |treasurer|
      treasurer.name
    end
    column "Address" do |treasurer|
      treasurer.address
    end
    column :phone
    column :updated_at
  end

  filter :name
  filter :phone
  filter :updated_at

end
