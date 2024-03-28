# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module ActionPack
      # The Instrumentation class contains logic to detect and install the ActionPack instrumentation
      class Instrumentation < OpenTelemetry::Instrumentation::Base
        MINIMUM_VERSION = Gem::Version.new('6.1.0')

        install do |_config|
          require_railtie
          require_dependencies
          patch
        end

        present do
          defined?(::ActionController)
        end

        compatible do
          gem_version >= MINIMUM_VERSION
        end

        private

        def gem_version
          ::ActionPack.version
        end

        def patch
          Handlers.subscribe
          ActionController::Live.include(Patches::ActionController::Live)
          ActiveSupport::IsolatedExecutionState.prepend(Patches::ActiveSupport::IsolatedExecutionState)
        end

        def require_dependencies
          require_relative 'handlers'
          require_relative 'patches/action_controller/live'
          require_relative 'patches/active_support/isolated_execution_state'
        end

        def require_railtie
          require_relative 'railtie'
        end
      end
    end
  end
end
