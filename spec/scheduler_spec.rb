describe Scheduler do
  describe 'correct_cron?' do
    it 'correct cron 1' do
      cron = '* * * * *'
      expect(Scheduler.correct_cron?(cron)).to eq(true)
    end

    it 'correct cron 2' do
      cron = '*/5 * * * *'
      expect(Scheduler.correct_cron?(cron)).to eq(true)
    end

    it 'correct cron 3' do
      cron = '0 0 * * *'
      expect(Scheduler.correct_cron?(cron)).to eq(true)
    end

    it 'correct cron 4' do
      cron = '@daily'
      expect(Scheduler.correct_cron?(cron)).to eq(true)
    end

    it 'incorrect cron 1' do
      cron = 'daily'
      expect(Scheduler.correct_cron?(cron)).to eq(false)
    end

    it 'incorrect cron 2' do
      cron = '1'
      expect(Scheduler.correct_cron?(cron)).to eq(false)
    end

    it 'incorrect cron 3' do
      cron = 'a 0 0 0 0'
      expect(Scheduler.correct_cron?(cron)).to eq(false)
    end

    it 'incorrect cron 4' do
      cron = '* * * *'
      expect(Scheduler.correct_cron?(cron)).to eq(false)
    end
  end
end
