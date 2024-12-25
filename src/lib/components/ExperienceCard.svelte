<script>
	export let title = '';
	export let location = '';
	export let dates = '';
</script>

<div
	class="w-4/5 flex-col justify-between rounded-lg bg-gray-100 bg-opacity-75 p-6 shadow-md lg:w-1/2 dark:bg-black dark:bg-opacity-75"
>
	<h3 class="text-start text-2xl font-semibold text-black dark:text-white">{title}</h3>
	<p class="text-xl text-gray-700 dark:text-gray-300">{location}</p>
	<p class="text-sm text-gray-500">{dates}</p>
</div>
