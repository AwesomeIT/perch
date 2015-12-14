require 'paperclip/media_type_spoof_detector'

# https://github.com/thoughtbot/paperclip/issues/1429
# this is how technical debt begins

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end