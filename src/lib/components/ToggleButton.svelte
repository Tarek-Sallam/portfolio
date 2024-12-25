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
		class="peer relative h-6 w-11 rounded-full bg-black after:absolute after:left-[2px] after:top-[2px] after:h-5
        after:w-5 after:rounded-full after:bg-white after:transition-all
        after:content-[''] peer-checked:bg-white peer-checked:after:translate-x-full peer-checked:after:bg-black"
	></div>
</label>
