class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "19c1c2d9d86338ca8db3740d94e1a559d26103035fb7dd29ef667cf6d543e436"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3116d62535390452009656099a9b90cd687a2c1b1ad0fd9eb26dd3300daf1a4d"
  end

  uses_from_macos "unzip"

  on_macos do
    depends_on "grep"
  end

  conflicts_with "tenv", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
    bin.env_script_all_files libexec,
                             TFENV_CONFIG_DIR: "${TFENV_CONFIG_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/tfenv}"
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
    with_env(TFENV_TERRAFORM_VERSION: "0.10.0", TF_AUTO_INSTALL: "false") do
      assert_equal "0.10.0", shell_output("#{bin}/tfenv version-name").strip
    end
  end
end
