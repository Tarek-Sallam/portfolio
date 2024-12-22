// tailwind.config.js
module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts}'],  // Add the content property to tell Tailwind where to look for classes
	theme: {
		extend: {
			fontFamily: {
				sans: ['Inter', 'sans-serif'], // Add the Inter font to the font family
			},
			screens: {
				sm: '640px',
				md: '768px',
				lg: '1024px',
				xl: '1280px',
				'2xl': '1536px',
			},
			colors: {
				transparent: 'transparent',
				black: '#000',
				white: '#fff',
			},
		},
	},
	plugins: [],
};
