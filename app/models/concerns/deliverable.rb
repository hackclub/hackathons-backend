module Deliverable
  extend ActiveSupport::Concern
  extend Suppressible

  class_methods do
    # Configurator for deliverable_options
    def delivered(timing, **options)
      timing = timing.to_sym
      raise ArgumentError, "Invalid timing: #{timing}" unless %i[now later].include?(timing)
      self.deliverable_options = {timing: timing, **options}
    end
  end

  included do
    class_attribute :deliverable_options,
      instance_accessor: false, instance_predicate: false,
      default: {
        timing: :later
      }

    after_create_commit do
      case self.class.deliverable_options[:timing]
      when :now
        delivery.deliver_now
      else
        # default to :later
        delivery.deliver_later
      end
    end
  end

  private

  def deliver_after_creation?
    !Deliverable.suppressed?
  end

  def delivery
    raise NotImplementedError
  end
end
