class Nyx < Formula
  include Language::Python::Virtualenv

  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "923f5f72eee8bd8f5ed40fb9010489dabe5b954f7bf10edf09634104458e63ad"
  end

  depends_on "python@3.14"

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  # Support python 3.11
  patch do
    url "https://github.com/torproject/nyx/commit/dcaddf2ab7f9d2ef8649f98bb6870995ebe0b893.patch?full_index=1"
    sha256 "132cf1c3d4ce6e706cc3ad9dd5cd905d3321c7e62386e18219b4eb08816d6849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}/nyx -i 127.0.0.1:#{free_port}", 1)
  end
end

__END__
diff --git a/stem/control.py b/stem/control.py
index e192e29..e6fab6c 100644
--- a/stem/control.py
+++ b/stem/control.py
@@ -474,7 +474,7 @@ def with_default(yields = False):

   def decorator(func):
     def get_default(func, args, kwargs):
-      arg_names = inspect.getargspec(func).args[1:]  # drop 'self'
+      arg_names = inspect.getfullargspec(func).args[1:]  # drop 'self'
       default_position = arg_names.index('default') if 'default' in arg_names else None

       if default_position is not None and default_position < len(args):
diff --git a/stem/prereq.py b/stem/prereq.py
index 4af6c09..4009c31 100644
--- a/stem/prereq.py
+++ b/stem/prereq.py
@@ -241,7 +241,7 @@ def is_mock_available():

     # check for mock's new_callable argument for patch() which was introduced in version 0.8.0

-    if 'new_callable' not in inspect.getargspec(mock.patch).args:
+    if 'new_callable' not in inspect.getfullargspec(mock.patch).args:
       raise ImportError()

     return True
diff --git a/stem/util/conf.py b/stem/util/conf.py
index 8039981..15c4db8 100644
--- a/stem/util/conf.py
+++ b/stem/util/conf.py
@@ -285,7 +285,7 @@ def uses_settings(handle, path, lazy_load = True):
         config.load(path)
         config._settings_loaded = True

-      if 'config' in inspect.getargspec(func).args:
+      if 'config' in inspect.getfullargspec(func).args:
         return func(*args, config = config, **kwargs)
       else:
         return func(*args, **kwargs)
