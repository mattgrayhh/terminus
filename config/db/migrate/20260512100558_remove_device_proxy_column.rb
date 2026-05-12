# frozen_string_literal: true

ROM::SQL.migration do
  up { drop_column :device, :proxy }

  down { add_column :devices, :proxy, :boolean, null: false, default: false }
end
