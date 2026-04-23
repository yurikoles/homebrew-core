class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "e36196a8ce3c8a68da601c408e214465dd17d5240b3781710c49e7b7e348d1ac"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rabbitmqadmin", "shell", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rabbitmqadmin --help")
    assert_match "Configuration file '~/.rabbitmqadmin.conf' does not exist",
                 shell_output("#{bin}/rabbitmqadmin config_file show 2>&1", 65)
    assert_match "error sending request for url (http://localhost:15672/api/channels)",
                 shell_output("#{bin}/rabbitmqadmin list channels 2>&1", 65)
  end
end
