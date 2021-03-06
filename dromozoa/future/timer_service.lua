-- Copyright (C) 2017 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-future.
--
-- dromozoa-future is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-future is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-future.  If not, see <http://www.gnu.org/licenses/>.

local multimap = require "dromozoa.commons.multimap"
local unix = require "dromozoa.unix"
local create_thread = require "dromozoa.future.create_thread"
local resume_thread = require "dromozoa.future.resume_thread"

local class = {}

function class.new()
  return class.update_current_time({
    threads = multimap();
  })
end

function class:update_current_time()
  self.current_time = unix.clock_gettime(unix.CLOCK_MONOTONIC_RAW)
  return self
end

function class:get_current_time()
  return self.current_time
end

function class:add_timer(timeout, thread)
  return self.threads:insert(timeout, create_thread(thread))
end

function class:remove_timer(handle)
  handle:set(nil)
  return self
end

function class:dispatch()
  self:update_current_time()
  local range = self.threads:upper_bound(self:get_current_time())
  for _, thread, handle in range:each() do
    if thread then
      resume_thread(thread, handle)
    end
  end
  for _, thread, handle in range:each() do
    if thread == nil then
      handle:remove()
    end
  end
  return self
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function ()
    return setmetatable(class.new(), class.metatable)
  end;
})
