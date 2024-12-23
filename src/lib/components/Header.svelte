<script>
	export let logoSrc = './logoWhite.svg';
</script>

<header class="bg-black px-4 py-4 text-lg text-white">
	<div class="mx-auto flex w-full justify-between px-8 py-3">
		<div class="h-auto w-12">
			<img src={logoSrc} alt="Logo" />
		</div>

		<nav class="flex justify-between space-x-10">
			<a href="/">About</a>
			<a href="/">Projects</a>
		</nav>
	</div>
</header>

<style>
	header {
		width: 100%;
	}
</style>
