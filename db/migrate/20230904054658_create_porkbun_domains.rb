class CreatePorkbunDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :porkbun_domains, id: :uuid, if_not_exists: true, comment: "Domain known to Porkbun" do |t|
      t.string :name, null: false
      t.string :nameservers, array: true, null: true, comment: "Nameservers for domain", default: %w[
        curitiba.ns.porkbun.com
        fortaleza.ns.porkbun.com
        maceio.ns.porkbun.com
        salvador.ns.porkbun.com
      ]
      t.boolean :dynamic_dns, null: false, default: false, comment: "Should we automatically update the domain's A record?"

      t.belongs_to :porkbun_configurations, foreign_key: true, type: :uuid, null: false, index: true

      t.timestamps precision: nil
    end
  end
end
