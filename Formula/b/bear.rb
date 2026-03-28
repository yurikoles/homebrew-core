class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.0.tar.gz"
  sha256 "c5f90fdcf7e0003a345993f3b69981db20715050a43ff984aad1b1bd5a1b02ea"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff39fe2a75cdaa8f208bcb88add9374cfeb94099f9b1e4a9277c8aa462a9e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831aba7478d6c4d08a82f624e6fb03d564282223fd9703ca0e9248931781d836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953e42741dc3bdeea94afae5469993a9f9d817284a986da7b41187e3f81effdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "424136238384167d6140333113688d865f4f1d1d0a7c475c2602cef2b333b57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2acf72c5b7ecfbacf3173f7ccc7d54da6f3c36761ece9dc611aa2ccd419bad54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7694330edf9b1182a4111328927632191bf892f537d23a9d053819c991a4093d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"
      (libexec/"lib").install "target/release/libexec.so"
    end

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
