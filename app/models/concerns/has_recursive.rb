module HasRecursive
  extend ActiveSupport::Concern
  included do
    with_recursive(order: :name)
  end

  def self_and_descendants
  	[self].concat(self.descendants.to_a)
  end
end
