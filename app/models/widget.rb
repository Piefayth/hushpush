class Widget < ActiveRecord::Base

  attr_accessible :properties, :name, :user_id
  before_create :build_widget_preference
  belongs_to :user
  has_one :widget_preference, dependent: :destroy, autosave: true
  validates :properties, presence: true
  validates :name, presence: true
  validates :user_id, presence: true

	def get_gmail
		require 'net/imap'
		require 'gmail_xoauth'
		require 'mail'

		imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
		if self.updated_at > 30.minutes.ago || self.widget_preference.gmail_access_token.blank?
			refresh_gmail_access_token
		end
		begin
			imap.authenticate('XOAUTH2', self.widget_preference.gmail_address, self.widget_preference.gmail_access_token)
			imap.select('INBOX')
			messages = Array.new
			imap.search(["NOT", "DELETED"]).first(10).each do |id|
				messages << Mail.new( imap.fetch(id, 'RFC822')[0].attr['RFC822']) 
			end
			imap.disconnect
			return messages
		rescue
			self.widget_preference.gmail_access_token = " "
			self.save
			get_gmail
		end
	end

	private 
		def refresh_gmail_access_token
			url = URI.parse('https://accounts.google.com/o/oauth2/token')
			request = Net::HTTP::Post.new(url.request_uri)
			request.set_form_data({refresh_token: self.widget_preference.gmail_refresh_token, 
									client_id: '948359240643.apps.googleusercontent.com',
									client_secret: 'KlDdcCN1lnetPu2eL1fzI3rf',
									grant_type: 'refresh_token'})
			response = Net::HTTP.start(url.host, use_ssl: true) do |http| http.request(request) end
			response = JSON.parse(response.body)
			self.widget_preference.gmail_access_token = response["access_token"]
			self.widget_preference.gmail_expires_in = response["expires_in"]
			self.save
		end

		def build_default_widget_preference
			build_widget_preference
		end
end
