module RPH
  module Navigation
    # superclass for all navigation classes
    # (put common methods in here)
    class Base
      # keep everything in the same format
      # for setting/getting hash values
      def normalize(val)
        val.to_s.underscore.sub(/_controller$/, '')
      end
    end
  end
end