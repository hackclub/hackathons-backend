class ChangeJfifFilesToJpeg < ActiveRecord::Migration[7.2]
  def change
    reversible do |dir|
      dir.up do
        ActiveStorage::Blob.where("filename ILIKE ?", "%.jfif").find_each do |blob|
          blob.update!(filename: blob.filename.to_s.gsub(/\.jfif/i, ".jpeg"))
        end
      end

      dir.down do
        ActiveStorage::Blob.where("filename ILIKE ?", "%.jpeg").find_each do |blob|
          blob.update!(filename: blob.filename.to_s.gsub(/\.jpeg/i, ".jfif"))
        end
      end
    end
  end
end
