module Suppressible
  def self.registry
    ActiveSupport::IsolatedExecutionState[:suppressible_registry] ||= {}
  end

  def suppress
    previous_state = Suppressible.registry[name]
    Suppressible.registry[name] = true
    yield
  ensure
    Suppressible.registry[name] = previous_state
  end

  def suppressed?
    !!Suppressible.registry[name]
  end
end
