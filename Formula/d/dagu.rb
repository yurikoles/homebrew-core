class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "0d0b35efaa0c72f9a7eeaa0365c087ea3d64fe6994dc46870b61470a7fa9edf9"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e6c91886835ecc6f6199e8e27c578541ca0039b9df73201b1ee40aa443ddeb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edabc84fc6e601c2c28635718130ea04461a626f6241f6806d73424ddf8d0085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ed0223468c69f7b10285e4afd05db55f65d9c1722d7cb79be4bb8dbf50479d"
    sha256 cellar: :any_skip_relocation, sonoma:        "105868bb427f9b16203f46a41efc322f945d90894116b13d7609c01be47184c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07e326d68a76fa8ab1b2b5e82bda18ecb515a6fe8b07b611d6db28830f00f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256bafd90ee8c311632d2bb9c30a482524746afe168cc09339d02840f956b058"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
