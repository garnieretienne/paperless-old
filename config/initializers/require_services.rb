# Load each services non-dynamically
Dir[Rails.root.join("app", "services", "*.rb")].each{|service| require service }