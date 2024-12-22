<script lang="ts">
	import ThreeBackground from './ThreeBackground.svelte';

	const handleContact = () => {
		// Replace with your contact functionality, like opening an email or contact form
		alert('Contact me at example@example.com!');
	};

	const handleResume = () => {
		// Replace with a link to your resume file
		window.open('/path-to-your-resume.pdf', '_blank');
	};
</script>

<main class="relative flex h-screen w-full items-center justify-center bg-transparent text-white">
	<ThreeBackground canvasClass="absolute inset-0 z-0" />

	<div class="absolute z-10 text-center">
		<h1 class="font-sans text-4xl font-bold antialiased sm:text-5xl md:text-6xl">Hi, I'm Tarek!</h1>
		<p class="mt-4 text-lg sm:text-xl">Welcome to my portfolio! Feel free to explore.</p>
		<div class="mt-6 flex justify-center gap-4">
			<button
				on:click={handleContact}
				class="rounded bg-blue-500 px-4 py-2 font-semibold text-white transition duration-300 hover:bg-blue-600"
			>
				Contact Me
			</button>
			<button
				on:click={handleResume}
				class="rounded bg-green-500 px-4 py-2 font-semibold text-white transition duration-300 hover:bg-green-600"
			>
				Download Resume
			</button>
		</div>
	</div>
</main>

<style>
	/* You can add custom styles if needed */
</style>
