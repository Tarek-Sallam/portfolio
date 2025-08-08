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
	<div
		class="mx-4 flex min-h-screen flex-col items-center justify-center space-y-4 px-4 text-black dark:text-white sm:mx-6 sm:space-y-6 sm:px-6 xl:mt-4 xl:space-y-8"
	>
		<h1 class="text-center font-zen text-7xl sm:text-8xl lg:text-9xl">TAREK SALLAM</h1>
		<div
			class="flex items-center justify-between space-x-6 sm:space-x-8 lg:space-x-10 xl:space-x-12"
		>
			<a
				href="https://github.com/Tarek-Sallam"
				target="_blank"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={githubIcon} alt="GitHub" class="h-10 w-10 lg:h-14 lg:w-14" />
			</a>
			<a
				href="mailto:tarek.i.sallam@gmail.com"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={mailIcon} alt="Email" class="h-10 w-10 lg:h-14 lg:w-14" />
			</a>
			<a
				href="https://www.linkedin.com/in/tareksallam"
				target="_blank"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={linkedinIcon} alt="LinkedIn" class="h-10 w-10 lg:h-14 lg:w-14" />
			</a>
			<a
				href="/tarek_sallam_resume_no_phone.pdf"
				target="_blank"
				class="text-black transition-transform duration-300 hover:scale-110 dark:text-white"
			>
				<img src={resumeIcon} alt="CV" class="h-10 w-10 lg:h-14 lg:w-14" />
			</a>
		</div>
	</div>
</section>
