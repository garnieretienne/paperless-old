module ImageService

  private

  # Add HTTP Headers (Cache Control, Last-Modified, Etag)
  def serve_image(path, created_at, etag)
    if stale? last_modified: created_at.utc, etag: etag
      expires_in 1.year, public: false
      send_file path, inline: true
    end
  end
end