require "test_helper"

class HealthCheckEventFilteringTest < ActionDispatch::IntegrationTest
  test "filters out health check request events" do
    with_filtered_event_reporter do
      assert_no_event_reported("action_controller.request_started") do
        get health_check_path
        assert_response :ok
      end
    end
  end

  test "passes through non-health check request events" do
    assert_event_reported("action_controller.request_completed") do
      get root_path
    end
  end

  private

  def with_filtered_event_reporter
    original = ActiveSupport.event_reporter
    ActiveSupport.event_reporter = FilteredEventReporter.new(original)
    yield
  ensure
    ActiveSupport.event_reporter = original
  end

  class FilteredEventReporter < SimpleDelegator
    def subscribe(subscriber, &filter)
      super(HealthCheckFilteredEventSubscriber.new(subscriber), &filter)
    end
  end
end
