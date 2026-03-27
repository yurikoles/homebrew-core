class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "560cad38cd298783c65e7b123afd4fce452f1884afe6b4097b249d1b11660a9f"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27aadbe70a75eafed5ae4260b932cecdec69511d20a7183354b04ed53c5c7f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0d1f927e8006e1162690791af4619023b1b6689bc1d8ee1780a6eadc1b90c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec5691e09700c7df5c354d823ad887ff2116193877c7de415bf581026338821"
    sha256 cellar: :any_skip_relocation, sonoma:        "13709ab6a59a214f18cf6d5ed6e8cf07405e49b8f7482ffab1ccf300108d2ea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecbedc9adf1fd6145a1516e01010d8897fe3c25d10f9959d42f8d63cba621afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be0873f567770dd465f569d1dc6324638a876257dc0db08ee953bf8239b51f0"
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
