require 'sinatra'
require 'pony'


get "/" do
  erb :contact
end

post '/contact' do
  if params["website"].blank?
    Pony.mail({
      to: 'lisa.alane.yoder@gmail.com',
      from: formatted_from_address(params),
      subject: params["subject"],
      body: params["body"],
      via: :smtp,
      via_options: {
        address:               'smtp.sendgrid.net',
        port:                  '587',
        enable_starttls_auto:  true,
        user_name:             ENV['SENDGRID_USERNAME'],
        password:              ENV["SENDGRID_PASSWORD"],
        authentication:        :plain,
        domain:                "heroku.com"
      }
    })
  end
  "message received"
end

private

def formatted_from_address(params)
  "#{params["name"]} <#{params["email"]}>"
end
