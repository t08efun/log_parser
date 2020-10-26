# frozen_string_literal: true

require_relative '../../app/services/log_view.rb'
require_relative '../../app/model/log.rb'

RSpec.describe LogView do
  describe 'service' do
    context 'with records' do
      before(:all) do
        Log.new(url: '/', ips: Set.new(['0.0.0.0'])).save
        Log.new(url: '/home', ips: Set.new(['0.0.0.0'])).save
      end

      after(:all) { Log.clear }

      it 'returns humanize info' do
        expect(described_class.index(colorized: false))
        .to eq "/ was visited 1 times and there were 1 unique IPs\n" \
             '/home was visited 1 times and there were 1 unique IPs'
      end
    end
  end
end
