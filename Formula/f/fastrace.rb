class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://github.com/davidesantangelo/fastrace"
  url "https://github.com/davidesantangelo/fastrace/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2306b081389a98486167707733ace0e5811bd154eaf0beffd9f144e081c94ad9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a97b1408cadabb470e8dc580cdb4931893e02e99b36371db266348f09bae5001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7392a3299518963fc2b3323ed9a2f34ecb6138122f18f1c63339c860b576a6ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f66389ff516c53b74ba54c98675ba4aff1459021e534142a6e348039ee03a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a3a88386c97fa994dc44067a53eb704a35236926eaaf1a628cfbfd9f7339146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b269df6a58e29d48dbc4ec5ea8319de35dfa2c5b8c4031fca03d6b3f310d717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b209dd0f523fa3b01700106b4128dd48d5b4567cee3c01b3b2f2cb330a7901"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP receive socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end
