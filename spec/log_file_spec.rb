# frozen_string_literal: true

require_relative '../app/log_file'
require_relative '../app/model/log'

RSpec.describe LogFile do
  let(:file_path) { "#{__dir__}/fixtures/files/webserver.log" }
  let(:missing_path) { 'missing_path/webserver.log' }
  let(:bad_file_extension_path) { "#{__dir__}/fixtures/files/webserver.logs" }
  let(:empty_file_path) { "#{__dir__}/fixtures/files/empty.log" }
  let(:good_file_path) { "#{__dir__}/fixtures/files/webserver.log" }

  let :logs do
    [
      ['/help_page/1', '126.318.035.038'],
      ['/home', '184.123.665.067'],
      ['/home', '184.123.665.067'],
      ['/help_page/1', '929.398.951.889']
    ]
  end

  describe 'file' do
    context 'when absent' do
      it 'raises error' do
        expect { described_class.new missing_path }.to raise_error Errno::ENOENT
      end
    end

    context 'with invalid extension' do
      it 'raises error' do
        expect { described_class.new bad_file_extension_path }
          .to raise_error InvalidExtension
      end
    end

    context 'when empty' do
      it 'raises error' do
        expect { described_class.new empty_file_path }.to raise_error EmptyFile
      end
    end

    context 'when correct' do
      it 'parsing successfuly' do
        expect(described_class.new(good_file_path)).to match_array(logs)
      end
    end
  end
end
