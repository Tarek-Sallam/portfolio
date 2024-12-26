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
	import { cameraStore, sectionStore, scrollStore, darkModeStore } from '$lib/store.js';

	// DEFAULT CLASSES FOR THE COMPONENTS
	const defaultClass = 'z-10 container mx-auto min-h-screen flex justify-center items-center';

	// CONSTANTS
	const duration = 1.3; // duration of page transitions
	const timeoutDuration = duration * 1000 + 100; // time out scroll duration in ms

	// GLOBAL VARIABLES
	let isScrolling = false; // is page scrolling determined by store\
	let currentSection = 0; // currentSection of the page determined by store
	let scrollToSection; // Prop to point to scrollTo function
	let sections; // An array to hold the section HTML elements

	let sectionUnsubscribe, scrollUnsubscribe; // for store subscribe cleanup

	// STORE SETTERS
	function updateCamera(newPosition) {
		cameraStore.set(newPosition);
	}
	function updateSection(newSection) {
		sectionStore.set(newSection);
	}
	function updateScroll(newScroll) {
		scrollStore.set(newScroll);
	}
	function updateDarkModeStore(isDark) {
		darkModeStore.set(isDark);
	}

	// STORE SUBSCRIPTIONS
	function onSectionSubscribe(section) {
		currentSection = section;
	}
	function onScrollSubscribe(scroll) {
		isScrolling = scroll;
	}

	function matchTheme() {
		if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
			document.body.classList.add('dark');
			updateDarkModeStore(true);
		} else {
			document.body.classList.remove('dark');
			updateDarkModeStore(false);
		}
	}

	// CONSTRUCTION, INIT, DESTROY
	function construct() {
		// SUBSCRIBE TO THE STORES
		sectionUnsubscribe = sectionStore.subscribe((section) => {
			onSectionSubscribe(section);
		});
		scrollUnsubscribe = scrollStore.subscribe((scroll) => {
			onScrollSubscribe(scroll);
		});

		// REGISTER GSAP PLUGINS
		gsap.registerPlugin(ScrollToPlugin);

		// Point my function pointer to the scrollTo function
		scrollToSection = (index, factor) => {
			scrollTo(index, factor);
		};

		// Get the sections
		sections = document.querySelectorAll('section');

		// Add event listeners
	}

	function init() {
		// make the section the first section, and scroll to it (instantly) before unlocking the scroll
		updateSection(0);
		scrollToSection(0, 0);
		updateScroll(false);
		matchTheme();
	}

	function destroy() {
		// CLEANUP EVENT LISTENERS

		// KILL TWEENS
		gsap.killTweensOf(window);

		// CLEANUP STORES
		if (sectionUnsubscribe) {
			sectionUnsubscribe();
		}
		if (scrollUnsubscribe) {
			scrollUnsubscribe();
		}
	}

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
	<Three {duration} className="z-0 fixed top-0 left-0 right-0 w-full " />
	<!-- <Header {scrollToSection} {timeoutDuration} className="z-20 fixed top-0 left-0 right-0" /> -->
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
