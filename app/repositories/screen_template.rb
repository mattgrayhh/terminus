# frozen_string_literal: true

module Terminus
  module Repositories
    # The screen template repository.
    class ScreenTemplate < DB::Repository[:screen_template]
      commands :create, update: :by_pk, delete: :by_pk

      def all
        with_model.order { created_at.desc }
                  .to_a
      end

      def find(id) = (with_model.by_pk(id).one if id)

      def find_by(**) = screen_template.where(**).one

      def search key, value
        with_model.where(Sequel.ilike(key, "%#{value}%"))
                  .order { created_at.asc }
                  .to_a
      end

      def where(**)
        with_model.where(**)
                  .order { created_at.asc }
                  .to_a
      end

      private

      def with_model = screen_template.combine :model
    end
  end
end
