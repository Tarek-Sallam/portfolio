<script>
	import * as THREE from 'three';
	import vertexShader from './shaders/vertex.glsl';
	import fragmentShader from './shaders/fragment.glsl';
	import { onMount } from 'svelte';

	let canvas;

	onMount(() => {
		// Set up the Three.js scene
		const scene = new THREE.Scene();
		const camera = new THREE.PerspectiveCamera(
			75,
			window.innerWidth / window.innerHeight,
			0.1,
			1000
		);

		const renderer = new THREE.WebGLRenderer({ canvas });
		renderer.setSize(window.innerWidth, window.innerHeight);

		// Create the material using custom shaders
		const material = new THREE.ShaderMaterial({
			vertexShader,
			fragmentShader
		});

		// Create a plane geometry and apply the shader material
		const geometry = new THREE.PlaneGeometry(5, 5);
		const plane = new THREE.Mesh(geometry, material);
		scene.add(plane);

		camera.position.z = 5;

		// Animation loop
		function animate() {
			requestAnimationFrame(animate);
			plane.rotation.x += 0.01;
			plane.rotation.y += 0.01;
			renderer.render(scene, camera);
		}

		animate();

		// Handle window resizing
		window.addEventListener('resize', () => {
			camera.aspect = window.innerWidth / window.innerHeight;
			camera.updateProjectionMatrix();
			renderer.setSize(window.innerWidth, window.innerHeight);
		});
	});
</script>

<canvas bind:this={canvas}></canvas>

<style>
	canvas {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		display: block;
		z-index: -1; /* Ensure the canvas is behind other content */
	}
</style>
