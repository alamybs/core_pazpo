FactoryGirl.define do
  factory :property do
    property_category_id 1
    property_type 1
    description "Dijual rumah meriah."
    price "5.000.000.000"
  end
  factory :property_dicari, class: Property do
    property_category_id 1
    property_type 2
    description "Dicari rumah Mahal."
    price "7.000.000.000"
  end
  factory :property_dijual, class: Property do
    property_category_id 1
    property_type 2
    description "Dijual rumah meriah."
    price "5.000.000.000"
  end
end
