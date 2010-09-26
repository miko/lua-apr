--[[

 This is the LuaRocks `rockspec' for the Lua/APR binding.

 Author: Peter Odding <peter@peterodding.com>
 Last Change: September 26, 2010
 Homepage: http://peterodding.com/code/lua/apr/
 License: MIT

--]]

package = 'Lua-APR'
version = 'scm-1'
source = { url = 'git://github.com/xolox/lua-apr.git', branch = 'master' }
description = {
  summary = 'Apache Portable Runtime binding for Lua',
  detailed = [[
    Lua/APR is a binding to the Apache Portable Runtime (APR) library. APR
    powers software such as the Apache webserver and Subversion and Lua/APR
    makes the APR operating system interfaces available to Lua.
  ]],
  homepage = 'http://peterodding.com/code/lua/apr/',
  license = 'MIT',
}
dependencies = { 'lua >= 5.1' }
external_dependencies = {
  APR = { header = 'apr-1.0/apr.h', library = 'apr-1' },
  APU = { header = 'apr-1.0/apu.h', library = 'aprutil-1' },
}
local CFLAGS = '$(CFLAGS) -I$(LUA_INCDIR) -I$(APR_INCDIR)/apr-1.0 -I$(APU_INCDIR)/apr-1.0'
build = {
  type = 'make',
  variables = {
    LUA_DIR = '$(PREFIX)',
    LUA_LIBDIR = '$(LIBDIR)',
    LUA_SHAREDIR = '$(LUADIR)',
    CFLAGS = CFLAGS,
    LFLAGS = '$(LFLAGS) -L$(APR_LIBDIR) -L$(APU_LIBDIR) -llua5.1 -lapr-1 -laprutil-1',
  },
  platforms = {
    linux = {
      variables = {
        -- Make sure "apr_off_t" is defined correctly.
        CFLAGS = CFLAGS .. ' -D_GNU_SOURCE',
      }
    },
  }
}

-- vim: ft=lua ts=2 sw=2 et
