# frozen_string_literal: true

require_relative '../../app/services/log_view'
require_relative '../../app/model/log_history'

RSpec.describe LogView do
  describe 'service' do
    context 'with records' do
      before(:all) do
        LogHistory.new(url: '/', ip_set: Set.new(['0.0.0.0']), count: 1).save
        LogHistory.new(url: '/home', ip_set: Set.new(['0.0.0.0']), count: 1).save
      end

      after(:all) { LogHistory.clear }

      it 'returns humanize info' do
        expect(described_class.index(colorized: false))
          .to eq "/ was visited 1 times and there were 1 unique IPs\n" \
             '/home was visited 1 times and there were 1 unique IPs'
      end
    end
  end
end
