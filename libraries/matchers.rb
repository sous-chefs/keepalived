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

if defined?(ChefSpec)
  require_relative 'keepalived'

  Keepalived::RESOURCES.each do |r|
    ChefSpec.define_matcher(r)

    %w( create delete ).each do |a|
      combo = "#{a}_#{r}".to_sym

      define_method(combo) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(r, a.to_sym, resource_name)
      end
    end
  end
end
