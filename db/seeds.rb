require 'faker'

# Create main user
city = City.create!(
  city_name: 'Toronto',
  province: 'ON',
  country: 'Canada'
)

user = User.create!(
  name: 'Leonardo Rossi',
  email: 'leorossi@gmail.com',
  password: 'senha',
  city: city
)

5.times do
  gift_name = Faker::Commerce.product_name
  gift_description = Faker::Lorem.sentence(3, false, 4)
  est_value = Faker::Commerce.price

  user.gifts.create!(
    gift_name: gift_name,
    gift_description: gift_description,
    est_value: est_value,
    user: user
  )
end

20.times do
  city_name = Faker::Address.city
  province = Faker::Address.state_abbr
  country = Faker::Address.country

  city = City.create!(
    city_name: city_name,
    province: province,
    country: country
  )
  




end

20.times do 
  user_name = Faker::Name.name
  email = Faker::Internet.email
  password = Faker::Internet.password

  city_id = rand(City.count)+1
  city = City.find(city_id)

  user = User.create!(
    name: user_name,
    email: email,
    password: password,
    city: city
  )

  5.times do
    gift_name = Faker::Commerce.product_name
    gift_description = Faker::Lorem.sentence(3, false, 4)
    est_value = Faker::Commerce.price

    user.gifts.create!(
      gift_name: gift_name,
      gift_description: gift_description,
      est_value: est_value,
      user: user
    )
  end
end

20.times do

  city_id = rand(City.count)+1
  city = City.find(city_id)
  user_id = rand(User.count)+1
  user = User.find(user_id)


  event_name = Faker::Lorem.sentence(1, true)
  event_description = Faker::Lorem.sentence(3, false, 4)
  start_date = Faker::Date.between(Date.today, 10.days.from_now)
  registration_deadline = Faker::Date.between(11.days.from_now, 20.days.from_now)
  event_date = Faker::Date.between(21.days.from_now, 30.days.from_now)
  public_event = Faker::Boolean.boolean(0.1)
  max_participants = Faker::Number.between(10, 100)
  min_value = Faker::Number.between(10, 30)
  max_value = Faker::Number.between(30, 200)

  event = Event.create!(
    event_name: event_name,
    event_description: event_description,
    start_date: start_date,
    registration_deadline: registration_deadline,
    event_date: event_date,
    public_event: public_event,
    max_participants: max_participants,
    min_value: min_value,
    max_value: max_value,
    city: city,
    user: user
    )

end
