<script>
	import ProjectCard from './ProjectCard.svelte';

	export let className = '';
</script>

<section id="projects" class={className}>
	<div class="flex justify-center">
		<div
			class="mx-6 mb-12 flex min-h-screen flex-col justify-center space-y-4 px-6 pt-24 sm:mx-8 sm:mb-16 sm:space-y-6 sm:px-8 sm:pt-32 lg:mx-10 lg:mb-0 lg:space-y-8 lg:px-10 lg:pt-0 xl:mx-12 xl:mb-20 xl:w-3/4 xl:items-center xl:px-10 xl:pt-36"
		>
			<h2 class="font-mono text-3xl font-bold text-black antialiased dark:text-white sm:text-5xl">
				Top Projects
			</h2>
			<div
				class="grid grid-cols-1 gap-4 sm:gap-6 lg:grid-cols-2 lg:gap-8 xl:gap-10 2xl:grid-cols-3 2xl:gap-12"
			>
				<ProjectCard
					title="This Portfolio Website!"
					description="Full-stack web app to showcase my experience and projects."
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
					toolsUsed="Python, JavaScript, three.js, NumPy"
					githubLink="https://github.com/Tarek-Sallam/Repositorerry"
					demoLink="https://tarek-sallam.github.io/Repositorerry/"
				/>
			</div>
		</div>
	</div>
</section>
