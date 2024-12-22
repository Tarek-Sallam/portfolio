<script lang="ts">
	import { onMount } from 'svelte';
	import * as THREE from 'three';

	// Use a different name instead of "class" to avoid conflict with the reserved keyword
	export let canvasClass: string = ''; // Accept canvasClass as a prop
	let canvas: HTMLCanvasElement;

	onMount(() => {
		const scene = new THREE.Scene();
		const camera = new THREE.PerspectiveCamera(
			75,
			window.innerWidth / window.innerHeight,
			0.1,
			1000
		);
		const renderer = new THREE.WebGLRenderer({ canvas });

		// Set the canvas to the full size of the window
		renderer.setSize(window.innerWidth, window.innerHeight);
		document.body.appendChild(renderer.domElement);

		// Create a basic cube for demonstration purposes
		const geometry = new THREE.BoxGeometry();
		const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
		const cube = new THREE.Mesh(geometry, material);
		scene.add(cube);

		camera.position.z = 5;

		// Animation loop
		function animate() {
			requestAnimationFrame(animate);

			cube.rotation.x += 0.01;
			cube.rotation.y += 0.01;

			renderer.render(scene, camera);
		}

		animate();

		// Adjust the canvas size when the window is resized
		window.addEventListener('resize', () => {
			camera.aspect = window.innerWidth / window.innerHeight;
			camera.updateProjectionMatrix();
			renderer.setSize(window.innerWidth, window.innerHeight);
		});
	});
</script>

<canvas bind:this={canvas} class={canvasClass}></canvas>

<!-- Use canvasClass prop -->

<style>
	canvas {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		display: block;
		z-index: -1; /* Ensure the canvas is behind everything else */
	}
</style>
