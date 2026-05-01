class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.12.0",
      revision: "7761527a420afc542a699aa5069475785700c2b7"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a78a0f705c6a0337106f00248332ce193a513946a69f9f8b33d6dd948d55e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f3b7b9f6ba31705e3bf84e7f05530f0d6e1a9a6c30ba356fc986c9c9a6b01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd512c270f6573f9fb107b120d708947d96f0f1255978ed4e6e8d10988884c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed368a68f135ea11a7deae5ccf9e2469b172bee818b69309d528c0cef123ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba623c767501774c3c089ad37ce1dc1ab6a21a7bd787e7256054515f92b3c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e5cd44cfebc17f8822be2b5df26b33e0296eed8919cf61ac4f5f15b0baef85"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
