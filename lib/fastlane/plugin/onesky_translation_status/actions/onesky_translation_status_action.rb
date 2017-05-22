module Fastlane
  module Actions
    class OneskyTranslationStatusAction < Action
      def self.run(params)
        Actions.verify_gem!('onesky-ruby')
        require 'onesky'

        # Confgure the onesky plugin
        client = ::Onesky::Client.new(params[:public_key], params[:secret_key])
        project = client.project(params[:project_id])

        # Loop each locale provided
        results = { }
        params[:locales].each { |locale|
          UI.message "Getting status of '#{locale}' translations in '#{params[:project_id]}'"

          # Parse the response and get the raw data
          result = JSON.parse(project.get_translation_status({file_name: params[:filename], locale: locale}))
          data = result["data"]
          data["progress_value"] = data["progress"].to_f / 100.0

          # Add the data to the results
          results[locale] = data
        }

        # Return the results
        results
      end

      def self.description
        "Obtains the translation status for a specific locale in a Onesky project"
      end

      def self.authors
        ["Liam Nichols"]
      end

      def self.return_value
        "A dictionary of locales based on the provided values and their statuses"
      end

      def self.details
        "Obtains the translation status for a specific locale in a Onesky project"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :public_key,
                                       env_name: 'ONESKY_PUBLIC_KEY',
                                       description: 'Public key for OneSky',
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :secret_key,
                                       env_name: 'ONESKY_SECRET_KEY',
                                       description: 'Secret Key for OneSky',
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: 'ONESKY_PROJECT_ID',
                                       description: 'Project Id to upload file to',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :locales,
                                       env_name: 'ONESKY_STATUS_LOCALES',
                                       description: 'Locale to download the translation for',
                                       type: Array,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :filename,
                                       env_name: 'ONESKY_STATUS_FILENAME',
                                       description: 'Name of the file to download the localization for',
                                       is_string: true,
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
