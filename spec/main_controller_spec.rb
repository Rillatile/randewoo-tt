describe MainController, type: :controller do
  describe 'GET index' do
    it 'returns a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
    # Для этого теста нужно отключить Redis
    it '@error is not blank and returns a 500 when redis is not available' do
      get :index
      expect(assigns(:error)).not_to be_nil
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe 'POST index' do
    it 'returns a 200 when everything is fine' do
      post :index, params: {
        schedule: '* * * * *',
        min_time: '3',
        max_time: '5',
        quantity: '3',
        messages_receiver_url: 'http://127.0.0.1:8000'
      }
      expect(response).to have_http_status(:ok)
    end

    it '@error is not blank and returns a 400 when cron is bad' do
      post :index, params: {
        schedule: '1',
        min_time: '3',
        max_time: '5',
        quantity: '3',
        messages_receiver_url: 'http://127.0.0.1:8000'
      }
      expect(assigns(:error)).not_to be_nil
      expect(response).to have_http_status(:bad_request)
    end
    # Для этого теста нужно отключить Redis
    it '@error is not blank and returns a 500 when redis is not available' do
      post :index, params: {
        schedule: '*/5 * * * *',
        min_time: '3',
        max_time: '5',
        quantity: '3',
        messages_receiver_url: 'http://127.0.0.1:8000'
      }
      expect(assigns(:error)).not_to be_nil
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
