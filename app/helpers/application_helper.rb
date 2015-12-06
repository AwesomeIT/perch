module ApplicationHelper
  
  BOOTSTRAP_CLASSES = {
    "success" => "alert-success",
    "error" => "alert-danger",
    "alert" => "alert-warning",
    "notice" => "alert-info"
  }

  def bootstrap_class_for(flash_level)
    BOOTSTRAP_CLASSES[flash_level] || flash_level.to_s
  end
end
