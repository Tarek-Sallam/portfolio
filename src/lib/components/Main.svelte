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
	import { fade } from 'svelte/transition';
	import { gsap } from 'gsap';
	import ScrollToPlugin from 'gsap/ScrollToPlugin';

	/* IMPORT STORES */
	import { darkModeStore, sectionInfoStore, loading } from '$lib/store.js';

	// DEFAULT CLASSES FOR THE COMPONENTS
	const defaultClass = 'z-10';

	// CONSTANTS
	const animDuration = 0.75;

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
	function getElementTotalHeight(element) {
		if (!element) return 0;

		// Get the bounding box of the element (includes padding and border)
		const rect = element.getBoundingClientRect();
		const computedStyle = window.getComputedStyle(element);

		// Get the vertical margins
		const marginTop = parseFloat(computedStyle.marginTop) || 0;
		const marginBottom = parseFloat(computedStyle.marginBottom) || 0;

		// Calculate total height
		const totalHeight = rect.height + marginTop + marginBottom;
		return totalHeight;
	}

	function getSectionInfo() {
		const sections = document.querySelectorAll('section');
		let sectionInfo = [];
		sections.forEach((section) => {
			const height = getElementTotalHeight(section);
			sectionInfo.push({
				id: `#${section.id}`,
				height: height
			});
		});

		return sectionInfo;
	}
	async function preloadImages() {
		return new Promise((resolve, reject) => {
			const imagesToPreload = [
				'./github_w.svg',
				'./github.svg',
				'./mail_w.svg',
				'./mail.svg',
				'./linkedin_w.svg',
				'./linkedin.svg',
				'./resume_w.svg',
				'./resume.svg',
				'./logo.svg',
				'./logo_w.svg'
			];

			const imageLoadPromises = imagesToPreload.map((src) => {
				return new Promise((resolve, reject) => {
					const img = new Image();
					img.src = src;
					img.onload = resolve;
					img.onerror = reject;
				});
			});

			// Wait for both images to load before setting loading to false
			Promise.all(imageLoadPromises)
				.then(() => resolve())
				.catch((err) => reject(err));
		});
	}

	// CONSTRUCTION, INIT, DESTROY
	async function construct() {
		// REGISTER GSAP PLUGINS
		gsap.registerPlugin(ScrollToPlugin);
		await preloadImages();
		await document.fonts.ready;
		window.addEventListener('resize', handleResize);
	}
	async function init() {
		matchTheme(); // match light or dark theme
		updateSectionInfoStore(getSectionInfo()); // update section info
	}

	function destroy() {
		window.removeEventListener('resize', handleResize);
	}

	// ON MOUNT (CLIENT SIDE)
	onMount(() => {
		construct()
			.then(() => init())
			.then(() => {
				loading.set($loading - 1);
			});
		onDestroy(() => {
			destroy(); // destroy
		});
	});

	function handleResize() {
		updateSectionInfoStore(getSectionInfo());
	}
</script>

<Header {animDuration} className="z-20 fixed top-0 left-0 right-0 " />
<main
	class="relative flex min-h-screen flex-col overflow-x-hidden overscroll-none bg-white dark:bg-black"
>
	{#if $loading > 0}
		<div
			class="w-100 h-100 fixed left-0 top-0 z-30 flex h-screen w-screen items-center justify-center bg-black"
			transition:fade={{ duration: 1500 }}
		>
			<p class="text-center font-mono text-2xl font-bold text-white">Loading...</p>
		</div>
	{/if}
	<Three {animDuration} className="z-0 fixed top-0 left-0 right-0 w-full " />
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
