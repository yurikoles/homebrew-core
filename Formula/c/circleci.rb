class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.36202",
      revision: "50a6f5685ea024c53fd11ed477742382cfbdaade"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a57d5ffde3f7e40fa96d16006225fca951c8ad44cd7d71ddd0a2cb4ce6c0e518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71dc89c932f9a2e1663257f32e5d2aa4cfc78b10afb77c0c7673f1553acf1d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c52845e97ab5ca98b9a51712d692d790e75d494aa596f1d33f5a3ddcedc82f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e424f3a1bd8fc40c55dba1f553277a385680d9c3e1681ec4f17430dd07bbdc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0cdd4dd16e4633a71a355b5b4208160c687a528e4a355e13f18229eac79a54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cb54b365272b2165862f88f7569c88939695fef04e0c5a988cbe0d62412129"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
