FactoryGirl.define do
  factory :attachment do
    file { File.new(Rails.root.join('spec', 'spec_helper.rb')) }
  end
end
