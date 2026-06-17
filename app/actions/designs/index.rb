# frozen_string_literal: true

module Terminus
  module Actions
    module Designs
      # The index action.
      class Index < Action
        include Deps[template_repository: "repositories.screen_template"]

        def handle(*, response) = response.render view, templates: template_repository.all
      end
    end
  end
end
