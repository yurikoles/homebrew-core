class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "046c7659da4b6667ea9670b1139d53616efe049b777ce8d44f4c14a8838fcd83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3162d9ffba0ec495bf5a2c76c5e0df4bb07c37ceb929674e205e9de7ecba987b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3162d9ffba0ec495bf5a2c76c5e0df4bb07c37ceb929674e205e9de7ecba987b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3162d9ffba0ec495bf5a2c76c5e0df4bb07c37ceb929674e205e9de7ecba987b"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d27aaf47d1737201f99020e1ec2131c982bf2bab6cb89a664cbbe822a26db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c4a369c2d6fe1b725d64940af69aa5cbd9959bb3ba378692539b656a8e361c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7950d6551f80830e672f949d0f046e9a49fef3a5be4b8ba6a547c2b713349683"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  def install
    system "go", "run", "./internal/codegen"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
