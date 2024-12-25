<script>
	import ExperienceCard from './ExperienceCard.svelte';

	export let className = '';
</script>

<section id="experience" class="snap-y overflow-y-scroll {className}">
	<div class="container mx-auto mt-6 px-6 py-12">
		<h2 class="mb-8 text-center font-mono text-4xl font-bold text-black dark:text-white">
			Experience
		</h2>
		<div class="flex flex-col items-center space-y-8">
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
