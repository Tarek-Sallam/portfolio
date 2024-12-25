<script>
	export let className = '';

	const handleContact = () => {
		alert('Contact me at example@example.com!');
	};

	const handleResume = () => {
		window.open('', '_blank');
	};
</script>

<section id="hero" class={className}>
	<div class="flex flex-grow items-center justify-center text-black dark:text-white">
		<div class="text-center">
			<h1 class="mb-4 text-6xl font-bold">Tarek Sallam</h1>
			<div>
				<button class="mb-2 rounded-md bg-blue-500 px-6 py-2" on:click={handleContact}>
					Contact Me
				</button>
				<button class="rounded-md bg-green-500 px-6 py-2" on:click={handleResume}> Resume </button>
			</div>
		</div>
	</div>
</section>
