# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module ActionPack
      module Patches
        module ActiveSupport
          # Module to append to ActiveSupport::IsolatedExecutionState for instrumentation
          module IsolatedExecutionState
            def share_with(other)
              super
              current_context = OpenTelemetry::Context.current
              OpenTelemetry::Context.clear
              OpenTelemetry::Context.attach(current_context)
            end
          end
        end
      end
    end
  end
end
