# Simple notification beetween Rails Models
module Notifications

  module InstanceMethods
    def notify(event, *args)
      if respond_to?("on_#{event}")
        send("on_#{event}", *args)
        true
      else
        false
      end
    end
  end

  module ClassMethods
    def on(event, method)
      define_method("on_#{event}"){|*args| send(method, *args)}
    end
  end

  ActiveRecord::Base.send :extend, ClassMethods
  ActiveRecord::Base.send :include, InstanceMethods
end