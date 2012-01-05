require 'formula'

class KdeBaseapps < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kde-baseapps-4.7.4.tar.bz2'
  homepage 'http://kde.org/'
  md5 'd44310cad99a9afb757ff13f24eeae32'


  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'

  def install
    mkdir 'build'
    cd 'build'
    kdelibs = Formula.factory 'kdelibs'
    system "cmake .. -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_INSTALL_PREFIX=#{kdelibs.prefix} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end
end
