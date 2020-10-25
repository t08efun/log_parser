# frozen_string_literal: true

RSpec.describe Log do
  describe 'object' do
    after(:all) do
      Log.clear
    end

    subject { Log.new url: '/', ips: Set.new(['0.0.0.0']), count: 1 }

    context 'before save' do

      subject { Log.new url: '/', ips: Set.new(['0.0.0.0']) }

      it 'has defaults' do
        expect(subject.count).to eq(1)
        expect(subject.id).to eq(nil)
      end
    end

    context 'when saving' do
      context 'with invalid url' do

        subject { Log.new url: 'invalid url', ips: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['url invalid!'])
        end
      end

      context 'with invalid ip' do

        subject { Log.new url: '/', ips: Set.new(['1']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['ips invalid!'])
        end
      end

      context 'with nil url' do

        subject { Log.new url: nil, ips: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['url is nil!'])
        end
      end

      context 'with nil ips' do

        subject { Log.new url: '/', ips: nil }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['ips is nil!'])
        end
      end

      context 'with wrong url type' do

        subject { Log.new url: 1, ips: Set.new(['0.0.0.0']) }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['url has wrong type!'])
        end
      end

      context 'with wrong ips type' do

        subject { Log.new url: '/', ips: '0.0.0.0' }

        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['ips has wrong type!'])
        end
      end

      context 'with wrong count type' do

        subject { Log.new url: '/', ips: Set.new(['0.0.0.0']), count: '1' }
        
        it 'has errors' do
          expect(subject.save).to be_falsy
          expect(subject.valid?).to be_falsy
          expect(subject.errors).to eq(['count has wrong type!'])
        end
      end
    end

    it 'has ip set field' do
      expect(subject.ips).to eq Set.new(['0.0.0.0'])
    end

    it 'has url field' do
      expect(subject.url).to eq '/'
    end

    it 'has count field' do
      expect(subject.count).to eq 1
    end

    context 'after save' do
      let(:logs) do
        [
          Log.new(url: '/', ips: Set.new(['0.0.0.0']), count: 1),
          Log.new(url: '/home', ips: Set.new(['0.0.0.0']), count: 1)
        ]
      end

      before(:each) do
        logs.each(&:save)
      end

      after(:each) do
        Log.clear
      end

      it 'has id field' do
        logs.each.with_index do |log, i|
          expect(log.id).to eq(i + 1)
        end
      end

      context 'has all data' do
        it 'with `find_by`' do
          obj = Log.find_by(url: '/')
          expect(obj.id).to eq(1)
          expect(obj.url).to eq('/')
          expect(obj.ips).to eq Set.new(['0.0.0.0'])
          expect(obj.count).to eq(1)
        end

        it 'with `each`' do
          count = 0
          Log.each do |log|
            expect(log.id).to eq(logs[count].id)
            expect(log.url).to eq(logs[count].url)
            expect(log.ips).to eq(logs[count].ips)
            expect(log.count).to eq(logs[count].count)
            count += 1
          end
        end
      end
    end
  end
end
