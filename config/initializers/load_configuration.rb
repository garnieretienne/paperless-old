# Load Paperless configuration into memory
PaperlessConfig = HashWithIndifferentAccess.new(YAML.load(ERB.new(IO.read(Rails.root.join("config", "paperless.yml"))).result))[Rails.env]