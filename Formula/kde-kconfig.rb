class KdeKconfig < Formula
  desc "Persistent platform-independent application settings"
  homepage "https://api.kde.org/frameworks/kconfig/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/kconfig-5.79.0.tar.xz"
  sha256 "f948718ac87f573b14bbf73e4af02d488f023cfcf011425af7cdbc0cefca510a"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    "MIT",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/kconfig.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]

  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-D BUILD_QCH=ON"
    args << "-D BUILD_TESTING=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end

    pkgshare.install "autotests"

    (pkgshare/"src/kconf_update").mkpath
    (pkgshare/"src/core").mkpath

    (pkgshare/"src/kconf_update").install "src/kconf_update/kconfigutils.h"
    (pkgshare/"src/kconf_update").install "src/kconf_update/kconfigutils.cpp"

    (pkgshare/"src/core").install "src/core/kconfigdata.h"
    (pkgshare/"src/core").install "src/core/kconfigdata.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      include(FeatureSummary)
      find_package(ECM NO_MODULE)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")

      add_subdirectory(autotests)
    EOS

    cp_r (pkgshare/"autotests"), testpath
    cp_r (pkgshare/"src"), testpath

    args = std_cmake_args
    args << "-DQt5Test_DIR=#{Formula["qt@5"].opt_lib/"cmake/Qt5Test"}"
    args << "-DQt5Concurrent_DIR=#{Formula["qt@5"].opt_lib/"cmake/Qt5Concurrent"}"

    system "cmake", testpath.to_s, *args
    system "make", "buildtests"
  end
end
