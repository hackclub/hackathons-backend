# https://stackoverflow.com/questions/2246141/puts-vs-logger-in-rails-rake-tasks
desc "switch logger to stdout"
task to_stdout: [:environment] do
  Rails.logger = Logger.new($stdout)
end
