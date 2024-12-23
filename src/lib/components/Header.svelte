<script>
	export let className = '';
	export let logoSrc = './logoWhite.svg';

	import { gsap } from 'gsap';
	import { ScrollToPlugin } from 'gsap/ScrollToPlugin';
	import { onMount } from 'svelte';
	let scrollToSection;
	onMount(() => {
		gsap.registerPlugin(ScrollToPlugin);
		scrollToSection = (id, e) => {
			e.preventDefault();
			const element = document.getElementById(id);
			if (element) {
				gsap.to(window, {
					scrollTo: {
						y: element,
						offsetY: 50
					},
					duration: 1,
					ease: 'power2.out'
				});
			}
		};
	});
</script>

<div class={className}>
	<header class="px-4 py-4 text-lg text-white">
		<div class="mx-auto flex w-full justify-between px-8 py-3">
			<div class="h-auto w-12">
				<a href="#hero" on:click={(e) => scrollToSection('hero', e)}>
					<img src={logoSrc} alt="Logo" />
				</a>
			</div>

			<nav>
				<ol class="flex items-center justify-between space-x-10">
					<li><a href="#projects" on:click={(e) => scrollToSection('projects', e)}>Projects</a></li>
					<li><a href="#about-me" on:click={(e) => scrollToSection('about-me', e)}>About</a></li>
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
