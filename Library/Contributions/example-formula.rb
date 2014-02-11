require 'formula'

# This is a non-functional example formula to showcase all features and
# therefore, its overly complex and dupes stuff just to comment on it.
# You may want to use `brew create` to start your own new formula!
# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook


## Naming -- Every Homebrew formula is a class of the type `Formula`.
# Ruby classes have to start Upper case and dashes are not allowed.
# So we transform: `example-formula.rb` into `ExampleFormula`. Further,
# Homebrew does enforce that the name of the file and the class correspond.
# Check with `brew search` that the name is free. A file may contain multiple
# classes (we call them sub-formulae) but the main one is the class that
# corresponds to the filename.
class ExampleFormula < Formula

  homepage 'http://www.example.com' # used by `brew home example-formula`.

  # The url of the archive. Prefer https (security and proxy issues):
  url 'https://packed.sources.and.we.prefer.https.example.com/archive-1.2.3.tar.bz2'
  mirror 'https://in.case.the.host.is.down.example.com' # `mirror` is optional.

  # Optionally specify the download strategy `:using => ...`
  #     `:git`, `:hg`, `:svn`, `:bzr`, `:cvs`,
  #     `:curl` (normal file download. Will also extract.)
  #     `:nounzip` (without extracting)
  #     `:post` (download via an HTTP POST)
  #     `S3DownloadStrategy` (download from S3 using signed request)
  #     `UnsafeSubversionDownloadStrategy` (svn with invalid certs)
  url 'https://some.dont.provide.archives.example.com', :using => :git, :tag => '1.2.3'

  # version is seldom needed, because its usually autodetected from the URL/tag.
  version '1.2-final'

  # For integrity and security, we verify the hash (`openssl dgst -sha1 <FILE>`)
  # You may also use sha256 if the software uses sha256 on their homepage.
  # Leave it empty at first and `brew install` will tell you the expected.
  sha1 'cafebabe78901234567890123456789012345678'

  # Optionally, specify a repository to be used. Brew then generates a
  # `--HEAD` option. Remember to also test it.
  # The download strategies (:using =>) are the same as for `url`.
  head 'https://we.prefer.https.over.git.example.com/.git'
  head 'https://example.com/.git', :branch => 'name_of_branch', :revision => 'abc123'
  head 'https://hg.is.awesome.but.git.has.won.example.com/', :using => :hg # If autodetect fails.

  # The optional devel block is only executed if the user passes `--devel`.
  # Use this to specify a not-yet-released version of a software.
  devel do
   url 'https://example.com/archive-2.0-beta.tar.gz'
   sha1 '1234567890123456789012345678901234567890'
  end


  ## Options

  # Options can be used as arguemnts to `brew install`.
  # To switch features on/off: `'enable-something'` or `'disable-otherthing'`.
  # To use another software: `'with-other-software'` or `'without-foo'`
  # Note, that for dependencies that are `:optional` or `:recommended`, options
  # are generated automatically.
  # Build a universal (On newer intel Macs this means a combined 32bit and
  # 64bit binary/library). Todo: better explain what this means for PPC.
  option :universal
  option 'enable-spam', 'The description goes here without a dot at the end'
  option 'with-qt', 'Text here overwrites the autogenerated one from `depends_on "qt"`'
  # Only show an option if the Command Line Tools are installed:
  option 'with-dtrace', 'Experimental DTrace support' if MacOS::CLT.installed?

  ## Bottles

  # Bottles are pre-built and added by the Homebrew maintainers for you.
  # If you maintain your own repository, you can add your own bottle links.
  # Read in the wiki about how to provide bottles:
  # <https://github.com/Homebrew/homebrew/wiki/Bottles>
  bottle do
    root_url 'http://mikemcquaid.com' # Optional root to calculate bottle URLs
    prefix '/opt/homebrew' # Optional HOMEBREW_PREFIX in which the bottles were built.
    cellar '/opt/homebrew/Cellar' # Optional HOMEBREW_CELLAR in which the bottles were built.
    revision 1 # Making the old bottle outdated without bumping the version of the formula.
    sha1 'd3d13fe6f42416765207503a946db01378131d7b' => :mountain_lion
    sha1 'cdc48e79de2dee796bb4ba1ad987f6b35ce1c1ee' => :lion
    sha1 'a19b544c8c645d7daad1d39a070a0eb86dfe9b9c' => :snow_leopard
    sha1 '583dc9d98604c56983e17d66cfca2076fc56312b' => :snow_leopard_32
  end

  def pour_bottle?
    # Only needed if this formula has to check if using the pre-built
    # bottle is fine.
    true
  end

  ## keg_only

  # Software that will not be sym-linked into the `brew --prefix` will only
  # live in it's Cellar. Other formulae can depend on it and then brew will
  # add the necessary includes and libs (etc.) during the brewing of that
  # other formula. But generally, keg_only formulae are not in your PATH
  # and not seen by compilers if you build your own software outside of
  # Homebrew. This way, we don't shadow software provided by OS X.
  keg_only :provided_by_osx
  keg_only "because I want it so"


  ## Dependencies

  # The dependencies for this formula. Use strings for the names of other
  # formulae. Homebrew provides some :special dependencies for stuff that
  # requires certain extra handling (often changing some ENV vars or
  # deciding if to use the system provided version or not.)

  # `:build` means this dep is only needed during build.
  depends_on 'cmake' => :build
  # Explictly name formulae in other taps.
  depends_on 'homebrew/dupes/tcl-tk'
  # `:recommended` dependencies are built by default. But a `--without-...`
  # option is generated to opt-out.
  depends_on 'readline' => :recommended
  # `:optional` dependencies are NOT built by default but a `--with-...`
  # options is generated.
  depends_on 'glib' => :optional
  # If you need to specify that another formula has to be built with/out
  # certain options (note, no `--` needed before the option):
  depends_on 'zeromq' => 'with-pgm'
  depends_on 'qt' => ['with-qtdbus', 'developer'] # Multiple options.
  # Optional and enforce that boost is built with `--with-c++11`.
  depends_on 'boost' => [:optional, 'with-c++11']
  # If a dependency is only needed in certain cases:
  depends_on 'sqlite' if MacOS.version == :leopard
  depends_on :xcode # If the formula really needs full Xcode.
  depends_on :clt # If the formula really needs the CLTs for Xcode.
  depends_on :tex # Homebrew does not provide a Tex Distribution.
  depends_on :fortran # Checks that `gfortran` is available or `FC` is set.
  depends_on :mpi => :cc # Needs MPI with `cc`
  depends_on :mpi => [:cc, :cxx, :optional] # Is optional. MPI with `cc` and `cxx`.
  depends_on :macos => :lion # Needs at least Mac OS X "Lion" aka. 10.7.
  depends_on :arch => :intel # If this formula only builds on intel architecture.
  depends_on :arch => :x86_64 # If this formula only build on intel x86 64bit.
  depends_on :arch => :ppc # Only builds on PowerPC?
  depends_on :ld64 # Sometimes ld fails on `MacOS.version < :leopard`. Then use this.
  depends_on :x11 # X11/XQuartz components.
  depends_on :libpng # Often, not all of X11 is needed.
  depends_on :fontconfig
  # autoconf/automake is sometimes needed for --HEAD checkouts:
  depends_on :autoconf if build.head?
  depends_on :automake if build.head?
  depends_on :bsdmake
  depends_on :libtool
  depends_on :libltdl
  depends_on :mysql => :recommended
  depends_on :cairo if build.devel?
  depends_on :pixman if build.devel?
  # It is possible to only depend on something if
  # `build.with?` or `build.without? 'another_formula'`:
  depends_on :mysql # allows brewed or external mysql to be used
  depends_on :postgresql if build.without? 'sqlite'
  depends_on :hg # Mercurial (external or brewed) is needed

  # If any Python >= 2.6 < 3.x is okay (either from OS X or brewed):
  depends_on :python
  # Python 3.x if the `--with-python3` is given to `brew install example`
  depends_on :python3 => :optional

  # Modules/Packages from other languages, such as :chicken, :jruby, :lua,
  # :node, :ocaml, :perl, :python, :rbx, :ruby, can be specified by
  depends_on 'some_module' => :lua

  ## Conflicts

  # If this formula conflicts with another one:
  conflicts_with 'imagemagick', :because => 'because this is just a stupid example'


  ## Failing with a certain compiler?

  # If it is failing for certain compiler:
  fails_with :llvm do # :llvm is really llvm-gcc
    build 2334
    cause "Segmentation fault during linking."
  end

  fails_with :clang do
    build 425
    cause 'multiple configure and compile errors'
  end


  ## Patches

  # Optionally define a `patches` method returning `DATA` and/or a string with
  # the url to a patch or a list thereof.
  def patches
    # DATA is the embedded diff that comes after __END__ in this file!
    # In this example we only need the patch for older clang than 425:
    DATA unless MacOS.clang_build_version >= 425
  end

  # More than the one embedded patch? Use a dict with keys :p0, :p1 and/or
  # p2: as you need, for example:
  def patches
    {:p0 => [
      'https://trac.macports.org/export/yeah/we/often/steal/a/patch.diff',
      'https://github.com/example/foobar/commit/d46a8c6265c4c741aaae2b807a41ea31bc097052.diff',
      DATA ],
     # For gists, please use the link to a specific hash, so nobody can change it unnoticed.
     :p2 => ['https://raw.github.com/gist/4010022/ab0697dc87a40e65011e2192439609c17578c5be/tags.patch']
    }
  end


  ## The install method.

  def install
    # Now the sources (from `url`) are downloaded, hash-checked and
    # Homebrew has changed into a temporary directory where the
    # archive has been unpacked or the repository has been cloned.

    # Print a warning (do this rarely)
    opoo 'Dtrace features are experimental!' if build.with? 'dtrace'

    # Sometimes we have to change a bit before we install. Mostly we
    # prefer a patch but if you need the `prefix` of this formula in the
    # patch you have to resort to `inreplace`, because in the patch
    # you don't have access to any var defined by the formula. Only
    # HOMEBREW_PREFIX is available in the embedded patch.
    # inreplace supports reg. exes.
    inreplace 'somefile.cfg', /look[for]what?/, "replace by #{bin}/tool"

    # To call out to the system, we use the `system` method and we prefer
    # you give the args separately as in the line below, otherwise a subshell
    # has to be opened first.
    system "./bootstrap.sh", "--arg1", "--prefix=#{prefix}"

    # For Cmake, we have some necessary defaults in `std_cmake_args`:
    system "cmake", ".",  *std_cmake_args

    # If the arguments given to configure (or make or cmake) are depending
    # on options defined above, we usually make a list first and then
    # use the `args << if <condition>` to append to:
    args = ["--option1", "--option2"]
    args << "--i-want-spam" if build.include? "enable-spam"
    args << "--qt-gui" if build.with? "qt" # "--with-qt" ==> build.with? "qt"
    args << "--some-new-stuff" if build.head? # if head is used instead of url.
    args << "--universal-binary" if build.universal?

    # The `build.with?` and `build.without?` are smart enough to do the
    # right thing™ with respect to defaults defined via `:optional` and
    # `:recommended` dependencies.

    # If you need to give the path to lib/include of another brewed formula
    # please use the `opt_prefix` instead of the `prefix` of that other
    # formula. The reasoning behind this is that `prefix` has the exact
    # version number and if you update that other formula, things might
    # break if they remember that exact path. In contrast to that, the
    # `$(brew --prefix)/opt/formula` is the same path for all future
    # versions of the formula!
    args << "--with-readline=#{Formula.factory('readline').opt_prefix}/lib" if build.with? "readline"

    # Most software still uses `configure` and `make`.
    # Check with `./configure --help` what our options are.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args # our custom arg list (needs `*` to unpack)

    # If your formula's build system is not thread safe:
    ENV.deparallelize

    # A general note: The commands here are executed line by line, so if
    # you change some variable or call a method like ENV.deparallelize, it
    # only affects the lines after that command.

    # Do something only for clang
    if ENV.compiler == :clang
      # modify CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS in one go:
      ENV.append_to_cflags '-I ./missing/includes'
    end

    # This is in general not necessary, but to show how to find the path to
    # the Mac OS X SDK:
    ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    # Overwriting any env var:
    ENV['LDFLAGS'] = '--tag CC'

    system "make", "install"

    # We are in a temporary directory and don't have to care about cleanup.

    # Instead of `system "cp"` or something, call `install` on the Pathname
    # objects as they are smarter with respect to correcting access rights.
    # (`install` is a Homebrew mixin into Ruby's Pathname)

    # The pathnames defined in the formula
    prefix # == HOMEBREW_PREFIX+'Cellar'+name+version
    bin # == prefix+'bin'
    doc # == share+'doc'+name
    include # == prefix+'include'
    info # == share+'info'
    lib # == prefix+'lib'
    libexec # == prefix+'libexec'
    buildpath # The temporary directory where build occurs.

    man # share+'man'
    man1 # man+'man1'
    man2 # man+'man2'
    man3 # man+'man3'
    man4 # man+'man4'
    man5 # man+'man5'
    man6 # man+'man6'
    man7 # man+'man7'
    man8 # man+'man8'
    sbin # prefix+'sbin'
    share # prefix+'share'
    frameworks # prefix+'Frameworks'
    kext_prefix # prefix+'Library/Extensions'
    # Configuration stuff that will survive formula updates
    etc # HOMEBREW_PREFIX+'etc'
    # Generally we don't want var stuff inside the keg
    var # HOMEBREW_PREFIX+'var'
    bash_completion # prefix+'etc/bash_completion.d'
    zsh_completion # share+'zsh/site-functions'
    # Further possibilities with the pathnames:
    # http://www.ruby-doc.org/stdlib-1.8.7/libdoc/pathname/rdoc/Pathname.html

    # Sometime you will see that instead of `+` we build up a path with `/`
    # because it looks nicer (but you can't nest more than two `/`):
    (var/'foo').mkpath
    # Copy `./example_code/simple/ones` to share/demos
    (share/'demos').install "example_code/simple/ones"
    # Copy `./example_code/simple/ones` to share/demos/examples
    (share/'demos').install "example_code/simple/ones" => 'examples'

    # Additional stuff can be defined in a sub-formula (see below) and
    # with a block like this, it will be extracted into its own temporary
    # dir. We can install into the Cellar of the main formula easily,
    # because `prefix`, `bin` and all the other pre-defined variables are
    # from the main formula.
    AdditionalStuff.new.brew { bin.install 'my/extra/tool' }

    # `name` and `version` are accessible too, if you need them.
  end


  ## Caveats

  def caveats
    "Are optional. Something the user should know?"
  end

  def caveats
    s = <<-EOS.undent
      Print some important notice to the user when `brew info <formula>` is
      called or when brewing a formula.
      This is optional. You can use all the vars like #{version} here.
    EOS
    s += "Some issue only on older systems" if MacOS.version < :mountain_lion
    s
  end


  ## Test (is optional but makes us happy)

  test do
    # `test do` will create, run in, and delete a temporary directory.

    # We are fine if the executable does not error out, so we know linking
    # and building the software was ok.
    system bin/'foobar', '--version'

    (testpath/'Test.file').write <<-EOS.undent
      writing some test file, if you need to
    EOS
    # To capture the output of a command, we use backtics:
    assert_equal 'OK', ` test.file`.strip

    # Need complete control over stdin, stdout?
    require 'open3'
    Open3.popen3("#{bin}/example", "big5:utf-8") do |stdin, stdout, _|
      stdin.write("\263\134\245\134\273\134")
      stdin.close
      assert_equal "許功蓋", stdout.read
    end

    # If an exception is raised (e.g. by assert), or if we return false, or if
    # the command run by `system` prints to stderr, we consider the test failed.
  end


  ## Plist handling

  # Define this method to provide a plist.
  # Todo: Expand this example with a little demo plist? I dunno.
  # There is more to startup plists. Help, I suck a plists!
  def plist; nil; end
end

class AdditionalStuff < Formula
  # Often, a second formula is used to download some resource
  # NOTE: This is going to change when https://github.com/Homebrew/homebrew/pull/21714 happens.
  url 'https://example.com/additional-stuff.tar.gz'
  sha1 'deadbeef7890123456789012345678901234567890'
end

__END__
# Room for a patch after the `__END__`
# Read in the wiki about how to get a patch in here:
#    https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
# In short, `brew install --interactive --git <formula>` and make your edits.
# Then `git diff >> path/to/your/formula.rb`
# Note, that HOMEBREW_PREFIX will be replaced in the path before it is
# applied. A patch can consit of several hunks.