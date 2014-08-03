require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  url "http://jenkins.gnuradio.org/builds/gnuradio-jenkins-GNURadio-master-82-0-g93db96fa-2014-07-21.tar.gz"
  sha1 "08c4ee3fc30dd3c3ccd097cccd8efff7971e6feb"

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
  depends_on 'swig'
  depends_on 'pygtk'
  depends_on 'sdl'
  depends_on 'libusb'
  depends_on 'orc'
  depends_on 'pyqt' #if ARGV.include?('--with-qt')
  depends_on 'pyqwt' #if ARGV.include?('--with-qt')
  depends_on 'doxygen'# if ARGV.include?('--with-docs')
  depends_on 'sphinx' #if ARGV.include?('--with-docs')
  depends_on 'wxmac'
  depends_on 'wxpython'
  depends_on 'wxwidgets'


 # def options
    [
  #    ['--with-qt', 'Build gr-qtgui.'],
  #    ['--with-docs', 'Build docs.']
    ]
#  end
  

  def install
    ENV['CMAKE_C_COMPILER'] = '/usr/bin/llvm-gcc'
    ENV['CMAKE_CXX_COMPILER'] = 'CXX=/usr/bin/llvm-g++'
    
    mkdir 'build' do
      args = ["-DCMAKE_PREFIX_PATH=#{prefix}", "-DPYTHON_EXECUTABLE=/usr/local/Cellar/python/2.7.8/bin/python", "-DPYTHON_INCLUDE_DIR=/usr/local/Cellar/python/2.7.8/Frameworks/Python.framework/Headers", "-DSPHINX_EXECUTEABLE=/usr/local/bin/rst2html.py", "-DPYTHON_LIBRARY=/usr/local/Cellar/python/2.7.8/Frameworks/Python.framework/Versions/2.7/Python"] + std_cmake_args
     # args << '-DENABLE_GR_QTGUI=OFF' unless ARGV.include?('--with-qt')
      #args << '-DENABLE_DOXYGEN=OFF' unless ARGV.include?('--with-docs')
      
    
    system "cmake", "..", *args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
 end
  
end
