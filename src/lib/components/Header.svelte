<script>
	/* IMPORT ALL COMPONENTS */
	import ToggleButton from './ToggleButton.svelte';

	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import { fly } from 'svelte/transition';
	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';
	import { ScrollTrigger } from 'gsap/ScrollTrigger';
	/* IMPORT STORES */
	import { darkModeStore, sectionInfoStore, scrollStore } from '../store';

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
		if ($scrollStore && $scrollStore.isScroll) return;
		document.body.classList.add('overflow-hidden');
		document.documentElement.classList.add('overflow-hidden');
		scrollStore.set({ isScroll: true, id: id });
		gsap.to(window, {
			duration: animDuration,
			ease: 'power1.inOut',
			scrollTo: id,
			onComplete: () => {
				document.body.classList.remove('overflow-hidden');
				document.documentElement.classList.remove('overflow-hidden');
				scrollStore.set({ isScroll: false, id: $scrollStore.id });
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
	function toggleMobileMenu() {
		isMobileMenuOpen = !isMobileMenuOpen;
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
	<header class="py-6 font-mono text-xl text-black dark:text-white">
		<div class="mx-4 flex items-start justify-between">
			<div class="mx-2 flex h-12 w-12 justify-center">
				<a
					href="#hero"
					class="center-items flex w-10 justify-center"
					on:click={(e) => handleClick('#hero', e)}
				>
					<img src={logoSrc} alt="Logo" />
				</a>
			</div>

			<nav class="flex flex-col items-end gap-2">
				<div class="flex justify-center gap-4">
					<div class="flex h-12 w-12 justify-center">
						<ToggleButton />
					</div>
					<div class="flex h-12 w-12 justify-center">
						<button class="group relative" aria-label="Toggle Menu" on:click={toggleMobileMenu}>
							<div
								class="relative flex h-10 w-10 items-center justify-center overflow-hidden bg-transparent"
							>
								<div
									class="flex h-6 w-6 origin-center transform flex-col justify-between overflow-hidden"
								>
									<div
										class={`h-1 w-6 origin-left transform rounded-full bg-black transition-transform duration-300 ${
											isMobileMenuOpen ? 'translate-y-6' : ''
										} dark:bg-white`}
									></div>
									<div
										class={`h-1 w-6 transform rounded-full bg-black transition-transform delay-75 duration-300 ${
											isMobileMenuOpen ? 'translate-y-6' : ''
										} dark:bg-white`}
									></div>
									<div
										class={`h-1 w-6 origin-left transform rounded-full bg-black transition-transform duration-300 ${
											isMobileMenuOpen ? 'translate-y-6' : ''
										} dark:bg-white`}
									></div>

									<div
										class={`absolute top-3 flex transform items-center justify-between transition-all duration-500 ${
											isMobileMenuOpen ? 'w-12 translate-x-0' : 'w-0 translate-x-10'
										}`}
									>
										<div
											class={`absolute h-1 w-6 transform rounded-full bg-black transition-all delay-300 duration-500 ${
												isMobileMenuOpen ? 'rotate-45' : 'rotate-0'
											} dark:bg-white`}
										></div>
										<div
											class={`absolute h-1 w-6 transform rounded-full bg-black transition-all delay-300 duration-500 ${
												isMobileMenuOpen ? '-rotate-45' : 'rotate-0'
											} dark:bg-white`}
										></div>
									</div>
								</div>
							</div>
						</button>
					</div>
				</div>

				{#if isMobileMenuOpen}
					<div
						class="mx-2 flex flex-col items-end gap-2"
						transition:fly={{ x: 200, duration: 1500 }}
					>
						<ol class="flex flex-col items-end gap-2">
							<li><a href="#about-me" on:click={(e) => handleClick('#about-me', e)}>About</a></li>
							<li>
								<a href="#experience" on:click={(e) => handleClick('#experience', e)}>Experience</a>
							</li>
							<li>
								<a href="#projects" on:click={(e) => handleClick('#projects', e)}>Projects</a>
							</li>
						</ol>
					</div>
				{/if}
			</nav>
		</div>
	</header>
</div>

<style>
	.space-x-10 > *:not(:last-child) {
		margin-right: 2.5rem;
	}
</style>
