class AddAddressDetailsToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :style, :string
    add_column :invites, :email_address, :string
    add_column :invites, :street, :string
    add_column :invites, :suburb, :string
    add_column :invites, :city, :string
    add_column :invites, :postal_code, :string
    add_column :invites, :country, :string
  end
end
