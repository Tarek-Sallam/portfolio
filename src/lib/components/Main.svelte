<!-- Main.svelte -->
<script>
	import Three from './Three.svelte';

	const handleContact = () => {
		// Replace with your contact functionality, like opening an email or contact form
		alert('Contact me at example@example.com!');
	};

	const handleResume = () => {
		// Replace with a link to your resume file
		window.open('/path-to-your-resume.pdf', '_blank');
	};
</script>

<main class="relative">
	<!-- Render Three.js Background -->
	<Three />

	<!-- Content on top of the Three.js background -->
	<div class="absolute inset-0 z-10 flex items-center justify-center text-white">
		<div class="text-center">
			<h1 class="mb-4 text-4xl font-bold">Hi, I'm Tarek!</h1>
			<p class="mb-4">Welcome to my portfolio! Feel free to explore.</p>
			<div>
				<button
					class="mb-2 rounded-md bg-blue-500 px-6 py-2 text-white shadow-md hover:bg-blue-700"
					on:click={handleContact}
				>
					Contact Me
				</button>
				<button
					class="rounded-md bg-green-500 px-6 py-2 text-white shadow-md hover:bg-green-700"
					on:click={handleResume}
				>
					Download Resume
				</button>
			</div>
		</div>
	</div>
</main>

<style>
	main {
		min-height: 100vh;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
	}
</style>
