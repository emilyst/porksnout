class CreatePorkbunConfigurations < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :porkbun_configurations, id: :uuid, if_not_exists: true, comment: "API configuration for a Porkbun account" do |t|
      t.string :url, null: false, comment: "API base URL", default: "https://porkbun.com/api/json/v3/"
      t.string :api_key, null: false, comment: "API key"
      t.string :secret_key, null: false, comment: "Secret key"
      t.string :nameservers, array: true, null: true, comment: "Default nameservers for domains", default: %w[
        curitiba.ns.porkbun.com
        fortaleza.ns.porkbun.com
        maceio.ns.porkbun.com
        salvador.ns.porkbun.com
      ]
      t.integer :cooldown, null: true, comment: "Seconds to wait between requests"

      t.timestamps precision: nil
    end
  end
end
