describe GenerateMessageWorker do
  it 'enqueues jobs' do
    params = GenerateMessageWorker.send(:generation_parameters)

    expect { GenerateMessageWorker.start }.to change(GenerateMessageWorker.jobs, :size).by(params[:quantity])
  end
end
