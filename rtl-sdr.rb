require "formula"

class RtlSdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  head "https://github.com/steve-m/librtlsdr.git"
  
  option 'with-qt', 'Build with exta GUI features that use QT'
  option 'with-docs', 'Build gnuradio documentation using sphinx.'
  
  depends_on "cmake" => :build
  depends_on 'libusb'
  

  def install
    ENV['CMAKE_C_COMPILER'] = '/usr/bin/llvm-gcc'
    ENV['CMAKE_CXX_COMPILER'] = '/usr/bin/llvm-g++'
    
    mkdir 'build' do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        ] + std_cmake_args
        
    system "cmake", "..", *args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
  end
 end
