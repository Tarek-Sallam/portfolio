<script>
	/* IMPORT ALL COMPONENTS */
	import AboutMe from '$lib/components/AboutMe.svelte';
	import Experience from '$lib/components/Experience.svelte';
	import Header from '$lib/components/Header.svelte';
	import Hero from '$lib/components/Hero.svelte';
	import Projects from '$lib/components/Projects.svelte';
	import Three from '$lib/components/Three.svelte';

	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import { gsap } from 'gsap';
	import ScrollToPlugin from 'gsap/ScrollToPlugin';

	/* IMPORT STORES */
	import { darkModeStore, sectionInfoStore } from '$lib/store.js';

	// DEFAULT CLASSES FOR THE COMPONENTS
	const defaultClass = 'z-10 container mx-auto min-h-screen flex justify-center items-center';

	// CONSTANTS
	const animDuration = 1.5;

	// GLOBAL VARIABLES

	// STORE SETTERS
	function updateDarkModeStore(isDark) {
		darkModeStore.set(isDark);
	}
	function updateSectionInfoStore(info) {
		sectionInfoStore.set(info);
	}
	// STORE SUBSCRIPTIONS

	// GENERAL PURPOSE FUNCTIONS
	function matchTheme() {
		if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
			document.body.classList.add('dark');
			updateDarkModeStore(true);
		} else {
			document.body.classList.remove('dark');
			updateDarkModeStore(false);
		}
	}
	function getSectionInfo() {
		const sections = document.querySelectorAll('section');
		let sectionInfo = [];
		sections.forEach((section) => {
			const height = section.getBoundingClientRect().height;
			const top = section.offsetTop;
			sectionInfo.push({
				section: section,
				top: top,
				height: height
			});
		});

		return sectionInfo;
	}

	// CONSTRUCTION, INIT, DESTROY
	function construct() {
		// REGISTER GSAP PLUGINS
		gsap.registerPlugin(ScrollToPlugin);
	}
	function init() {
		matchTheme(); // match light or dark theme
		updateSectionInfoStore(getSectionInfo()); // update section info
	}

	function destroy() {}

	// ON MOUNT (CLIENT SIDE)
	onMount(() => {
		construct(); // construct
		init(); // initialize
		onDestroy(() => {
			destroy(); // destroy
		});
	});
</script>

<main class="relative flex min-h-screen flex-col bg-black dark:bg-white">
	<Three className="z-0 fixed top-0 left-0 right-0 w-full " />
	<Header {animDuration} className="z-20 fixed top-0 left-0 right-0" />
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
