ActiveAdmin.register User do

  menu :priority => 4

  actions :all, :except => [:destroy, :new, :edit, :show]

  index do
    selectable_column
    column :id
    column :username
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
  end

  filter :username
  filter :email

end
