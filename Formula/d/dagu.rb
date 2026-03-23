class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "782277d2fe44066e4b59f86236d89488ba8115ab8c1b0a00a06271bac117ab0b"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbacbf07c804da320e5b379e94c4d18f5e4cf0778aa4dd58b7298ba8a97e2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b912f457ed613df98583933bc757fef5139a7ad5d9c9a6ccb87851864462be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba6c76ecef3bcfb9240da46ef6220f51ef23de35b1d2b1b53d39fd6fda62ed3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1811381efe831b6655432abc23fc82578352f065689b70afa6eed3a325cf2af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea863791a903085bdaab051bce09b7c41f411210e0f62ad7476c3a6049814df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f79c84e391f6b3eca1e84114dcdca90045e0123eba703540cb4eb7e1589104d"
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
