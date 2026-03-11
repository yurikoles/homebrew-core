class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  license "Apache-2.0"
  revision 1
  head "https://github.com/luvit/luv.git", branch: "master"

  stable do
    url "https://github.com/luvit/luv/archive/refs/tags/1.51.0-2.tar.gz"
    sha256 "d70cf20b16ab05ceaa3bb448f3e1b3ef63a5949e34184255c52a3e92efcd39b4"

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/luvit/luv/commit/297bd3341257a534cb3f7759ba20aac8916ce93d.patch?full_index=1"
      sha256 "0be1bb91014cbc71e5822a3bb7b7c10c794282f7a88585a6adb123575f973e65"
    end
    patch do
      url "https://github.com/luvit/luv/commit/a60fcf61b29b877277dde8a58945d5667409c8bc.patch?full_index=1"
      sha256 "c6ad102f3bd2b1792ad9e3d0ea4ca2095464601ebbc692279da1ff71bb82d393"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f39bd668b051ad916ffb10aea31c37f98f79c7cdc49b04794c69f4c79ecdbbf8"
    sha256 cellar: :any,                 arm64_sequoia: "8b3742af507bafa9e602ad29c1c6a5b1b5f1d4796808ec10dd32edd1fa4ea96d"
    sha256 cellar: :any,                 arm64_sonoma:  "a305a73ebfd1d063996877eb657b86bd31be1ecc67fc769ba2585170d830b453"
    sha256 cellar: :any,                 sonoma:        "620178b0f1d05295fd0495e178ad56ae7598f874d159272f6d0d65e5678f3d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98cd8bfa1d3ce4b30f6ab88dcd3c318874fa80a5324f50f6973488449b12197f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8b734095fa3c4a6e6a27654b482aeff434f0d5aace030a08c5df23d1fb4fe1"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.14.4.tar.gz"
    sha256 "a9afa2eb812996039a05c5101067e6a31af9a75eded998937a1ce814afe1b150"
  end

  def lua
    Formula["lua"]
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" if build.stable?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    # https://github.com/luvit/luv/issues/787#issuecomment-4041758224
                    "-DMODULE_INSTALL_LIB_DIR=#{lib}/lua/#{lua.version.major_minor}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("#{lua.bin}/lua test.lua")
  end
end
