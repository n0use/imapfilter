-- edit this file to support your imap server options
-- prompts for password rather than storing in plain text 

host = 'localhost'
user = os.getenv("USER") 
pass = get_password('Enter IMAP password for imapfilter (you only enter it once, then it demonizes): ')

account = IMAP {
	server =   host,
	username = user,
	password = pass,
	ssl = 'ssl3',
}
