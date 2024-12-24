<script>
	import { darkModeStore } from '$lib/store';
	import { onMount } from 'svelte';

	// To track the theme state
	let isDarkMode;
	$: {
		isDarkMode = $darkModeStore ? true : false;
	}

	// Function to toggle the dark mode
	function toggleDarkMode() {
		// Apply or remove the dark mode class from the <body>
		if (!isDarkMode) {
			document.body.classList.add('dark');
			updateDarkModeStore(true);
		} else {
			document.body.classList.remove('dark');
			updateDarkModeStore(false);
		}
	}

	function updateDarkModeStore(isDark) {
		darkModeStore.set(isDark);
	}
</script>

<label class="inline-flex cursor-pointer items-center">
	<!-- Hidden checkbox, no binding here for checked -->
	<input type="checkbox" checked={isDarkMode} class="peer sr-only" on:change={toggleDarkMode} />
	<div
		class="peer relative h-6 w-11 rounded-full bg-gray-200 after:absolute after:start-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-blue-600 peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rtl:peer-checked:after:-translate-x-full dark:border-gray-600 dark:bg-gray-700 dark:peer-focus:ring-blue-800"
	></div>
</label>
