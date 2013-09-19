module UsersHelper
  # Fragment cache key for users
  def cache_key_for_users
    count   = User.count
    max_updated_at = User.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "products/all-#{count}-#{max_updated_at}"
  end
end
