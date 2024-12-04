require "puma/plugin"
require "dartsass/runner"
require "active_support/all"

Puma::Plugin.create do
  def start(launcher)
    @log_writer = launcher.log_writer
    @puma_pid = Process.pid
    @dartsass_pid = fork do
      Thread.new { monitor_puma }

      # If we use system(*command), IRB and Debug can't read from $stdin
      # correctly because some keystrokes will be sent to dartsass.
      IO.popen(Dartsass::Runner.dartsass_compile_command << "--watch", "r+") do |io|
        IO.copy_stream io, $stdout
      end
    end

    launcher.events.on_stopped { stop_dartsass }
  end

  private

  attr_reader :puma_pid, :dartsass_pid

  def monitor_puma
    stop_when :puma_dead?, "Puma is gone, stopping dartsass..."
  end

  def stop_when(condition_met, message)
    loop do
      if send(condition_met)
        log message
        Process.kill(:INT, Process.pid)
        break
      else
        sleep 2.seconds
      end
    end
  end

  def puma_dead?
    Process.ppid != puma_pid
  end

  def stop_dartsass
    suppress Errno::ECHILD, Errno::ESRCH do
      Process.wait(dartsass_pid, Process::WNOHANG)
      log "Stopping dartsass..."
      Process.kill(:INT, dartsass_pid)
      Process.wait(dartsass_pid)
    end
  end

  def log(...)
    @log_writer.log(...)
  end
end
