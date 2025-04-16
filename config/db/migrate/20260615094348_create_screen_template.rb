# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :screen_template do
      primary_key :id

      foreign_key :model_id,
                  :model,
                  index: true,
                  null: false,
                  on_delete: :cascade,
                  on_update: :cascade

      column :label, String
      column :name, String
      column :content, :text
      column :created_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
      column :updated_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
