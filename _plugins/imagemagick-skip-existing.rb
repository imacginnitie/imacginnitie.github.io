# Regenerate a responsive .webp only when it is MISSING, ignoring file mtimes.
#
# jekyll-imagemagick's stock behaviour rebuilds any output whose mtime is <= its
# source image. That breaks our deploy cache: the GitHub Actions workflow
# restores previously-generated webp files from actions/cache, but tar restores
# them with their original (older) mtimes while actions/checkout stamps the
# source images with the current time — so every source looks newer than its
# cached output and all ~300 images get reconverted on every run.
#
# The cache key is a hash of assets/img/**, so a restored webp already implies
# its source is unchanged. Existence is therefore a sufficient signal to skip,
# and mtime is noise. This override reopens the generator and drops that check.
#
# Tradeoff: replacing an image in place (same filename, new bytes) won't refresh
# its webp until _site is cleaned. In CI that's a non-issue — a changed source
# changes the cache key, misses the cache, and regenerates from scratch. Locally,
# `rm -rf _site` (or a fresh build) picks up in-place edits.
require 'jekyll-imagemagick'

module JekyllImagemagick
  class ImageGenerator
    private

    def generate_files(site, tuples, formats)
      generated_files = 0

      tuples.each do |tuple|
        input_file_full_path, output_file_full_path, edge = tuple

        unless File.file?(output_file_full_path)
          extension = File.extname(output_file_full_path).sub('.', '')
          ImageConvert.run(input_file_full_path,
                           output_file_full_path,
                           formats[extension],
                           edge,
                           @config['resize_flags'])
          generated_files += 1
        end

        next unless File.file?(output_file_full_path)

        # Keep the webp file from being cleaned by Jekyll.
        prefix = File.dirname(input_file_full_path.sub(site.source, ''))
        site.static_files << ImageFile.new(site,
                                           site.dest,
                                           prefix,
                                           File.basename(output_file_full_path))
      end

      generated_files
    end
  end
end
