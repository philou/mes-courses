# Copyright (C) 2014 by Philippe Bourgau




module NamespaceA
  class AClass
  end
  module NamespaceB
    class ABClass
    end
  end
end

module NamespaceC

  class CClass
    include NamespaceA::NamespaceB

    def self.write_something_intelligent
      puts ABClass.to_s
    end

    def write_something_else
      puts ABClass.to_s
    end
  end

end

NamespaceC::CClass.write_something_intelligent

NamespaceC::CClass.new.write_something_else

