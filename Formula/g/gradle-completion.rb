class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v9.3.0.tar.gz"
  sha256 "07e6fc54a215abcd9c1a9a28e45607c666f20d72d6d68aac69a90e66c59f55e5"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8743b79a4d925b8c373ce44893693258f9f9000ca10a9e908259b57c4df2e24"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
