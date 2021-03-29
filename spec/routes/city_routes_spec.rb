RSpec.describe CityRoutes, type: :routes do
  describe 'GET v1' do
    context 'missing parameters' do
      it 'returns not found' do
        get '/'

        expect(last_response.status).to eq(404)
      end
    end

    context 'empty parameter' do
      it 'returns not found' do
        get '/', name: nil

        expect(last_response.status).to eq(404)
      end
    end

    context 'bad parameter' do
      it 'returns empty coordinates' do
        get '/', name: 'тест'

        expect(last_response.status).to eq(200)
        expect(response_body).to be_nil
      end
    end

    context 'valid parameters' do
      it 'returns an a coordinates' do
        get '/', name: 'City 17'

        expect(last_response.status).to eq(200)
        expect(response_body).to eq [45.05, 90.05]
      end
    end
  end
end
