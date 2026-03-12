class VapoursynthDescale < Formula
  desc "VapourSynth plugin to undo upscaling"
  homepage "https://github.com/Irrational-Encoding-Wizardry/descale"
  url "https://github.com/Irrational-Encoding-Wizardry/descale/archive/refs/tags/r8.tar.gz"
  sha256 "317d955cc2dfbc3fd1aecef2ea2d56e4f1cd99434492d71c6a1d48213ff35972"
  license "MIT"
  head "https://github.com/Irrational-Encoding-Wizardry/descale.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "installdir = join_paths(vs.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "installdir = '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.descale"
  end
end
