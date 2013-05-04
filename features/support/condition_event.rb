# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class ConditionEvent
  def initialize
    @value = false
    @value.extend(MonitorMixin)
    @value_set = @value.new_cond
  end

  def wait
    @value.synchronize do
      @value_set.wait_while { !@value }
    end
  end

  def set
    @value.synchronize do
      @value = true
      @value_set.signal
    end
  end
end
