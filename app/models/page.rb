class Page < ActiveRecord::Base
  mount_uploader :snapshot, SnapshotUploader

  belongs_to :document
end
