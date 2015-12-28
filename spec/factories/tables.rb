FactoryGirl.define do
  factory :table do
    association :bib, factory: :bib
    association :measurement_category, factory: :measurement_category
    caption "table caption"
    with_average true
    with_place true
    with_age true
    age_unit "a"
    description "table description"
  end
end
