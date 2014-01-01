class AddCountryIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :country_id, :integer, default:1
  end
end
