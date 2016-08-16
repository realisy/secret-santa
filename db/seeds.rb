# Create main user
city.create!(
  city_name: 'Rio de Janeiro',
  province: 'RJ',
  country: 'Brazil'
)

city.create!(
  city_name: 'Sao Paulo',
  province: 'RJ',
  country: 'Brazil'
)



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

