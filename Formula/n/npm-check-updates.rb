class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-21.0.0.tgz"
  sha256 "65c5ef3d0df31383c60cdfc33e33671f5eca45b5c2642b72b586750ce1734da4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8f904e764422154bb67f9f3497e457c85ac5a8a216c92a50b1cd84101d82f19"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~JSON
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    JSON

    system bin/"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end
