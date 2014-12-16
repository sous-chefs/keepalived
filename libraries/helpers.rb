module KeepAlived
  module TemplateHelpers

    # realserver_checks uses @checks instance variable in templates to render keepalived 
    # check config 
    # see https://github.com/acassen/keepalived/blob/master/doc/keepalived.conf.SYNOPSIS
    # for more details on the config settings for checks
    def realserver_checks
      output = []
      @checks.each_pair do |key, value|
        output << key.upcase + " {"
          value.each_pair do |subkey,subval|
            if subval.respond_to? :each_pair
              output << '  '+subkey.to_s + " {"
              subval.each_pair do |k, v|
                output << "#{ '  ' * 2 }#{ k.to_s } #{ v.to_s }"
              end
              output << ' }'
            else
              output << '  ' + subkey.to_s + '  ' + subval.to_s
            end
          end
        output << "}"
      end
      output.join("\n")
    end

  end
end
