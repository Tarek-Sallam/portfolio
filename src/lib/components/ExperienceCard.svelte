<script>
	export let title = '';
	export let location = '';
	export let dates = '';
</script>

<div
	class="flex-col justify-between space-y-2 rounded-lg bg-gray-100 bg-opacity-75 px-4 py-4 font-mono tracking-tighter antialiased shadow-md dark:bg-black dark:bg-opacity-75"
>
	<h3 class="text-xl font-semibold text-black dark:text-white">{title}</h3>
	<p class="text-base text-gray-700 dark:text-gray-300">{location}</p>
	<p class="text-sm italic text-gray-500">{dates}</p>
</div>
