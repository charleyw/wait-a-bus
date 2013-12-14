require_relative '../model/model'
desc 'load data'
task :seed  do
  require_relative '../db/seeds'
end