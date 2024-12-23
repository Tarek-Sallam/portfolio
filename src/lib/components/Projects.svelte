<script>
	export let className = '';
</script>

<section id="projects" class={className}>
	<div class="container mx-auto px-6 py-12">
		<h2 class="mb-8 text-center text-4xl font-bold">Projects</h2>
		<div class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
			<!-- Project 1 -->
			<div class="rounded-lg bg-gray-100 p-6 shadow-md">
				<h3 class="text-2xl font-semibold">Project 1: Awesome Web App</h3>
				<p class="mt-2 text-gray-700">
					A web application built with React and Node.js that helps users manage tasks.
				</p>
				<div class="mt-4 flex space-x-4">
					<a
						href="https://github.com/yourusername/project1"
						target="_blank"
						class="text-blue-500 hover:underline">GitHub</a
					>
					<a href="https://project1.com" target="_blank" class="text-blue-500 hover:underline"
						>Live Demo</a
					>
				</div>
			</div>
			<!-- Project 2 -->
			<div class="rounded-lg bg-gray-100 p-6 shadow-md">
				<h3 class="text-2xl font-semibold">Project 2: AI Model</h3>
				<p class="mt-2 text-gray-700">
					A machine learning model for predicting stock prices based on historical data.
				</p>
				<div class="mt-4 flex space-x-4">
					<a
						href="https://github.com/yourusername/project2"
						target="_blank"
						class="text-blue-500 hover:underline">GitHub</a
					>
					<a href="https://project2.com" target="_blank" class="text-blue-500 hover:underline"
						>Live Demo</a
					>
				</div>
			</div>
			<!-- Project 3 -->
			<div class="rounded-lg bg-gray-100 p-6 shadow-md">
				<h3 class="text-2xl font-semibold">Project 3: Portfolio Website</h3>
				<p class="mt-2 text-gray-700">
					A personal portfolio website built with Svelte, showcasing my projects and experiences.
				</p>
				<div class="mt-4 flex space-x-4">
					<a
						href="https://github.com/yourusername/project3"
						target="_blank"
						class="text-blue-500 hover:underline">GitHub</a
					>
					<a href="https://yourportfolio.com" target="_blank" class="text-blue-500 hover:underline"
						>Live Demo</a
					>
				</div>
			</div>
		</div>
	</div>
</section>
