# frozen_string_literal: true

require_relative '../../app/model/log'

RSpec.describe Log do
  describe '#new' do
    subject { Log.new url: '/', ip: '0.0.0.0' }

    it 'has ip field' do
      expect(subject.ip).to eq '0.0.0.0'
    end

    it 'has url field' do
      expect(subject.url).to eq '/'
    end

    context 'with invalid url' do
      subject { Log.new url: 'invalid url', ip: '0.0.0.0' }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ url: ['invalid url!'] })
      end
    end

    context 'with invalid ip' do
      subject { Log.new url: '/', ip: '1' }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ ip: ['invalid ip!'] })
      end
    end

    context 'with nil url' do
      subject { Log.new url: nil, ip: '0.0.0.0' }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ url: ['must be a string'] })
      end
    end

    context 'with nil ips' do
      subject { Log.new url: '/', ips: nil }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ ip: ['is missing'] })
      end
    end

    context 'with wrong url type' do
      subject { Log.new url: 1, ip: '0.0.0.0' }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ url: ['must be a string'] })
      end
    end

    context 'with wrong ips type' do
      subject { Log.new url: '/', ips: 1 }

      it 'has errors' do
        expect(subject.valid?).to be_falsy
        expect(subject.errors).to eq({ ip: ['is missing'] })
      end
    end
  end
end
