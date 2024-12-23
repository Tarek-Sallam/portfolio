<script>
	import AboutMe from './AboutMe.svelte';
	import Experience from './Experience.svelte';
	import Header from './Header.svelte';
	import Hero from './Hero.svelte';
	import Projects from './Projects.svelte';
	import Three from './Three.svelte';

	import { onMount } from 'svelte';
	import { gsap } from 'gsap';
	import ScrollToPlugin from 'gsap/ScrollToPlugin';
	import Page from '../../routes/+page.svelte';
	import { TextureLoader } from 'three';

	let defaultClass = 'z-10 container mx-auto min-h-screen flex justify-center items-center';
	let currentSection;
	let isScrolling;
	let scrollToSection;
	const duration = 1.5;
	const timeoutDuration = duration * 1000 + 100;

	onMount(() => {
		gsap.registerPlugin(ScrollToPlugin);

		const sections = document.querySelectorAll('section');

		scrollToSection = (index) => {
			const targetSection = sections[index];
			gsap.to(window, {
				scrollTo: targetSection,
				duration: duration,
				ease: 'power2.inout'
			});
		};

		currentSection = 0;
		isScrolling = true;
		scrollToSection(0);
		setTimeout(() => {
			isScrolling = false;
		}, timeoutDuration);

		window.addEventListener(
			'wheel',
			(e) => {
				e.preventDefault();
				if (isScrolling) return;
				isScrolling = true;
				if (e.deltaY > 0 && currentSection < sections.length - 1) {
					scrollToSection(++currentSection);
				} else if (e.deltaY < 0 && currentSection > 0) {
					scrollToSection(--currentSection);
				} else {
					isScrolling = false;
					return;
				}
				setTimeout(() => {
					isScrolling = false;
				}, timeoutDuration);
			},
			{ passive: false }
		);
	});
</script>

<main class="relative flex min-h-screen flex-col bg-black">
	<Three className="z-0 fixed top-0 left-0 right-0 w-full " />
	<Header
		{isScrolling}
		{currentSection}
		{scrollToSection}
		{timeoutDuration}
		on:update={(e) => {
			currentSection = e.detail.currentSection;
			isScrolling = e.detail.isScrolling;
		}}
		className="z-20 fixed top-0 left-0 right-0"
	/>
	<Hero className={defaultClass} />
	<AboutMe className={defaultClass} />
	<Experience className={defaultClass} />
	<Projects className={defaultClass} />
</main>
