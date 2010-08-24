require 'active_support'

# Helper functions to convert to and from severity codes
module ActiveSupport::BufferedLogger::Severity

  # Severity code from interned string
  def self.from_token(level)
    case level
      when :debug
      DEBUG
      when :info
      INFO
      when :warn
      WARN
      when :error
      ERROR
      when :fatal
      FATAL
      else
      UNKNOWN
    end
  end

  # Severity code to a printable 5 characters string
  def self.to_string(level)
    case level
      when DEBUG
      "DEBUG"
      when INFO
      "INFO "
      when WARN
      "WARN "
      when ERROR
      "ERROR"
      when FATAL
      "FATAL"
      else
      "UNKNO"
    end
  end

end

# Custom logging with timestamp and severity
class DetailedLogger < ActiveSupport::BufferedLogger

  def add(severity, message = nil, progname = nil, &block)
    return if severity < @level

    message = (message || (block && block.call) || progname)
    header = "[%s] %s %s" % [Time.now.strftime("%Y-%m-%d %H:%M:%S"),
                            Severity.to_string(severity), tabs]
    buffer << message.gsub(/^/,header)
    buffer << "\n"
    flush
    message
  end

  # increments tab's depth around passed block
  def with_tabs
    old_depth = depth
    self.depth= depth+1
    begin
      yield
    rescue
      self.depth= old_depth
      raise
    end
    self.depth= old_depth
  end

  private

  def tabs
    ' '*depth
  end

  # tabs depth
  def depth
    @depth ||= 0
  end
  def depth=(value)
    @depth = value
  end

end
