require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.1.tar.gz"
  sha1 "ccb66c462aff098bcdace60e52aad64439177b48"

  option 'with-qt', 'Build with exta GUI features that use QT'
  option 'with-docs', 'Build gnuradio documentation using sphinx.'

  depends_on "cmake" => :build
  depends_on 'Cheetah' => :python
  depends_on 'lxml' => :python
  depends_on 'numpy' => :python
  depends_on 'scipy' => :python
  depends_on 'matplotlib' => :python
  depends_on 'python'
  depends_on 'boost'
  depends_on 'cppunit'
  depends_on 'gsl'
  depends_on 'fftw'
  depends_on 'swig' => :build
  depends_on 'pygtk'
  depends_on 'sdl'
  depends_on 'libusb'
  depends_on 'orc'
  depends_on 'pyqt' if build.with? "qt"
  depends_on 'pyqwt' if build.with? "qt"
  depends_on 'sphinx' if build.with? "docs"
  depends_on 'wxpython'
  depends_on 'wxmac'

  def install
    ENV['CMAKE_C_COMPILER'] = '#{ENV.cc}'
    ENV['CMAKE_CXX_COMPILER'] = '#{ENV.cxx}'

    mkdir 'build' do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
        ] + std_cmake_args

      if build.with? "docs"
        args << "-DSPHINX_EXECUTEABLE=/usr/local/bin/rst2html.py"
      else
        args << "-DENABLE_SPHINX=OFF"
      end

      if build.with? "qt"
        args << "-DENABLE_GR_QTGUI=ON"
      else
        args << "-DENABLE_GR_QTGUI=OFF"
      end


    system "cmake", "..", *args
    system "make"
    system "make install"
  end
  end
 end
