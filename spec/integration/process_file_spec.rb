# frozen_string_literal: true

require_relative '../../app/file_adapter/log.rb'
require_relative '../../app/model/log.rb'
require_relative '../../app/services/log_view.rb'
require_relative '../../app/services/log_saver.rb'

RSpec.describe 'Full file process' do
  let(:file_path) { "#{__dir__}/../fixtures/files/webserver.log" }
  let(:file_adapter) { FileAdapter::Log.new file_path }
  let(:saver) { LogSaver.new(file_adapter) }

  it 'results correctly' do
    saver.execute
    expect(LogView.index(colorized: false))
      .to eq "/help_page/1 was visited 2 times and there were 2 unique IPs\n" \
             '/home was visited 2 times and there were 1 unique IPs'
    Log.clear
  end
end
