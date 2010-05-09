using Machine.Specifications;

using NOS.Registration.Abstractions;

using Rhino.Mocks;

using ScrewTurn.Wiki.PluginFramework;

namespace NOS.Registration.Tests.Abstractions
{
	[Subject(typeof(EmailNotificationSender))]
	public class When_an_email_is_sent
	{
		static IFileReader Reader;
		static EmailNotificationSender Sender;
		static IHostV30 Host;
		static ISettingsAccessor Settings;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();

				Reader = MockRepository.GenerateStub<IFileReader>();
				Reader
					.Stub(x => x.Read("template file"))
					.Return("template contents");

				Settings = MockRepository.GenerateStub<ISettingsAccessor>();
				Settings.Stub(x => x.SenderEmail).Return("sender@example.com");
				Settings.Stub(x => x.WikiTitle).Return("My Wiki");
				Settings.Stub(x => x.MainUrl).Return("http://example.com");

				Sender = new EmailNotificationSender(Reader, Settings);
				Sender.Configure(Host);
			};

		Because of = () => Sender.SendMessage("user name", "recipient@example.com", "subject", "template file");

		It should_load_the_template =
			() => Reader.AssertWasCalled(x => x.Read("template file"));

		It should_send_the_message_using_the_configured_host =
			() => Host.AssertWasCalled(x => x.SendEmail("recipient@example.com",
			                                            "sender@example.com",
			                                            "subject - My Wiki",
			                                            "template contents",
			                                            false));
	}

	[Subject(typeof(EmailNotificationSender))]
	public class When_an_email_with_placeholders_is_sent
	{
		static IFileReader Reader;
		static EmailNotificationSender Sender;
		static IHostV30 Host;
		static ISettingsAccessor Settings;

		Establish context = () =>
			{
				Host = MockRepository.GenerateStub<IHostV30>();

				Reader = MockRepository.GenerateStub<IFileReader>();
				Reader
					.Stub(x => x.Read("template file"))
					.Return("##WIKITITLE##, ##USERNAME##, ##WIKIURL##");

				Settings = MockRepository.GenerateStub<ISettingsAccessor>();
				Settings.Stub(x => x.SenderEmail).Return("sender@example.com");
				Settings.Stub(x => x.WikiTitle).Return("My Wiki");
				Settings.Stub(x => x.MainUrl).Return("http://example.com");

				Sender = new EmailNotificationSender(Reader, Settings);
				Sender.Configure(Host);
			};

		Because of = () => Sender.SendMessage("user name", "recipient@example.com", "subject", "template file");

		It should_replace_placeholders_with_values =
			() => Host.AssertWasCalled(x => x.SendEmail(Arg<string>.Is.Anything,
			                                            Arg<string>.Is.Anything,
			                                            Arg<string>.Is.Anything,
			                                            Arg<string>.Is.Equal("My Wiki, user name, http://example.com"),
			                                            Arg<bool>.Is.Anything));
	}
}