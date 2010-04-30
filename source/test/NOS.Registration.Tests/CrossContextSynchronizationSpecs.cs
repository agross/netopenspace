using System;
using System.Threading;

using Machine.Specifications;

namespace NOS.Registration.Tests
{
	[Subject(typeof(CrossContextSynchronizer))]
	public class When_a_reader_tries_to_read_while_a_writer_is_active
	{
		static ISynchronizer Synchronizer;
		static int SharedValue;
		static int ReadValue;

		Establish context = () => { Synchronizer = new CrossContextSynchronizer(); };

		Because of = () =>
			{
				SharedValue = 25;
				AutoResetEvent writerReady = new AutoResetEvent(false);

				Thread reader = new Thread(() => Synchronizer.Lock(() =>
					{
						Console.WriteLine("Reading");
						ReadValue = SharedValue;
					}))
				                { Name = "Reader" };

				Thread writer = new Thread(() => Synchronizer.Lock(() =>
					{
						writerReady.Set();

						Thread.Sleep(1000);
						Console.WriteLine("Writing");
						SharedValue = 42;
					}))
				                { Name = "Writer" };

				writer.Start();
				writerReady.WaitOne();
				reader.Start();

				writer.Join();
				reader.Join();
			};

		It should_write_the_new_value =
			() => SharedValue.ShouldEqual(42);

		It should_read_after_the_writer_finished =
			() => ReadValue.ShouldEqual(42);
	}

	[Subject(typeof(CrossContextSynchronizer))]
	public class When_locks_are_nested_in_the_same_thread
	{
		static ISynchronizer Synchronizer;
		static bool Status;

		Establish context = () => { Synchronizer = new CrossContextSynchronizer(); };

		Because of = () =>
			{
				Thread worker = new Thread(() => Synchronizer.Lock(() => Synchronizer.Lock(() => { Status = true; })))
				                { Name = "Worker" };

				worker.Start();
				worker.Join(TimeSpan.FromMinutes(1));
			};

		It should_succeed =
			() => Status.ShouldBeTrue();
	}
}