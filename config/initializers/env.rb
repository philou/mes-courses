# Loads local env at application startup

env_file = File.join(Rails.root, 'config', 'local_env.yml')
YAML.load(File.open(env_file))['everywhere'].each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(env_file)

raise SecurityError.new("The ENCRYPTION_KEY envrionment variable should be specified") if ENV["ENCRYPTION_KEY"].nil?
