Rails.application.config.after_initialize do
  RubyVM::YJIT.enable
end
