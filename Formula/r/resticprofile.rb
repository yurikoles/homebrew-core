class Resticprofile < Formula
  desc "Configuration profiles manager and scheduler for restic backup"
  homepage "https://creativeprojects.github.io/resticprofile/"
  url "https://github.com/creativeprojects/resticprofile/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6f550580877d172965f29398a1fff2a11075d0592f09324b1d33efae6f7bf6fc"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git", branch: "master"

  depends_on "go" => :build
  depends_on "restic"

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
      -X 'main.version=#{version}'
      -X 'main.commit=#{commit}'
      -X 'main.date=#{time.iso8601}'
      -X 'main.builtBy=#{tap.user}'
    ]

    system "go", "build", *std_go_args(ldflags:, tags: "no_self_update")

    bash_completion.install "contrib/completion/bash-completion.sh" => "resticprofile"
    fish_completion.install "contrib/completion/fish-completion.fish" => "resticprofile.fish"
    zsh_completion.install "contrib/completion/zsh-completion.sh" => "_resticprofile"
  end

  test do
    (testpath/"repository").mkpath
    (testpath/"password.txt").write shell_output("#{bin}/resticprofile generate --random-key").strip
    (testpath/"profiles.toml").write <<~EOS
      [default]
      repository = "local:#{testpath}/repository"
      password-file = "#{testpath}/password.txt"
    EOS

    (testpath/"file.txt").write "Hello, Homebrew!"

    system bin/"resticprofile", "init"
    system bin/"resticprofile", "backup", "file.txt"
    system bin/"resticprofile", "check"
    system bin/"resticprofile", "restore", "latest", "--target", "restored"

    assert_equal (testpath/"file.txt").read, (testpath/"restored/file.txt").read
  end
end
