<script>
	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';

	/* IMPORT STORES */
	import { sectionStore, scrollStore } from '../store';

	/* PROPS */
	export let className = '';
	export let scrollToSection;
	export let timeoutDuration;

	/* GLOBAL CONSTANTS */
	const logoSrc = './logoWhite.svg';

	/* GLOBAL VARIABLES */
	let scrollTo;
	let isScrolling; // tracks the scroll store
	let currentSection; //  tracks the section store

	let sectionUnsubscribe, scrollUnsubscribe; // for store subscribe cleanup

	// STORE SETTERS
	function updateSection(newSection) {
		sectionStore.set(newSection);
	}
	function updateScroll(newScroll) {
		scrollStore.set(newScroll);
	}

	// STORE SUBSCRIPTIONS
	function onSectionSubscribe(section) {
		currentSection = section;
	}
	function onScrollSubscribe(scroll) {
		isScrolling = scroll;
	}

	// CONSTRUCTION, INIT, DESTRUCTION
	function construct() {
		// HANDLE STORE SUBSCRIPTIONS
		sectionUnsubscribe = sectionStore.subscribe((section) => {
			onSectionSubscribe(section);
		});
		scrollUnsubscribe = scrollStore.subscribe((scroll) => {
			onScrollSubscribe(scroll);
		});

		// REGISTER PLUGINS
		gsap.registerPlugin(ScrollToPlugin);
	}

	function init() {}
	function destroy() {
		// CLEANUP STORES
		if (sectionUnsubscribe) {
			sectionUnsubscribe();
		}
		if (scrollUnsubscribe) {
			scrollUnsubscribe();
		}
	}

	// HANDLERS
	function handleClick(id, e) {
		// prevent default behaviour of clicking a link
		e.preventDefault();

		// if we are already scrolling then exit (prevent overlap)
		if (isScrolling) return;

		// lock the scroll boolean (prevent overlap)
		updateScroll(true);

		// get the index depending on which section fired this event
		const idx = Array.from(document.querySelectorAll('section')).findIndex(
			(section) => section.id === id
		);

		// if we are already in the given section, then unlock the scroll boolean and exit
		if (currentSection === idx) {
			updateScroll(false);
			return;
		}

		// otherwise update the section, and scroll to the seciton
		updateSection(idx);
		scrollToSection(currentSection, 1);

		// set timeout for the animation to run, before unlocking the scroll boolean (prevents overlap)
		setTimeout(() => {
			updateScroll(false);
		}, timeoutDuration);
	}

	onMount(() => {
		construct();
		init();
		onDestroy(() => {
			destroy();
		});
	});
</script>

<div class={className}>
	<header class="px-4 py-4 text-lg text-white">
		<div class="mx-auto flex w-full justify-between px-8 py-3">
			<div class="h-auto w-12">
				<a href="#hero" on:click={(e) => scrollTo('hero', e)}>
					<img src={logoSrc} alt="Logo" />
				</a>
			</div>

			<nav>
				<ol class="flex items-center justify-between space-x-10">
					<li><a href="#projects" on:click={(e) => handleClick('projects', e)}>Projects</a></li>
					<li><a href="#about-me" on:click={(e) => handleClick('about-me', e)}>About</a></li>
				</ol>
			</nav>
		</div>
	</header>
</div>

<style>
	header {
		width: 100%;
	}
</style>
