class CreatePorkbunCertificateBundles < ActiveRecord::Migration[7.0]
  def change
    create_table :porkbun_certificate_bundles, id: :uuid, if_not_exists: true, comment: "Let's Encrypt SSL certificate bundle" do |t|
      t.string :private_key
      t.string :public_key
      t.string :certificate_chain
      t.string :intermediate_certificate

      t.belongs_to :porkbun_domains, foreign_key: true, type: :uuid, null: false, index: true

      t.timestamps
    end
  end
end
