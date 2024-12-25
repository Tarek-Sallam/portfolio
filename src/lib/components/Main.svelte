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
	// GENERAL PURPOSE FUNCTIONS
	function scrollTo(index, factor) {
		// get the target section element given the index
		const targetSection = sections[index];

		// update the camera store for the new index (so Three moves camera)
		updateCamera(index);

		// animate the transition to the target section
		gsap.to(window, {
			scrollTo: targetSection,
			duration: duration * factor,
			ease: 'power1.inOut'
		});
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
		window.addEventListener('wheel', handleWheel, { passive: false });
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
		window.removeEventListener('wheel', handleWheel);

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

	// HANDLERS
	function handleWheel(e) {
		// prevent the default scrolling
		e.preventDefault();

		// if we are currently scrolling, exit the function (no overlap)
		if (isScrolling) return;
		// lock the scrolling boolean (prevent overlap)
		updateScroll(true);

		// if the change in Y is positive and we are not at the last section, update the section store,
		// and scroll to the section
		if (e.deltaY > 0 && currentSection < sections.length - 1) {
			updateSection(currentSection + 1);
			scrollToSection(currentSection, 1);
		}
		// if the change in Y is negative and we are not at the first section, update the section store,
		// and scroll to the section
		else if (e.deltaY < 0 && currentSection > 0) {
			updateSection(currentSection - 1);
			scrollToSection(currentSection, 1);
		}
		// otherwise we cannot scroll more (up or down), so unlock the scroll boolean and exit
		else {
			updateScroll(false);
			return;
		}

		// set a timeout, so that the animation has time before we unlock the scroll boolean
		setTimeout(() => {
			updateScroll(false);
		}, timeoutDuration);
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
	<Header {scrollToSection} {timeoutDuration} className="z-20 fixed top-0 left-0 right-0" />
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
