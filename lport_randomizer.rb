#
# Plugin::UseRandomizer
#
# Randomizes LPORT immediately after you `use` any module that has an LPORT option.
#

require 'msf/core'

module Msf
class Plugin::UseRandomizer < Msf::Plugin
  def initialize(framework, opts)
    super

    # Monkey-patch the Modules dispatcher where 'use' is defined:
    Msf::Ui::Console::CommandDispatcher::Modules.module_eval do
      # Don't re-alias on multiple loads
      unless method_defined?(:use_randomizer_original_cmd_use)
        alias_method :use_randomizer_original_cmd_use, :cmd_use
      end

      define_method(:cmd_use) do |*args|
        # First, call the real 'use' and let it load the module + payload
        ret = use_randomizer_original_cmd_use(*args)

        # Grab the module that was just activated
        mod = driver.active_module

        # If it has an LPORT option, randomize it
        if mod && mod.datastore.key?('LPORT')
          new_port = rand(1025..65_000)
          mod.datastore['LPORT']   = new_port
          framework.datastore['LPORT'] = new_port
          print_status("UseRandomizer: randomized LPORT → #{new_port}")
        end

        ret
      end
    end

    print_status("UseRandomizer plugin loaded; LPORT will be randomized on each `use`.") 
  end

  def cleanup
    # nothing to undo
  end

  def name
    "use_randomizer"
  end

  def desc
    "Randomizes LPORT immediately after module selection (`use`)."
  end
end
end
