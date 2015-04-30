require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.1.tar.gz"
  sha1 "ccb66c462aff098bcdace60e52aad64439177b48"

  option "without-qt", "Build with QT widgets in addition to wxWidgets"
  option "without-docs", "Build gnuradio documentation"
  option "with-python-deps", "Will handle python dependencies for you. Deprecated."

  if build.with? "python-deps"
    resource "docutils" do
      url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
      sha1 "002450621b33c5690060345b0aac25bc2426d675"
    end

    resource "Cheetah" do
      url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
      sha1 "c218f5d8bc97b39497680f6be9b7bd093f696e89"
    end

    resource "lxml" do
      url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.1.tar.gz"
      sha1 "c09f4e8e71fc9d49fb43bf33821da816ce887396"
    end

    resource "numpy" do
      url "http://downloads.sourceforge.net/project/numpy/NumPy/1.9.1/numpy-1.9.1.tar.gz"
      sha1 "a96ddd221b34c08f08ae700a51969ddeb17d40ea"
    end

    resource "scipy" do
      url "http://downloads.sourceforge.net/project/scipy/scipy/0.14.0/scipy-0.14.0.tar.gz"
      sha1 "faf16ddf307eb45ead62a92ffadc5288a710feb8"
    end

    resource "matplotlib" do
      url "https://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.4.2/matplotlib-1.4.2.tar.gz"
      sha1 "242c57ddae808b1869cad4b08bb0973c513e12f8"
    end
  end

  depends_on :python
  if build.without? "python-deps"
    depends_on "Cheetah" => :python
    depends_on "lxml" => :python
    depends_on "matplotlib" => :python
    depends_on "numpy" => :python
    depends_on "scipy" => :python
    depends_on "docutils" => :python
  end
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
  depends_on 'sphinx' if build.with? "docs"
  depends_on "wxpython"
  depends_on "wxmac"
  depends_on "freetype"

  def install
    if build.with? "python-deps"
      ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
      python_args = ["install", "--prefix=#{libexec}"]
      %w[Cheetah lxml].each do |r|
        resource(r).stage { system "python", "setup.py", *python_args }
      end
        resource("matplotlib").stage do
          if MacOS.version >= :yosemite
            inreplace "setupext.py", "'freetype2', 'ft2build.h',", "'freetype2', 'freetype2/ft2build.h',"
          end
          system "python", "setup.py", *python_args
        end
      python_fortran_args = ["build", "--fcompiler=gfortran", *python_args]
      %w[numpy scipy].each do |r|
        resource(r).stage { system "python", "setup.py", *python_fortran_args }
      end

      if build.with? "docs"
        resource("docutils").stage do
          system "python", "setup.py", "install", "--prefix=#{buildpath}"
        end
      end
    end

    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
        -DCMAKE_C_COMPILER=#{ENV.cc}
        -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      ]

      args << "-DPYTHON_EXECUTABLE='#{%x(python-config --prefix).chomp}/bin/python'"
      args << "-DPYTHON_INCLUDE_DIR='#{%x(python-config --prefix).chomp}/include/python2.7'"
      args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"

      if build.with? "docs"
        if build.with? "python-deps"
          args << "-DSPHINX_EXECUTEABLE=#{buildpath}/bin/rst2html.py"
        end
        args << "-DENABLE_SPHINX=OFF"
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
