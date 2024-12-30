<script>
	export let title = '';
	export let location = '';
	export let dates = '';
</script>

<div
	class="flex-col justify-between space-y-2 rounded-lg bg-gray-100 bg-opacity-75 px-4 py-4 font-mono tracking-tighter antialiased shadow-md dark:bg-black dark:bg-opacity-75 sm:space-y-4 sm:px-6 sm:py-6 sm:tracking-normal lg:space-y-6 lg:px-8 lg:py-8 xl:px-10 xl:py-10"
>
	<h3 class="text-xl font-semibold text-black dark:text-white sm:text-3xl">{title}</h3>
	<p class="text text-base text-gray-700 dark:text-gray-300 sm:text-xl">{location}</p>
	<p class="text-sm italic text-gray-500 sm:text-lg">{dates}</p>
</div>
