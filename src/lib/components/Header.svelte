<script>
	export let className = '';
	export let logoSrc = './logoWhite.svg';
	export let isScrolling;
	export let currentSection;
	export let scrollToSection;
	export let timeoutDuration;

	let scrollTo;
	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';
	import { onMount, createEventDispatcher } from 'svelte';
	import Page from '../../routes/+page.svelte';

	const dispatch = createEventDispatcher();

	function updateProps(section, isScroll) {
		currentSection = section;
		isScrolling = isScroll;
		dispatch('update', { currentSection, isScrolling });
	}

	onMount(() => {
		gsap.registerPlugin(ScrollToPlugin);

		scrollTo = (id, e) => {
			e.preventDefault();
			if (isScrolling) return;
			updateProps(currentSection, true);
			const idx = Array.from(document.querySelectorAll('section')).findIndex(
				(section) => section.id === id
			);
			if (currentSection === idx) {
				updateProps(currentSection, false);
				return;
			}
			updateProps(idx, true);
			scrollToSection(currentSection);
			setTimeout(() => {
				updateProps(currentSection, false);
			}, timeoutDuration);
		};
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
					<li><a href="#projects" on:click={(e) => scrollTo('projects', e)}>Projects</a></li>
					<li><a href="#about-me" on:click={(e) => scrollTo('about-me', e)}>About</a></li>
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
