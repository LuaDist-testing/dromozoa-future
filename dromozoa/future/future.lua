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

local class = {}

function class.new(state)
  return {
    state = state;
  }
end

function class:valid()
  return self.state ~= nil
end

function class:is_ready()
  return self.state:is_ready()
end

function class:wait()
  return self.state:wait()
end

function class:wait_until(timeout)
  return self.state:wait_until(timeout)
end

function class:wait_for(timeout)
  return self.state:wait_for(timeout)
end

function class:get()
  return self.state:get()
end

function class:then_(thread)
  return self.state:then_(thread)
end

class.metatable = {
  __index = class;
}

return setmetatable(class, {
  __call = function (_, state)
    return setmetatable(class.new(state), class.metatable)
  end;
})
