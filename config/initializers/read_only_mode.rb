def read_only_mode?
  ENV["MAINTENANCE"].present?
end

module ReadOnly
  def readonly?(mode: true)
    if mode
      super || read_only_mode?
    else
      super
    end
  end

  def _raise_readonly_record_error
    if readonly? mode: false
      super
    else
      raise ReadOnlyModeError
    end
  end
end

ActiveRecord::Base.prepend ReadOnly
