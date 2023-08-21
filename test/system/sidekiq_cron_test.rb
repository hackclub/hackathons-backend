require "application_system_test_case"

class SidekiqCronTest < ApplicationSystemTestCase
  setup do
    # https://github.com/sidekiq-cron/sidekiq-cron/blob/master/lib/sidekiq/cron/schedule_loader.rb
    schedule_file = Sidekiq::Options[:cron_schedule_file] || "config/schedule.yml"
    schedule = Sidekiq::Cron::Support.load_yaml(ERB.new(IO.read(schedule_file)).result)
    if schedule.is_a?(Hash)
      Sidekiq::Cron::Job.load_from_hash! schedule
    elsif schedule.is_a?(Array)
      Sidekiq::Cron::Job.load_from_array! schedule
    else
      raise "Not supported schedule format. Confirm your #{schedule_file}"
    end
  end

  Sidekiq::Cron::Job.all.each do |job|
    test "#{job.name} job class exists" do
      # Please check the job's class name in the cron schedule if this test fails.
      assert job.klass.constantize
    end
  end
end
