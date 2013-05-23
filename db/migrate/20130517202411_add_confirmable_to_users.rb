class AddConfirmableToUsers < ActiveRecord::Migration
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    add_index :users, :confirmation_token, :unique =>  true
    User.update_all(:confirmed_at => Time.now)
  end

  def down
  	remove_index :users, :confirmation_token
  	remove_column :users, :unconfirmed_email, :string
  	remove_column :users, :confirmation_sent_at, :datetime
  	remove_column :users, :confirmed_at, :datetime
  	remove_column :users, :confirmation_token, :string
  end
end
