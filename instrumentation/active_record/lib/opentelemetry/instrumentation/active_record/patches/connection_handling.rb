# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module ActiveRecord
      module Patches
        # Module to prepend to ActiveRecord::Base for instrumentation.
        module ConnectionHandling
          def self.prepended(base)
            class << base
              prepend ClassMethods
            end
          end

          # Contains the ActiveRecord::ConnectionHandling methods to be patched.
          module ClassMethods
            def establish_connection(config_or_env = nil)
              tracer.in_span("#{self}.establish_connection") do
                super
              end
            end

            private

            def tracer
              ActiveRecord::Instrumentation.instance.tracer
            end
          end
        end
      end
    end
  end
end
