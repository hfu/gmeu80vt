require 'find'
require './_config_.rb'

targets = []
Find.find("../#{$source}/") {|path|
  next unless path.end_with?('shp')
  target = File.basename(path, '.shp').downcase
  targets << target
  minzoom = %w{watrcrsl roadl railrdl builtupp hynodec lakeresa levelcc shorel}.include?(target) ? 8 : 3
  print "echo #{target}\n"
  print "rm -f #{target}.geojson\n"
  print "ogr2ogr -f GeoJSON #{target}.geojson #{path}\n"
  print "../tippecanoe/tippecanoe -Bg --minimum-zoom=#{minzoom} --maximum-zoom=8 -f -o #{target}.mbtiles -n #{target} -l #{target} #{target}.geojson\n"
}
