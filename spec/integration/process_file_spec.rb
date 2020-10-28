# frozen_string_literal: true

require_relative '../../app/log_file'
require_relative '../../app/model/log'
require_relative '../../app/services/log_view'

RSpec.describe 'Full file process' do
  let(:file_path) { "#{__dir__}/../fixtures/files/webserver.log" }
  let(:log_file) { LogFile.new file_path }

  it 'results correctly' do
    log_file.each do |url, ip|
      LogHistory.add Log.new(url: url, ip: ip)
    end

    expect(LogView.index(colorized: false))
      .to eq "/help_page/1 was visited 2 times and there were 2 unique IPs\n" \
             '/home was visited 2 times and there were 1 unique IPs'

    LogHistory.clear
  end
end
