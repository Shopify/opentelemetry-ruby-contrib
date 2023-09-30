# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

require_relative '../../../../lib/opentelemetry/instrumentation/active_record'
require_relative '../../../../lib/opentelemetry/instrumentation/active_record/patches/connection_handling'

describe OpenTelemetry::Instrumentation::ActiveRecord::Patches::ConnectionHandling do
  let(:exporter) { EXPORTER }
  let(:spans) { exporter.finished_spans }

  before { exporter.reset }

  describe '.establish_connection' do
    it 'traces' do
      User.establish_connection
      span = spans.find { |s| s.name == 'User.establish_connection' }
      _(span).wont_be_nil
    end
  end
end
