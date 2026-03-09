class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.46.0.tar.gz"
  sha256 "ae4e85dfe0efa299e9cc4097aa2ea077f409237797e6b51093f986ad8fbe603a"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425f3b5f3ca1f653e2d3fd258818c4594bf86ec8503150e187ac9ae5077d38ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "94d505a6fa0d44b125ff6591f05b3b30c716dbb39f3376595f318099b5ce621d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24c033643be2d055a4447a4b21822c59dec1e3ec32a013c4a7e03f2c5b0d61a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7406404b69b61b21176e77607ea9142b8e9b16c8b2504f41ce636d8e76a58c2b"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202603050223/geoip.dat"
    sha256 "c6c1d1be0d28defef55b153e87cb430f94fb480c8f523bf901c5e4ca18d58a00"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202603050223/geoip-only-cn-private.dat"
    sha256 "55cef17909fd51a3381a034c72635e2512121495b0443fc10aed7521fecce55a"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260309055128/dlc.dat"
    sha256 "3ec0ebbc2776133afe1e81c565e834e692e25d103104d2950b5e94328f1d8e11"
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
