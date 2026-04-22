class Try < Formula
  desc "Quickly manage and navigate project directories for experiments"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9f6286851a0bb778e3e067921537dda7e9bd40343acdda48d9ba471e6179dd86"
  license "MIT"
  head "https://github.com/tobi/try.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521e3b8a8d73a27a2698b2e302ef48b0d8a9727fb1d48f9770cfec2341062d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "521e3b8a8d73a27a2698b2e302ef48b0d8a9727fb1d48f9770cfec2341062d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521e3b8a8d73a27a2698b2e302ef48b0d8a9727fb1d48f9770cfec2341062d3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "521e3b8a8d73a27a2698b2e302ef48b0d8a9727fb1d48f9770cfec2341062d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c0a20f7b2d35735bc893e334b765e56e4f24ee5e8a202c8308fe5e0dfd168d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c0a20f7b2d35735bc893e334b765e56e4f24ee5e8a202c8308fe5e0dfd168d"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["GEM_HOME"] = libexec

    gem_name = "try-cli"
    system "bundle", "install"
    system "gem", "build", "#{gem_name}.gemspec"
    system "gem", "install", "#{gem_name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    try_dir = "#{Dir.pwd}/src/tries/#{Date.today.iso8601}-tobi-try"
    expected_mkdir_command = "mkdir -p '#{try_dir}'"
    expected_clone_command = "git clone 'https://github.com/tobi/try.git' '#{try_dir}'"
    expected_cd_command = "cd '#{try_dir}'"
    output = shell_output("#{bin}/try exec clone https://github.com/tobi/try.git").chomp
    assert_match expected_mkdir_command, output
    assert_match expected_clone_command, output
    assert_match expected_cd_command, output
  end
end
