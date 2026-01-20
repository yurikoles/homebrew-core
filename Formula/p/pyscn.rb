class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2e5309e3865e0e6b486cba4016245afbe287ed537370eb747d05042b27145761"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a581dda3fc4166c5b10b42b014e30bfe5295202b68a0245d69d1e0db07cc3ee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52fc0ecd31140ccbbd0416766c70979a5bd59225f486ddf6f6b968ce97e36e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a41133807f7326e0b5bc8c97f1ddf44750c093ff81ef772a1693772c5d0c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a0f25e2d7e6da9594233248c446820a06d635a2a0c705029d46868df030bc1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57a48e10fb3a39aabdb46a9ca551727b8c8b007aea5404b2593c20a410024a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d037b3a0ab3946a9d9d76f3e12aae7934dc3f82a3774190e868a4ab6a500cc6c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end
