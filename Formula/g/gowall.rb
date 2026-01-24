class Gowall < Formula
  desc "Tool to convert a Wallpaper's color scheme / palette"
  homepage "https://achno.github.io/gowall-docs/"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ff5289250cd1bfe7adef728c85c4c97aed906330e9bd79760be540eb49343d51"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222163cc3152f06d848ac28ba2bab3ec6fd2203987a8f147ac59dbefc4fe692c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d18bb347bb59ae880592fe8e0678832e99380d8a51692664ceb676785589517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb69283e0903f722879f96513a5f4c44b95e4b9a804a07bdc159673bdcafd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af5bdd065485a4afa557d3a94caae8a1dd30da0207f5d99e20980da29709c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9d4b881ff9705718de4b96b63ab15e0f08e1d976b02eb027979760614f53478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10cab58524563fc7d14e63b4f8cb050b7eab22323538027c32a7a01c13feab1"
  end

  depends_on "go" => :build
  depends_on "mupdf"

  resource "go-fitz" do
    url "https://github.com/gen2brain/go-fitz/archive/refs/tags/v1.24.15.tar.gz"
    sha256 "086b656bbb00c314083b7097b1d295f98034f4d75ffddf4fc706a5f1c3c5cf6b"
  end

  def install
    # Work around https://github.com/gen2brain/go-fitz/issues/143
    (buildpath/"go-fitz").install resource("go-fitz")
    (buildpath/"go.work").write <<~GOMOD
      go #{Formula["go"].version.major_minor}
      use .
      replace github.com/gen2brain/go-fitz => ./go-fitz
    GOMOD
    inreplace "go-fitz/fitz_cgo.go", "C.int(len(buf))", "C.size_t(len(buf))"

    ENV["CGO_ENABLED"] = "1" # for go-fitz
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "extlib")

    generate_completions_from_executable(bin/"gowall", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
