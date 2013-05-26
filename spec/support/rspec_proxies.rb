# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class Object

  def on_result_from(method_name)
    original_method = self.method(method_name)

    self.stub(method_name) do |*args, &block|
      result = original_method.call(*args, &block)
      yield result
      result
    end
  end

  def on_call_to(method_name)
    original_method = self.method(method_name)

    self.stub(method_name) do |*args, &block|
      yield *args
      original_method.call(*args, &block)
    end

  end

end
