class CreatePorkbunRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :porkbun_records, id: :uuid, if_not_exists: true, comment: "Individual DNS records known to Porkbun" do |t|
      t.string :type, null: false, default: "A", comment: "DNS record type; defaults to A record"
      t.string :name, null: false, default: "@", comment: "`@` for root domain; `*` for wildcard; other for subdomain"
      t.string :content, null: false, comment: "Answer configured for this record"
      t.string :previous_content, null: true, comment: "Previous answer configured for this record"
      t.integer :ttl, comment: "Time in seconds this value may be cached by a nameserver"
      t.integer :prio, comment: "Priority value, if supported"
      t.integer :porkbun_external_id, index: true, comment: "Record ID assigned at Porkbun; may be null if unknown or unset"

      t.belongs_to :porkbun_domains, foreign_key: true, type: :uuid, null: false, index: true

      t.timestamps precision: nil
    end
  end
end
