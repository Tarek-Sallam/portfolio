<script>
	import ProjectCard from './ProjectCard.svelte';

	export let className = '';
</script>

<section id="projects" class={className}>
	<div class="mx-6 mb-12 px-6 pt-24">
		<h2 class="mb-6 font-mono text-3xl font-bold text-black antialiased dark:text-white">
			Top Projects
		</h2>
		<div class="grid grid-cols-1 gap-6">
			<ProjectCard
				title="This Portfolio Website!"
				description="Portfolio full-stack web app to showcase my experience and projects."
				toolsUsed="JavaScript, GLSL, three.js, Svelte, tailwindcss"
				githubLink="https://github.com/Tarek-Sallam/portfolio"
			/>
			<ProjectCard
				title="Fantasy Football Drafter"
				description="A deep RL model trained to pick the best team in a fantasy football draft."
				toolsUsed="Tensorflow, Keras, Python, OpenAI Gym, Pandas, NumPy, MatplotLib"
				githubLink="https://github.com/Tarek-Sallam/DeepRL-Fantasy-Drafter"
			/>
			<ProjectCard
				title="Dynamic Orrery"
				description="NASA Space Apps 2024 Ottawa Winner. Dynamic solar system orrery with near accurate orbits."
				toolsUsed="Python, JavaScript, three.js, numPy"
				githubLink="https://github.com/Tarek-Sallam/Repositorerry"
				demoLink="https://tarek-sallam.github.io/Repositorerry/"
			/>
		</div>
	</div>
</section>
