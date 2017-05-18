module Fastlane
  module Actions
    class OneskyTranslationStatusAction < Action
      def self.run(params)
        Actions.verify_gem!('onesky-ruby')
        require 'onesky'

        # Confgure the onesky plugin
        client = Onesky::Client.new(params[:public_key], params[:secret_key])
        project = client.project(params[:project_id])

        # Parse the response and get the raw progress value
        response = project.get_translation_status({
          file_name: params[:filename],
          locale: params[:locale]
        })
        result = JSON.parse(response)
        progress = result["data"]["progress"]

        # Return the progress as a float between 0 and 1
        progress.to_f / 100.0
      end

      def self.description
        "Obtains the translation status for a specific locale in a Onesky project"
      end

      def self.authors
        ["Liam Nichols"]
      end

      def self.return_value
        "The progress of translations for the specified locale (percentage between 0 and 1)"
      end

      def self.details
        # Optional:
        "Obtains the translation status for a specific locale in a Onesky project"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :public_key,
                                       env_name: 'ONESKY_PUBLIC_KEY',
                                       description: 'Public key for OneSky',
                                       is_string: true,
                                       optional: false,
                                       verify_block: proc do |value|
                                         raise "No Public Key for OneSky given, pass using `public_key: 'token'`".red unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :secret_key,
                                       env_name: 'ONESKY_SECRET_KEY',
                                       description: 'Secret Key for OneSky',
                                       is_string: true,
                                       optional: false,
                                       verify_block: proc do |value|
                                         raise "No Secret Key for OneSky given, pass using `secret_key: 'token'`".red unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: 'ONESKY_PROJECT_ID',
                                       description: 'Project Id to upload file to',
                                       optional: false,
                                       verify_block: proc do |value|
                                         raise "No project id given, pass using `project_id: 'id'`".red unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :locale,
                                       env_name: 'ONESKY_DOWNLOAD_LOCALE',
                                       description: 'Locale to download the translation for',
                                       is_string: true,
                                       optional: false,
                                       verify_block: proc do |value|
                                         raise 'No locale for translation given'.red unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :filename,
                                       env_name: 'ONESKY_DOWNLOAD_FILENAME',
                                       description: 'Name of the file to download the localization for',
                                       is_string: true,
                                       optional: false,
                                       verify_block: proc do |value|
                                         raise "No filename given. Please specify the filename of the file you want to download the translations for using `filename: 'filename'`".red unless value and !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
