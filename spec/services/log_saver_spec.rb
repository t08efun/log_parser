# frozen_string_literal: true

require_relative '../../app/services/log_saver.rb'
require_relative '../../app/model/log.rb'

RSpec.describe LogSaver do
  describe 'service' do
    subject { described_class.new data }

    after(:each) do
      Log.clear
    end

    context 'when data correct' do
      context 'and records have same url' do
        let(:data) do
          [
            {
              url: '/',
              ips: Set.new(['0.0.0.0'])
            },
            {
              url: '/',
              ips: Set.new(['0.0.0.1'])
            }
          ]
        end

        it 'saves data as one record' do
          expect(subject.execute).to be_truthy

          all_records = Log.all
          expect(all_records.count).to eq(1)
          expect(all_records.first.to_h).to eq(
            url: '/',
            ips: Set.new(['0.0.0.0', '0.0.0.1']),
            id: 1,
            count: 2
          )
        end
      end

      context 'and records have different url' do
        let(:data) do
          [
            {
              url: '/home',
              ips: Set.new(['0.0.0.0'])
            },
            {
              url: '/',
              ips: Set.new(['0.0.0.1'])
            }
          ]
        end

        it 'saves data as two records' do
          expect(subject.execute).to be_truthy

          all_records = Log.all
          expect(all_records.count).to eq(2)
          expect(all_records.map(&:to_h)).to match_array([{
                                                           url: '/home',
                                                           ips: Set.new(['0.0.0.0']),
                                                           id: 1,
                                                           count: 1
                                                         },
                                                          {
                                                            url: '/',
                                                            ips: Set.new(['0.0.0.1']),
                                                            id: 2,
                                                            count: 1
                                                          }])
        end
      end
    end

    context 'with invalid data' do
      let(:data) do
        [
          {
            url: 'not url',
            ips: Set.new(['0.0.0.0'])
          },
          {
            url: '/',
            ips: Set.new(['0.0.0.1'])
          }
        ]
      end

      it 'returns falsey result' do
        expect(subject.execute).to be_falsey
      end

      it 'saves valid records' do
        subject.execute

        all_records = Log.all
        expect(all_records.count).to eq(1)

        expect(all_records.first.to_h).to eq(
          url: '/',
          ips: Set.new(['0.0.0.1']),
          id: 1,
          count: 1
        )
      end

      it 'returns errors' do
        subject.execute

        expect(subject.errors.join(', ')).to eq '1: url invalid!'
      end
    end
  end
end
