class AddPhotoToWorkers < ActiveRecord::Migration
  def change
    add_attachment :workers, :photo
  end
end
