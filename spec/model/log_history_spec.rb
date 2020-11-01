# frozen_string_literal: true

require_relative '../../app/model/log_history'

RSpec.describe LogHistory do
  describe 'object' do
    subject { LogHistory.new url: '/', ip_set: Set.new(['0.0.0.0']), count: 0 }

    it 'has url field' do
      expect(subject.url).to eq '/'
    end

    it 'has ip set field' do
      expect(subject.ip_set).to eq Set.new(['0.0.0.0'])
    end

    it 'has count field' do
      expect(subject.count).to eq 0
    end

    context 'before save' do
      it 'has nil id' do
        expect(subject.id).to eq(nil)
      end
    end

    context 'when saving' do
      context 'with invalid url' do
        subject { LogHistory.new url: 'invalid url', ip_set: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ url: ['invalid url!'] })
        end
      end

      context 'with invalid ip' do
        subject { LogHistory.new url: '/', ip_set: Set.new(['1']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ ip_set: ['invalid ip_set!'] })
        end
      end

      context 'with nil url' do
        subject { LogHistory.new url: nil, ip_set: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ url: ['must be a string'] })
        end
      end

      context 'with nil ip_set' do
        subject { LogHistory.new url: '/', ip_set: nil }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ ip_set: ['must be Set'] })
        end
      end

      context 'with wrong url type' do
        subject { LogHistory.new url: 1, ip_set: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ url: ['must be a string'] })
        end
      end

      context 'with wrong ip_set type' do
        subject { LogHistory.new url: '/', ip_set: '0.0.0.0' }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ ip_set: ['must be Set'] })
        end
      end

      context 'with wrong count type' do
        subject { LogHistory.new url: '/', ip_set: Set.new(['0.0.0.0']), count: [1] }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq({ count: ['must be an integer'] })
        end
      end
    end

    context 'after save' do
      let(:logs_history) do
        [
          LogHistory.new(url: '/', ip_set: Set.new(['0.0.0.0']), count: 1),
          LogHistory.new(url: '/home', ip_set: Set.new(['0.0.0.0']), count: 1)
        ]
      end

      before(:each) do
        logs_history.each(&:save)
      end

      after(:each) do
        LogHistory.clear
      end

      it 'has id field' do
        logs_history.each.with_index do |log, i|
          expect(log.id).to eq(i)
        end
      end

      context 'has all data' do
        it 'with `find_by`' do
          obj = LogHistory.find_by(url: '/')
          expect(obj.id).to eq(0)
          expect(obj.url).to eq('/')
          expect(obj.ip_set).to eq Set.new(['0.0.0.0'])
          expect(obj.count).to eq(1)
        end

        it 'with `each`' do
          count = 0
          LogHistory.each do |log|
            expect(log.id).to eq(logs_history[count].id)
            expect(log.url).to eq(logs_history[count].url)
            expect(log.ip_set).to eq(logs_history[count].ip_set)
            expect(log.count).to eq(logs_history[count].count)
            count += 1
          end
        end
      end
    end
  end
end
