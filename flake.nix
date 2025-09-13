{
  description = "Lua web development with Lapis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            luajit
            luarocks
            openresty
            sqlite
            openssl
            pkg-config
            unzip
          ];
          shellHook = ''
            export LUA=${pkgs.luajit}/bin/luajit
            export PATH=$LUA:$PATH
            export PATH=$HOME/.luarocks/bin:$PATH

            luarocks config variables.LUA $LUA
            luarocks config variables.LUA_DIR ${pkgs.luajit}
            luarocks config variables.LUA_INCDIR ${pkgs.luajit}/include/luajit-2.1
            luarocks config variables.LUA_LIBDIR ${pkgs.luajit}/lib
            luarocks config lua_version 5.1

            export SQLITE_DIR=${pkgs.sqlite}
            luarocks config variables.SQLITE_DIR ${pkgs.sqlite}
            luarocks config variables.SQLITE_INCDIR ${pkgs.sqlite.dev}/include
            luarocks config variables.SQLITE_LIBDIR ${pkgs.sqlite.out}/lib

            export CRYPTO_DIR=${pkgs.openssl}
            export CRYPTO_INCDIR=${pkgs.openssl.dev}/include
            export CRYPTO_LIBDIR=${pkgs.openssl.out}/lib
            export OPENSSL_DIR=${pkgs.openssl}
            export OPENSSL_INCDIR=${pkgs.openssl.dev}/include
            export OPENSSL_LIBDIR=${pkgs.openssl.out}/lib
            luarocks config variables.CRYPTO_DIR ${pkgs.openssl}
            luarocks config variables.CRYPTO_INCDIR ${pkgs.openssl.dev}/include
            luarocks config variables.CRYPTO_LIBDIR ${pkgs.openssl.out}/lib
            luarocks config variables.OPENSSL_DIR ${pkgs.openssl}
            luarocks config variables.OPENSSL_INCDIR ${pkgs.openssl.dev}/include
            luarocks config variables.OPENSSL_LIBDIR ${pkgs.openssl.out}/lib

            export LUA_PATH="./?.lua;$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;${pkgs.luajit}/share/lua/5.1/?.lua;${pkgs.openresty}/luajit/share/lua/5.1/?.lua;"
            export LUA_CPATH="./?.so;$HOME/.luarocks/lib/lua/5.1/?.so;${pkgs.luajit}/lib/lua/5.1/?.so;${pkgs.openresty}/luajit/lib/lua/5.1/?.so;"

            export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.sqlite.dev}/lib/pkgconfig:$PKG_CONFIG_PATH

            export OPENRESTY_LUA_PATH=$LUA_PATH
            export OPENRESTY_LUA_CPATH=$LUA_CPATH

            echo "Environment ready:"
            echo "LuaJIT: $(luajit -v)"
            echo "LuaRocks: $(luarocks --version)"
            echo "SQLite: $(sqlite3 --version)"
            echo "OpenSSL: $(openssl version)"
            echo "OpenResty: $(openresty -v 2>&1)"
          '';
        };
      });
}
