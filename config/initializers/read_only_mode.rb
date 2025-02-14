module ReadOnly
  def readonly?
    if ENV["READ_ONLY_MODE"]
      true
    else
      super
    end
  end

  def _raise_readonly_record_error
    if ENV["READ_ONLY_MODE"]
      raise ReadOnlyModeError
    else
      super
    end
  end
end

ActiveRecord::Base.prepend ReadOnly
