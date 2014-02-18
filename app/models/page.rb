class Page < ActiveRecord::Base
  mount_uploader :snapshot, SnapshotUploader

  belongs_to :document

  validates :number, presence: true, uniqueness: {scope: :document_id}
  validates :snapshot, presence: true
  validates :document, presence: true
end
