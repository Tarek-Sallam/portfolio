<script>
	/* IMPORT ALL COMPONENTS */
	import ToggleButton from './ToggleButton.svelte';

	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';

	/* IMPORT STORES */
	import { darkModeStore } from '../store';

	/* PROPS */
	export let className = '';
	export let scrollToSection;
	export let timeoutDuration;

	/* GLOBAL CONSTANTS */
	let logoSrc;
	$: {
		logoSrc = $darkModeStore ? './logo_w.svg' : './logo.svg';
	}

	/* GLOBAL VARIABLES */
	let scrollTo;
	let isScrolling; // tracks the scroll store
	let currentSection; //  tracks the section store
	let isMobileMenuOpen = false; // for hamburger menu

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
	function toggleMobileMenu(event) {
		if (event.key === 'Enter' || event.key === ' ') {
			isMobileMenuOpen = !isMobileMenuOpen;
		}
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
	<header class="px-0 py-4 font-mono text-xl text-black dark:text-white lg:px-4">
		<div class="mx-auto flex w-full justify-between px-10 py-3">
			<div class="h-auto w-12">
				<a href="#hero" on:click={(e) => handleClick('hero', e)}>
					<img src={logoSrc} alt="Logo" />
				</a>
			</div>
			<nav class="flex items-center justify-between space-x-10">
				<!-- Hamburger Button for small devices -->
				<button
					class="flex h-6 w-6 flex-col items-center justify-between space-y-1 lg:hidden"
					on:click={() => (isMobileMenuOpen = !isMobileMenuOpen)}
					on:keydown={toggleMobileMenu}
					aria-label="Toggle navigation menu"
				>
					<span class="block h-0.5 w-full bg-white"></span>
					<span class="block h-0.5 w-full bg-white"></span>
					<span class="block h-0.5 w-full bg-white"></span>
				</button>

				<!-- Menu items -->
				<ol class={`space-x-10 lg:flex ${isMobileMenuOpen ? 'block' : 'hidden'} lg:block`}>
					<li><a href="#about-me" on:click={(e) => handleClick('about-me', e)}>About</a></li>
					<li>
						<a href="#experience" on:click={(e) => handleClick('experience', e)}>Experience</a>
					</li>
					<li><a href="#projects" on:click={(e) => handleClick('projects', e)}>Projects</a></li>
				</ol>
				<ToggleButton />
			</nav>
		</div>
	</header>
</div>

<style>
	.space-x-10 > *:not(:last-child) {
		margin-right: 2.5rem;
	}
</style>
