# frozen_string_literal: true

RSpec.describe FileAdapter::Log do
  let(:file_path) { "#{__dir__}/../fixtures/files/webserver.log" }
  let(:missing_path) { 'missing_path/webserver.log' }
  let(:bad_file_extension_path) { "#{__dir__}/../fixtures/files/webserver.logs" }
  let(:empty_file_path) { "#{__dir__}/../fixtures/files/empty.log" }
  let(:good_file_path) { "#{__dir__}/../fixtures/files/webserver.log" }

  let :logs do
    [
      { url: '/help_page/1', ips: Set.new(['126.318.035.038']) },
      { url: '/home', ips: Set.new(['184.123.665.067']) },
      { url: '/home', ips: Set.new(['184.123.665.067']) },
      { url: '/help_page/1', ips: Set.new(['929.398.951.889']) }
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
          .to raise_error 'Invalid file extension! Available extension: *.log'
      end
    end

    context 'when empty' do
      it 'raises error' do
        expect { described_class.new empty_file_path }.to raise_error 'Error! File is empty!'
      end
    end

    context 'when correct' do
      it 'parsing successfuly' do
        expect(described_class.new(good_file_path)).to match_array(logs)
      end
    end
  end
end
