module ReadOnly
  def readonly?(mode: true)
    if mode
      super() || ENV["READ_ONLY_MODE"].present?
    else
      super()
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
