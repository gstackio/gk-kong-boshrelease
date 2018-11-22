-- LuaRocks configuration

-- NOTE: at compile time, we reverse the order of rock trees below, because we
-- are building as root, and Luarocks installs package in the first tree where
-- it can write, starting from the last one.
--
-- See: https://github.com/luarocks/luarocks/wiki/Config-file-format#locations
--
-- As we want the installation of Kong packages to go in the "kong" tree, and
-- we'll be able to write anywhere, we put that tree as last.

rocks_trees = {
   { name = "system", root = "/var/vcap/packages/luarocks" };
   { name = "kong", root = "/var/vcap/packages/kong" };
}
lua_interpreter = "luajit";
variables = {
   LUA_DIR = "/var/vcap/packages/openresty/luajit";
   LUA_INCDIR = "/var/vcap/packages/openresty/luajit/include/luajit-2.1";
   LUA_BINDIR = "/var/vcap/packages/openresty/luajit/bin";
}
