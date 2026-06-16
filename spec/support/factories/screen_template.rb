# frozen_string_literal: true

Factory.define :screen_template, relation: :screen_template do |factory|
  factory.association :model
  factory.label "Test"
  factory.name "test"
  factory.content "<h1>Test</h1>"
  factory.created_at { Time.now }
  factory.updated_at { Time.now }
end
