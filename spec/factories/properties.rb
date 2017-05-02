FactoryGirl.define do
  factory :property do
    property_type 1 # "#dijual"
    description "Dijual rumah meriah."
    price "5.000.000.000"
  end
  factory :property_dicari, class: Property do
    property_type 2 # "#dicari"
    description "Dicari rumah Mahal."
    price "7.000.000.000"
  end
  factory :property_dijual, class: Property do
    property_type 1 # "#dijual"
    description "Dijual rumah meriah."
    price "5.000.000.000"
  end
end
