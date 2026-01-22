class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.4/composer.phar"
  sha256 "d3eb5c4cb2e708267dac5f9a76d2a57b07836c7ea68783a1a02bd6d94753ea80"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "513fefc68d0baf2947f5a19e5868f6699be8d16733103abde148a5ec1e3db528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "513fefc68d0baf2947f5a19e5868f6699be8d16733103abde148a5ec1e3db528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513fefc68d0baf2947f5a19e5868f6699be8d16733103abde148a5ec1e3db528"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95ef0193827861181262ffb2dc2bd414cc42475a7ab10f55ba647f287e4b67e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a95ef0193827861181262ffb2dc2bd414cc42475a7ab10f55ba647f287e4b67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95ef0193827861181262ffb2dc2bd414cc42475a7ab10f55ba647f287e4b67e"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
