RSpec.describe Post::UpdateContract, type: :unit do
  subject(:contract) { described_class.new }

  describe '#call' do
    context "when title is lower than minimum size" do
      let(:params) do
        {
            title: 'a',
            body: 'a'
        }
      end

      it 'should raise error' do
        expect(contract.call(params).success?).to be_falsey
      end
    end

    context "when title is bigger than maximum size" do
      let(:params) do
        {
            title: 'a' * 16,
            body: 'a'
        }
      end

      it 'should raise error' do
        expect(contract.call(params).success?).to be_falsey
      end
    end
  end

  context "when parameters are correct" do
    let(:params) do
      {
          title: 'a' * 6,
          body: 'a'
      }
    end

    it 'should not raise error' do
      expect(contract.call(params).success?).to be_truthy
    end
  end
end