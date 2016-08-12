require 'sqlite3'
require 'sequel'
require 'zlib'
require 'stringio'
require 'fileutils'

Dir.glob('*.mbtiles') {|fn|
  Sequel.sqlite(fn)[:tiles].each {|r|
    t = fn.sub('.mbtiles', '')
    z = r[:zoom_level]
    x = r[:tile_column]
    y = (1 << r[:zoom_level]) - r[:tile_row] - 1
    data = r[:tile_data]
    dir = [t, z, x].join('/')
    FileUtils::mkdir_p(dir) unless File.directory?(dir)
    File.open("#{dir}/#{y}.mvt", 'w') {|w|
      w.print Zlib::GzipReader.new(StringIO.new(data)).read
    }
    print "wrote #{dir}/#{y}.mvt\n"
  }
}
