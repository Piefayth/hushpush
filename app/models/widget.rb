class Widget < ActiveRecord::Base
  serialize :properties, JSON
  attr_accessible :properties, :name, :user_id
  belongs_to :user

  validates :properties, presence: true
  validates :name, presence: true
  validates :user_id, presence: true

	def get_gmail
		require 'net/imap'
		require 'gmail_xoauth'
		require 'mail'

		imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
		if self.updated_at + self.properties["gmail_expires_in"] - 5 < Time.now
			refresh_gmail_access_token
		end
		begin
			imap.authenticate('XOAUTH2', self.properties["gmail_address"], self.properties["gmail_access_token"])
			imap.select('INBOX')
			messages = Array.new
			imap.search(["NOT", "DELETED"]).first(10).each do |id|
				messages << Mail.new( imap.fetch(id, 'RFC822')[0].attr['RFC822']) 
			end
			imap.disconnect
			return messages
		rescue
			#self.properties["gmail_access_token"] = " "
			#self.properties["gmail_refresh_token"] = " "
			#self.properties["gmail_expires_in"] = " "
			return nil
			self.save
		end
	end

	private 
		def refresh_gmail_access_token
			url = URI.parse('https://accounts.google.com/o/oauth2/token')
			request = Net::HTTP::Post.new(url.request_uri)
			request.set_form_data({refresh_token: self.properties["refresh_token"], 
									client_id: '948359240643.apps.googleusercontent.com',
									client_secret: 'KlDdcCN1lnetPu2eL1fzI3rf',
									grant_type: 'refresh_token'})
			response = Net::HTTP.start(url.host, use_ssl: true) do |http| http.request(request) end
			response = JSON.parse(response.body)

			self.properties["access_token"] = response["access_token"]
			self.properties["gmail_expires_in"] = response["expires_in"]
			self.save
		end
end
