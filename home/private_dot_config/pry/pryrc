Pry.config.disable_auto_reload = true
Pry.config.should_load_plugins = false

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

begin
  require 'pry-doc'
rescue LoadError => err
  warn "Couldn't load pry-doc: #{err}"
  warn "you may want to run `gem install pry-doc'"
end

main_prompt = proc { |target_self, nest_level, pry|
  env = case ENV['RAILS_ENV']
    when 'production'
      '[prod] '
    when 'qa'
      '[qa] '
    end
  "#{env}#{pry.input_array.size}:(#{Pry.view_clip(target_self)})> "
}

secondary_prompt = proc { |target_self, nest_level, pry|
  whitespace_length = main_prompt[target_self, nest_level, pry].length - 3
  "#{' ' * whitespace_length}>> "
}

Pry.prompt = [main_prompt, secondary_prompt]
