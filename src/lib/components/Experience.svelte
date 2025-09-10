<script>
	import ExperienceCard from './ExperienceCard.svelte';

	export let className = '';
</script>

<section id="experience" class={className}>
	<div class="flex justify-center">
		<div
			class="mx-6 flex min-h-screen flex-col justify-center space-y-4 px-6 sm:mx-8 sm:space-y-6 sm:px-8 lg:mx-10 lg:space-y-8 lg:px-10 xl:mx-12 xl:mt-10 xl:w-3/4 xl:items-center xl:space-y-10 xl:px-12"
		>
			<h2 class="font-mono text-3xl font-bold text-black antialiased dark:text-white sm:text-5xl">
				Experience
			</h2>
			<div class="flex flex-col space-y-4 sm:space-y-6 lg:space-y-8 xl:space-y-10">
				<ExperienceCard
					title="Applied ML Engineering Intern"
					location="Shopify - Ottawa, Canada"
					dates="May 2025 - August 2025"
				/>
				<ExperienceCard
					title="Teaching Assistant - Discrete Structures I & II"
					location="Carleton University - Ottawa, Canada"
					dates="May 2024 - May 2025"
				/>
				<ExperienceCard
					title="XR Technology Assistant"
					location="Carleton University - Ottawa, Canada"
					dates="September 2023 - May 2024"
				/>
			</div>
		</div>
	</div>
</section>
