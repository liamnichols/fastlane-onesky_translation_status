describe Fastlane::Actions::OneskyTranslationStatusAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The onesky_translation_status plugin is working!")

      Fastlane::Actions::OneskyTranslationStatusAction.run(nil)
    end
  end
end
