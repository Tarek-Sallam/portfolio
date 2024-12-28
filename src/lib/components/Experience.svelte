<script>
	import ExperienceCard from './ExperienceCard.svelte';

	export let className = '';
</script>

<section id="experience" class={className}>
	<div class="mx-6 min-h-screen px-6 pt-24">
		<h2 class="mb-6 font-mono text-3xl font-bold text-black antialiased dark:text-white">
			Experience
		</h2>
		<div class="flex flex-col space-y-4">
			<ExperienceCard
				title="Teaching Assistant - Discrete Structures I & II"
				location="Carleton University - Ottawa, Canada"
				dates="May 2024 - Current"
			/>
			<ExperienceCard
				title="XR Technology Assistant"
				location="Carleton University - Ottawa, Canada"
				dates="September 2023 - May 2024"
			/>
		</div>
	</div>
</section>
