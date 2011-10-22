# Copyright (C) 2011 by Philippe Bourgau

class Retrier

  def initialize(wrapped, options = {} )
    @wrapped = wrapped
    @options = { :max_retries => 1, :ignored_exceptions => [], :sleep_delay => 0}.merge(options)
  end

  def method_missing(method_sym, *args)
    wrap_result(send_to_wrapped(method_sym, args))
  end

  private

  def wrap_result(result)
    if result.nil? || result.instance_of?(Hash)
      return result

    elsif result.instance_of?(Array)
      return result.map { |item| wrap(item) }

    else
      wrap(result)

    end
  end

  def wrap(object)
    Retrier.new(object, @options)
  end

  def send_to_wrapped(method_sym, args)
    retries = @options[:max_retries] - 1
    begin
      @wrapped.send(method_sym, *args)
    rescue Exception => exception
      if retries <= 0 || ignored?(exception)
        raise
      else
        Rails.logger.warn("Retrying on exception #{exception}, #{retries} attempts left.\n#{exception.backtrace.join("\n")}")
        sleep(@options[:sleep_delay])
        retries = retries - 1
        retry
      end
    end
  end

  def ignored?(exception)
    @options[:ignored_exceptions].any? {|exception_class| exception.instance_of?(exception_class) }
  end

end
