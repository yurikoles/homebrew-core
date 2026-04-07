class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tgz"
  sha256 "b4c059d5895f030e7df9663894ce3732bfa1b32cd3ab2883980266a45ce3cb3b"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69e7e5faf2ce879d0c29a5d28716f94c2c4301fc1eb0012bffb58e5b44249d2b"
    sha256 cellar: :any, arm64_sequoia: "ef64a5b1aeccecb3262930bab62a30061e514008e490aabd0beb22da453a3335"
    sha256 cellar: :any, arm64_sonoma:  "3e0fa3b7b807ef03abaa60ab316c50e0255702b0fdc64e446c508e66a6cd3781"
    sha256 cellar: :any, sonoma:        "88f4034267c9fd249fb3180145e5946b9e4ea7c739b71a0a2c97c8921c18e340"
    sha256               arm64_linux:   "0037e048b183aedd3436c771a1f4c80841617c080d93c78f449281359445cea4"
    sha256               x86_64_linux:  "251e611096b158aaf897d49c73aa87b8b71a6ec354003c1fbaf19e2e4f2e4ed2"
  end

  depends_on "gdbm"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "gdbm"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_gdbm"
      sources = ["_gdbmmodule.c"]
      include-dirs = ["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"]
      libraries = ["gdbm"]
      library-dirs = ["#{Formula["gdbm"].opt_lib}"]
    TOML

    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~PYTHON
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    PYTHON
  end
end
