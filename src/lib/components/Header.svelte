<script>
	/* IMPORT ALL COMPONENTS */
	import ToggleButton from './ToggleButton.svelte';

	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';

	/* IMPORT STORES */
	import { darkModeStore, sectionInfoStore } from '../store';

	/* PROPS */
	export let className = '';
	export let animDuration;

	/* GLOBAL CONSTANTS */
	let logoSrc;
	$: {
		logoSrc = $darkModeStore ? './logo_w.svg' : './logo.svg';
	}

	/* GLOBAL VARIABLES */
	let isMobileMenuOpen = false; // for hamburger menu

	// GENERIC FUNCTIONS
	function scrollTo(id) {
		document.body.classList.add('overflow-hidden');
		document.documentElement.classList.add('overflow-hidden');
		gsap.to(window, {
			duration: 1,
			ease: 'power1.inOut',
			scrollTo: id,
			onComplete: () => {
				document.body.classList.remove('overflow-hidden');
				document.documentElement.classList.remove('overflow-hidden');
			}
		});
	}

	// CONSTRUCTION, INIT, DESTRUCTION
	function construct() {
		// REGISTER PLUGINS
		gsap.registerPlugin(ScrollToPlugin);
	}

	function init() {}
	function destroy() {
		gsap.killTweensOf(window);
	}

	// HANDLERS
	function handleClick(id, e) {
		e.preventDefault();
		scrollTo(id);
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
				<a href="#hero" on:click={(e) => handleClick('#hero', e)}>
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
					<li><a href="#about-me" on:click={(e) => handleClick('#about-me', e)}>About</a></li>
					<li>
						<a href="#experience" on:click={(e) => handleClick('#experience', e)}>Experience</a>
					</li>
					<li><a href="#projects" on:click={(e) => handleClick('#projects', e)}>Projects</a></li>
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
