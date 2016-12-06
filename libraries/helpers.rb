#
# Cookbook:: keepalived
#
# Copyright:: 2016, Nathan Williams, <nath.e.will@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Keepalived
  module Helpers
    def conf_string(resource, options)
      cfg = %w()
      options.each_pair do |attr, _|
        next if resource.send(attr).nil?
        cfg << convert(attr, resource.send(attr))
      end
      cfg.join("\n\t")
    end

    def convert(directive, value)
      case value
      when Hash
        sub_block(directive, value.map { |k, v| "#{k} #{v}" }.join("\n\t\t"))
      when Array
        sub_block(directive, value.join("\n\t\t"))
      when TrueClass, FalseClass
        directive.to_s if directive
      else
        "#{directive} #{value}"
      end
    end

    def sub_block(section, content)
      ["#{section} {", "\t#{content}", "\t}"].join("\n\t")
    end

    module_function :conf_string, :convert, :sub_block
  end
end
