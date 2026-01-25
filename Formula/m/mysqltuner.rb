class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.29.tar.gz"
  sha256 "5de9b127abe7455c942b2790fe0558a5c415c07582121ed59c9761bf26b0c9c3"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ea0ce49f647faa0f8f21867bc67604c4e3e38b3eb2a332c1958695de925d330"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system bin/"mysqltuner", "--help"
  end
end
