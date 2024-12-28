<script>
	import { darkModeStore } from '$lib/store';
	export let className = '';
	let githubIcon, mailIcon, linkedinIcon, resumeIcon;
	$: {
		githubIcon = $darkModeStore ? './github_w.svg' : './github.svg';
		mailIcon = $darkModeStore ? './mail_w.svg' : './mail.svg';
		linkedinIcon = $darkModeStore ? './linkedin_w.svg' : './linkedin.svg';
		resumeIcon = $darkModeStore ? './resume_w.svg' : './resume.svg';
	}
</script>

<section id="hero" class={className}>
	<div class="flex min-h-screen flex-col items-center justify-center text-black dark:text-white">
		<h1 class="mb-4 text-center font-zen text-7xl">TAREK SALLAM</h1>
		<div class="flex items-center justify-between space-x-6">
			<a
				href="https://github.com/Tarek-Sallam"
				target="_blank"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={githubIcon} alt="GitHub" class="h-10 w-10" />
			</a>
			<a
				href="mailto:tarek.i.sallam@gmail.com"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={mailIcon} alt="Email" class="h-10 w-10" />
			</a>
			<a
				href="https://www.linkedin.com/in/tareksallam"
				target="_blank"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={linkedinIcon} alt="LinkedIn" class="h-10 w-10" />
			</a>
			<a
				href="./resume.pdf"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={resumeIcon} alt="CV" class="h-10 w-10" />
			</a>
		</div>
	</div>
</section>
