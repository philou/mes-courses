# Copyright (C) 2011 by Philippe Bourgau

class Logger

  SYMBOL_2_LEVEL = {
    :debug => Logger::DEBUG,
    :info => Logger::INFO,
    :warn => Logger::WARN,
    :error => Logger::ERROR,
    :fatal => Logger::FATAL
  }

  LEVEL_2_SYMBOL = {
    Logger::DEBUG => :debug,
    Logger::INFO => :info,
    Logger::WARN => :warn,
    Logger::ERROR => :error,
    Logger::FATAL => :fatal
  }

end
