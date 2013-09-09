ActiveAdmin.register Filer do

  menu :priority => 2

  actions :all, :except => [:destroy, :new, :edit, :show]

  index do
    selectable_column
    column :id
    column :filer_type
    column "Name" do |filer|
      filer.name
    end
    column "Address" do |filer|
      filer.address
    end
    column :phone
    column :updated_at
  end

  filter :filer_type
  filter :name
  filter :phone
  filter :updated_at

end
