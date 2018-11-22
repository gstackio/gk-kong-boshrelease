-- LuaRocks configuration

rocks_trees = {
   { name = "kong", root = "/var/vcap/packages/kong" };
   { name = "system", root = "/var/vcap/packages/luarocks" };
}
lua_interpreter = "luajit";
variables = {
   LUA_DIR = "/var/vcap/packages/openresty/luajit";
   LUA_INCDIR = "/var/vcap/packages/openresty/luajit/include/luajit-2.1";
   LUA_BINDIR = "/var/vcap/packages/openresty/luajit/bin";
}
