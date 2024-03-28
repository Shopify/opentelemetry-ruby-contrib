# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module ActionPack
      module Patches
        module ActionController
          # Module to append to ActionController::Live for instrumentation
          module Live
            def process_action(*)
              attributes = {
                OpenTelemetry::SemanticConventions::Trace::CODE_NAMESPACE => self.class.name,
                OpenTelemetry::SemanticConventions::Trace::CODE_FUNCTION => action_name
              }
              Instrumentation.instance.tracer.in_span("#{self.class.name}##{action_name} stream", attributes: attributes) do
                super
              end
              OpenTelemetry::Context.clear
            end
          end
        end
      end
    end
  end
end
