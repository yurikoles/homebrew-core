class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.83.tar.gz"
  sha256 "3d77e2ed54b95f9dae16bb31e7286517f25a27538a2fe568cdc40cb3695abb85"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09ca06b1f6e6e8bb8ff4582d05cb44092f10027661c6c599ae9e569b8a5732e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11dd193e6aa9e0e9d9d2d9f4424cd0b0fadb7a1f33542dd6c4e082c4e6532545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24e29def57d31f044cb73f710a601ee730d03ee2906e7506d7fec90e2756a62f"
    sha256 cellar: :any_skip_relocation, sonoma:        "111cf6bd09d13b0c6aca472ac05067ca07c596388b5d55e58dba38f454bb5513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee58ba6c0ca105868db96e91717a64ffe2630c5c781e5cbfce915dabee56028c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd58e555013817f1c9dd037aedaefd384d19eae661d1a5490a6417ce5aba0430"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
