require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db  	
end

configure do
	db = get_db 
	db.execute 'CREATE TABLE IF NOT EXISTS
	 	"Users" 
	 	(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	 	 	"username" TEXT,
	 	 	"phone" TEXT, 
	 	 	"datestamp" TEXT, 
	 	 	"barber" TEXT, 
	 	 	"color" TEXT
	 	 )'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = "Something wrong!"
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone    = params[:phone]
	@datetime = params[:datetime]
	@barber   = params[:barber]
	@color    = params[:color]


	hh = {	:username => 'Введите имя', 
			:phone => 'Введите номер телефона',
			:datetime => 'Введите дату и время'	}


	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values ( ?, ?, ?, ?, ? )', [@username, @phone, @datetime, @barber, @color]

	@title = 'Thank you!'

	@message = "Dear #{@username}, we'll be waiting for you #{@datetime}"

	f  = File.open './public/users.txt' , 'a'
	f.write "User: #{@username}, Phone: #{@phone} , Date and time: #{@datetime}, Barber: #{@barber}, #{@color} ;     "
	f.close

	erb :message
end

post '/contacts' do
	@email = params[:email]
	@text     = params[:text]

	@title = 'Thank you!'

	t  = File.open './public/contacts.txt' , 'a'
	t.write "Email: #{@email}, Text: #{@text}"
	t.close

	erb :message

end

get '/showusers' do
  erb :showusers
end

