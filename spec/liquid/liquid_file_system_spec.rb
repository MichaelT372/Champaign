require 'rails_helper'

describe LiquidFileSystem do
  describe '.read_template_file' do
    before do
      allow(Dir).to receive(:glob){ ['./spec/fixtures/_foo.liquid'] }
    end

    context 'with database content' do
      let!(:partial) { create(:liquid_partial, title: :foo, content: :bar) }

      it 'reads content from database, when present' do
        expect(
          LiquidFileSystem.read_template_file(:foo)
        ).to eq("bar")
      end
    end

    context 'without database content' do
      it 'reads content from filesystem' do
        expect(
          LiquidFileSystem.read_template_file(:foo)
        ).to match("Hello World")
      end
    end

    context 'without partial' do
      before do
        allow(Dir).to receive(:glob){ [] }
      end

      it 'returns warning' do
        expect(LiquidFileSystem.read_template_file(:foo)).to eq('Partial foo was not found')
      end
    end

    context 'in development mode' do
      let!(:partial) { create(:liquid_partial, title: :foo, content: :bar) }

      before do
        ENV['LIQUID_TEMPLATING_SOURCE'] = 'file'
      end

      after { ENV['LIQUID_TEMPLATING_SOURCE'] = nil }


      it 'always reads from file' do
        expect(
          LiquidFileSystem.read_template_file(:foo)
        ).to match("Hello World")
      end
    end
  end
end
