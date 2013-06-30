# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class Object

  def on_result_from(method_name)
    stock_response = self.original_response(method_name)

    self.stub(method_name) do |*args, &block|
      result = stock_response.call(*args, &block)
      yield result
      result
    end
  end

  def capture_results_from(method_name)
    all_results = []
    on_result_from(method_name) {|result| all_results << result }
    all_results
  end

  def capture_result_from(target, method_name, details)
    into = details[:into]
    target.on_result_from(method_name) {|result| instance_variable_set("@#{into}", result)}
  end

  def on_call_to(method_name)
    stock_response = self.original_response(method_name)

    self.stub(method_name) do |*args, &block|
      yield *args
      stock_response.call(*args, &block)
    end

  end

  def proxy_chain(*selectors, &block)
    if selectors.count == 1
      final_stub = self.stub(selectors.first)
      block.call(final_stub) unless block.nil?
    else
      self.on_result_from(selectors.first) do |result|
        result.proxy_chain(*selectors[1..-1], &block)
      end
    end
  end

  protected

  def original_response(method_name)
    if self.methods.include?(method_name)
      self.method(method_name)
    else
      lambda do |*args, &block|
        self.send(:method_missing, method_name, *args, &block)
      end
    end
  end

end
