class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.2.tar.gz"
  sha256 "1825891157144c2d61bedeeb6f4058c1ca071156a485fe07368d14aa98091011"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7206b948c99b5de7d582085a2b6b4033e66f0ce788e1a13dcaf2900415aa75a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ccc914b3a5bf43320833fcfee697a64d4f8fc211d4426c34db7bdabf34ec25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f0dac9c9b5a2bc8eababa69481bc41b2df5459595f48c7984ef37a04a3978a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e009dab6e5079c82adb0cf6c2818b7a76dec6dc23b7c6331cfb70c65d4e42ef9"
  end

  depends_on xcode: ["16.4", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"

    if OS.mac?
      toolchain_lib = Pathname(
        Utils.safe_popen_read("/usr/bin/xcode-select", "-p").strip,
      )/"Toolchains/XcodeDefault.xctoolchain/usr/lib"
      indexstore = toolchain_lib/"libIndexStore.dylib"
      odie "Missing libIndexStore in #{toolchain_lib}" unless indexstore.exist?
      lib.mkpath
      cp indexstore, lib/"libIndexStore.dylib"

      # The binary inherits an absolute Xcode toolchain rpath from the build environment.
      # Replace it with a loader-relative path so the bundled lib is used instead.
      toolchain_rpaths = []
      inside_rpath_command = false
      Utils.safe_popen_read("/usr/bin/otool", "-l", bin/"periphery").each_line do |line|
        if line.include?("cmd LC_RPATH")
          inside_rpath_command = true
          next
        end

        next unless inside_rpath_command
        next unless line.lstrip.start_with?("path ")

        path = line.split[1]
        toolchain_rpaths << path if path == toolchain_lib.to_s || path.start_with?("#{toolchain_lib}/")
        inside_rpath_command = false
      end
      system "/usr/bin/install_name_tool", "-add_rpath", "@loader_path/../lib", bin/"periphery"
      toolchain_rpaths.uniq.each do |path|
        system "/usr/bin/install_name_tool", "-delete_rpath", path, bin/"periphery"
      end
    else
      swift_libexec_lib = Formula["swift"].opt_libexec/"lib"
      indexstore = Dir[swift_libexec_lib/"libIndexStore.so*"].map { |path| Pathname(path) }
      odie "Missing libIndexStore in #{swift_libexec_lib}" if indexstore.empty?
      indexstore.each do |path|
        lib.install path
      end

      # The binary inherits an absolute Swift toolchain rpath from the build environment.
      # Replace it with a loader-relative path so the bundled lib is used instead.
      swift_cellar_libexec_lib = Formula["swift"].libexec/"lib"
      swift_toolchain_rpaths = [swift_libexec_lib, swift_cellar_libexec_lib]
      swift_toolchain_rpaths << swift_libexec_lib.realpath if swift_libexec_lib.exist?
      swift_toolchain_rpaths << swift_cellar_libexec_lib.realpath if swift_cellar_libexec_lib.exist?
      existing_rpath = Utils.safe_popen_read(
        Formula["patchelf"].opt_bin/"patchelf", "--print-rpath", bin/"periphery"
      ).strip
      rpaths = existing_rpath.split(":").reject do |path|
        path == lib.to_s || swift_toolchain_rpaths.map(&:to_s).include?(path)
      end
      rpaths.unshift("$ORIGIN/../lib")
      system Formula["patchelf"].opt_bin/"patchelf", "--set-rpath", rpaths.uniq.join(":"), bin/"periphery"
    end

    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
