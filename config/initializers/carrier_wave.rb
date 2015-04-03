if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAJFVUOSUQ4PB5IHDA'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['findandrewrailstutorial']
  end
end
