class FilteredEventSubscriber
  def initialize(subscriber, filter:)
    @subscriber = subscriber
    @filter = filter
  end

  def emit(event)
    @subscriber.emit(event) if @filter.call(event)
  end
end

class HealthCheckFilteredEventSubscriber < FilteredEventSubscriber
  def initialize(subscriber)
    filter = ->(event) { event.dig(:payload, :controller) != "Rails::HealthController" }

    super(subscriber, filter:)
  end
end

Rails.application.config.to_prepare do
  next unless defined?(Appsignal::Integrations::ActiveSupportEventReporter::Subscriber)

  subscribers = Rails.event.instance_variable_get(:@subscribers)
  original = subscribers.find { it[:subscriber].is_a? Appsignal::Integrations::ActiveSupportEventReporter::Subscriber }

  next unless original

  subscribers.delete original

  filtered = HealthCheckFilteredEventSubscriber.new(original[:subscriber])
  Rails.event.subscribe(filtered, &original[:filter])
end
