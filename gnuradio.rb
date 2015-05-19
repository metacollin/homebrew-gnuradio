require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.7.1.tar.gz"
  sha256 "2b27b13fc734ab5882e42c1661d433c0c097fd8b55b682f00626fa96c356584e"

  option "without-qt", "Build with QT widgets in addition to wxWidgets"
  option "without-docs", "Build gnuradio documentation"

  depends_on :python
  build.without? "python-deps"
  depends_on "Cheetah" => :python
  depends_on "lxml" => :python
  depends_on "matplotlib" => :python
  depends_on "numpy" => :python
  depends_on "scipy" => :python
  depends_on "docutils" => :python
  depends_on :fortran => :build
  depends_on "swig" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cppunit"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "sip"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on "sdl"
  depends_on "libusb"
  depends_on "orc"
  depends_on "pyqt" if build.with? "qt"
  depends_on "pyqwt" if build.with? "qt"
  depends_on "sphinx" if build.with? "docs"
  depends_on "sphinx" => :python if build.with? "docs"
  depends_on "wxpython"
  depends_on "wxmac"
  depends_on "freetype"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
        -DCMAKE_C_COMPILER=#{ENV.cc}
        -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      ]
      # Find the right python, system or homebrew.
      args << "-DPYTHON_EXECUTABLE='#{%x(python-config --prefix).chomp}/bin/python'"
      args << "-DPYTHON_INCLUDE_DIR='#{%x(python-config --prefix).chomp}/include/python2.7'"
      args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      if build.with? "docs"
        args << "-DENABLE_SPHINX=ON"
      else
        args << "-DENABLE_SPHINX=OFF"
      end

      if build.with? "qt"
        args << "-DENABLE_GR_QTGUI=ON"
      else
        args << "-DENABLE_GR_QTGUI=OFF"
      end

      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make install"
      inreplace "#{prefix}/etc/gnuradio/conf.d/grc.conf" do |s|
        s.gsub! "#{prefix}/", "#{HOMEBREW_PREFIX}/"
      end
    end
  end
end
