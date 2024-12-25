<!-- +app.svelte -->
<script lang="ts">
	import Main from '$lib/components/Main.svelte'; // Import Main.svelte as the main component
</script>

<Main />

<style>
	:global(html),
	:global(body) {
		overflow: hidden; /* Completely disables scrolling and hides scrollbar */
	}
</style>
