require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.1.tar.gz"
  sha1 "ccb66c462aff098bcdace60e52aad64439177b48"

  option "with-qt", "Build with QT widgets in addition to wxWidgets"
  option "with-docs", "Build gnuradio documentation"
  option "with-brewed-python", "Use the Homebrew version of Python"

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

  depends_on :fortran => :build
  depends_on "cmake" => :build
  depends_on "matplotlib" => :python
  depends_on "boost"
  depends_on "cppunit"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "swig" => :build
  depends_on "pygtk"
  depends_on "sdl"
  depends_on "libusb"
  depends_on "orc"
  depends_on "pyqt" if build.with? "qt"
  depends_on "pyqwt" if build.with? "qt"
  depends_on 'sphinx' if build.with? "docs"
  depends_on "wxpython"
  depends_on "wxmac"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    %w[Cheetah lxml].each do |r|
      resource(r).stage { Language::Python.setup_install "python", libexec }
    end
    %w[numpy scipy].each do |r|
      resource(r).stage { Language::Python.setup_install "python", libexec,
                                                         "--fcompiler=gnu95"}
    end

    if build.with? "docs"
      resource("docutils").stage do
        Language::Python.setup_install "python", "#{buildpath}"
      end
    end

    mkdir "build" do
      ENV["CMAKE_C_COMPILER"] = "#{ENV.cc}"
      ENV["CMAKE_CXX_COMPILER"] = "#{ENV.cxx}"

      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
      ]
      if build.with? "brewed-python"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      if build.with? "docs"
        args << "-DSPHINX_EXECUTEABLE=#{buildpath}/bin/rst2html.py"
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

      bin.env_script_all_files(prefix, :PYTHONPATH => ENV["PYTHONPATH"])
      inreplace "#{prefix}/etc/gnuradio/conf.d/grc.conf" do |s|
        s.gsub! "#{prefix}/", "#{HOMEBREW_PREFIX}/"
      end
    end
  end
end
