class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.48.0.tar.gz"
  sha256 "7900d9ec61014c1b87c149e43aa4f3b03be4bc756cbfe9a75926d5a7ac86105e"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfff84baf49fd8b0866c4b504236a471a57ab19cd4596366b02d2ca018605d0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfff84baf49fd8b0866c4b504236a471a57ab19cd4596366b02d2ca018605d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfff84baf49fd8b0866c4b504236a471a57ab19cd4596366b02d2ca018605d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4745bed6091e7a19d43c0f653c2709abaed427d3e646369a19438e8eb11729d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30752e26302b99dc947bf56b429c611dd566e9dbbe6f46adb9cc3c3b2bbc8a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0249761ed6a36d08ccce5aa255ece4a05db993093cc0b2372599240ab934a12b"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202604050243/geoip.dat"
    sha256 "16dbd19ff8dddb69960f313a3b0c0623cae82dc9725687110c28740226d3b285"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202604050243/geoip-only-cn-private.dat"
    sha256 "be508bdc4b760a3b3a1ea3683f7746691adf13757b77548f1fbe9dc6c26b2220"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260412150845/dlc.dat"
    sha256 "494a7f1a2b18fcb2fcfb65628c3fc7b40ca4afe84283edd7d03fbbeddcad01f2"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
