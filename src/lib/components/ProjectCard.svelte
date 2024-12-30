<script>
	import { darkModeStore } from '$lib/store';
	export let title = '';
	export let description = '';
	export let toolsUsed = '';
	export let githubLink = '';
	export let demoLink = '';
	let githubSource, linkSource;

	$: {
		githubSource = $darkModeStore ? './github_w.svg' : './github.svg';
		linkSource = $darkModeStore ? './link_w.svg' : './link.svg';
	}
</script>

<div
	class="flex h-full flex-col justify-between space-y-2 rounded-lg bg-gray-100 bg-opacity-75 px-4
	py-4 font-mono tracking-tighter antialiased shadow-md shadow-gray-300 dark:bg-black dark:bg-opacity-75
	dark:shadow-none sm:space-y-4 sm:px-6 sm:py-6 sm:tracking-normal lg:px-8 lg:py-8 xl:space-y-6 xl:px-10 xl:py-10 2xl:space-y-0"
>
	<h3 class="text-xl font-semibold text-black dark:text-white sm:text-3xl">{title}</h3>
	<p class="text-base font-normal text-gray-700 dark:text-gray-300 sm:text-xl">
		{description}
	</p>
	<p class="text-sm italic text-gray-500 sm:text-lg">
		{toolsUsed}
	</p>
	<div class="center-items flex w-full justify-center space-x-6 sm:space-x-8">
		<a
			href={githubLink}
			target="_blank"
			class="h-8 w-8 transition-transform duration-300 hover:scale-110 sm:h-12 sm:w-12 lg:h-14 lg:w-14"
		>
			<img src={githubSource} alt="GitHub logo" />
		</a>
		{#if demoLink !== ''}
			<a
				href={demoLink}
				target="_blank"
				class="h-8 w-8 transform transition-transform duration-300 hover:scale-110 sm:h-12 sm:w-12 lg:h-14 lg:w-14"
			>
				<img src={linkSource} alt="link logo" />
			</a>
		{/if}
	</div>
</div>
