ActiveRecord::Schema.define do
  create_table "notes", force: true do |t|
    t.column "name", :string, limit: 255
    t.column "content", :text
    t.timestamps
  end
end
