class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "e115f589921eca6205341cf5f44af4c0d3bb0b5b9583eceddfaecdf21a0f243d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce5ea5291d14e2af8aa3c7be928b406cf5931a5b7300aa842caefdeba7dd8d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce5ea5291d14e2af8aa3c7be928b406cf5931a5b7300aa842caefdeba7dd8d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5ea5291d14e2af8aa3c7be928b406cf5931a5b7300aa842caefdeba7dd8d11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0871c61cef51ea45935062990d6553e7d251294811b9760410e58321fac89dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5925c251f5b40590c8e38c9f47c1329224e6143740cc159eb87a1d6fd13cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7190471f79a9fef197f5ec998b86c9c61c12aa379b085d8a4e97b6f76935299"
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
