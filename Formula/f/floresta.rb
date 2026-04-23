class Floresta < Formula
  desc "Lightweight and embeddable Bitcoin client, built for sovereignty"
  homepage "https://getfloresta.org"
  url "https://github.com/getfloresta/Floresta/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1a484842451ea3b35c5f9686cc8955cad23923eddf166f373dd3e994e64a7ee7"
  license any_of: [
    "MIT",
    "Apache-2.0",
  ]
  head "https://github.com/getfloresta/Floresta.git", branch: "master"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "bin/florestad")
    system "cargo", "install", *std_cargo_args(path: "bin/floresta-cli")
  end

  service do
    run opt_bin/"florestad"
  end

  test do
    pid = spawn bin/"florestad", "--network", "regtest", "--data-dir", testpath.to_s
    sleep 2
    sleep 4 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/floresta-cli --network regtest getblockchaininfo")
    genesis_regtest = "0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206"

    assert_match genesis_regtest, output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
