class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "0e3271b10d917b5b6d8c86689c04a7c7facfb4c9ed6aafebe34f72b42c01690a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f5934a6f114ac82acb63d98a76a0d5c43eb062fbc734b5cb42ce4f292393d65"
    sha256 cellar: :any, arm64_sequoia: "658a117bf703a96faea729439097d82f47f17f5e682186d663deb7c12d69cee0"
    sha256 cellar: :any, arm64_sonoma:  "592dbb698b8c70b76fffa08a2d1c068ba260cfd17542a511bb2a71ba93a8fdfd"
    sha256 cellar: :any, sonoma:        "e665f6e1cbfc9ba602965a903d0737293c3142a1b116c6de4b8db6717c4cc274"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
