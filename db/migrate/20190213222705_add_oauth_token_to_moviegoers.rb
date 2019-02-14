class AddOauthTokenToMoviegoers < ActiveRecord::Migration[5.2]
  def change
    add_column :moviegoers, :oauth_token, :string
  end
end
