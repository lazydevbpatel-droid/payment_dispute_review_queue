class Evidence < ApplicationRecord
  belongs_to :dispute
  has_one_attached :file

  validate :text_or_file_present
  validate :file_content_type
  validate :file_size_limit

  private

  def text_or_file_present
    text = metadata.is_a?(Hash) ? metadata["text"].to_s.strip : ""
    if text.blank? && !file.attached?
      errors.add(:base, "Provide evidence text or upload a file.")
    end
  end

  def file_content_type
    return unless file.attached?

    allowed = ["application/pdf", "image/png", "image/jpeg"]
    unless allowed.include?(file.blob.content_type)
      errors.add(:file, "must be a PDF or image")
    end
  end

  def file_size_limit
    return unless file.attached?

    if file.blob.byte_size > 10.megabytes
      errors.add(:file, "must be less than 10MB")
    end
  end
end

