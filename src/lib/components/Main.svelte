<script>
	import AboutMe from './AboutMe.svelte';
	import Experience from './Experience.svelte';
	import Header from './Header.svelte';
	import Hero from './Hero.svelte';
	import Projects from './Projects.svelte';
	import Three from './Three.svelte';
	let defaultClass = 'z-10 container mx-auto min-h-screen flex justify-center items-center';
</script>

<main class="relative flex min-h-screen flex-col bg-black">
	<!--
	<Three className="z-0 absolute w-full" />
	-->
	<Header className="z-20 fixed top-0 left-0 right-0" />
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
