<script>
	import * as THREE from 'three';
	import { onMount } from 'svelte';
	import fragmentShader from './shaders/fragment.glsl';
	import vertexShader from './shaders/vertex.glsl';
	import { max, vertexColor } from 'three/tsl';
	let canvas;

	onMount(() => {
		let scene, camera, renderer;
		let particlePositions, linePositions, lineColors, lines, particles;
		let particleData = [];

		const numParticles = 200;
		const xLength = 500;
		const yLength = 500;
		const zLength = 0;
		const maxDistance = 110;
		const speed = 0.5;

		function init() {
			// INIT CAMERA
			camera = new THREE.PerspectiveCamera(45, canvas.clientWidth / canvas.clientHeight, 1, 4000);
			camera.position.z = 700;
			camera.lookAt(0, 0, 0);
			// INIT SCENE
			scene = new THREE.Scene();

			// INIT RENDERER
			renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
			renderer.setSize(canvas.clientWidth, canvas.clientHeight);
			renderer.setAnimationLoop(animate);

			// GET THE POSITIONS OF THE PARTICLES
			// LOOP THROUGH EACH INSTANCE OF THE ARRAY AND GENERATE
			// RANDOM POSITION
			particlePositions = new Float32Array(numParticles * 3);
			for (let i = 0; i < numParticles; i++) {
				const x = Math.random() * xLength - xLength / 2;
				const y = Math.random() * yLength - yLength / 2;
				const z = Math.random() * zLength - zLength / 2;

				particlePositions[i * 3] = x;
				particlePositions[i * 3 + 1] = y;
				particlePositions[i * 3 + 2] = z;

				particleData.push({
					velocity: new THREE.Vector3(
						-1 + Math.random() * 2,
						-1 + Math.random() * 2,
						-1 + Math.random() * 2
					)
				});
			}

			// CREATE THE BUFFER GEOMETRY FOR THE PARTICLES
			let particlesBuffer = new THREE.BufferGeometry();
			particlesBuffer.setAttribute(
				'position',
				new THREE.BufferAttribute(particlePositions, 3).setUsage(THREE.DynamicDrawUsage)
			);

			// CREATE THE MATERIAL FOR THE PARTICLES
			let particlesMaterial = new THREE.PointsMaterial({ color: 0xffffff, size: 5 });

			// CREATE THE PARTICLES
			particles = new THREE.Points(particlesBuffer, particlesMaterial);

			// CREATE THE LINE POSITION AND COLORS ARRAYS
			linePositions = new Float32Array(numParticles * numParticles * 3);
			lineColors = new Float32Array(numParticles * numParticles * 3);

			// CREATE THE LINE BUFFER GEOMETRY
			let linesBuffer = new THREE.BufferGeometry();

			// SET THE LINE POSITIONS AND LINE COLORS
			linesBuffer.setAttribute(
				'position',
				new THREE.BufferAttribute(linePositions, 3).setUsage(THREE.DynamicDrawUsage)
			);

			linesBuffer.setAttribute(
				'color',
				new THREE.BufferAttribute(lineColors, 3).setUsage(THREE.DynamicDrawUsage)
			);

			// SET THE LINES MATERIAL
			let linesMaterial = new THREE.LineBasicMaterial({
				vertexColors: true,
				blending: THREE.AdditiveBlending,
				transparent: true
			});

			// CREATE THE LINES MESH
			lines = new THREE.LineSegments(linesBuffer, linesMaterial);

			scene.add(particles);
			scene.add(lines);
		}

		function animate() {
			let vertexPos = 0;
			let colorPos = 0;
			let connected = 0;
			for (let i = 0; i < numParticles; i++) {
				const data = particleData[i];
				particlePositions[i * 3] += data.velocity.x * speed;
				particlePositions[i * 3 + 1] += data.velocity.y * speed;
				particlePositions[i * 3 + 2] += data.velocity.z * speed;

				if (
					particlePositions[i * 3] < (-1 * xLength) / 2 ||
					particlePositions[i * 3] > xLength / 2
				) {
					data.velocity.x = -data.velocity.x;
				}
				if (
					particlePositions[i * 3 + 1] < (-1 * yLength) / 2 ||
					particlePositions[i * 3 + 1] > yLength / 2
				) {
					data.velocity.y = -data.velocity.y;
				}
				if (
					particlePositions[i * 3 + 2] < (-1 * zLength) / 2 ||
					particlePositions[i * 3 + 2] > zLength / 2
				) {
					data.velocity.z = -data.velocity.z;
				}

				for (let j = i + 1; j < numParticles; j++) {
					const dataB = particleData[j];

					const dx = particlePositions[i * 3] - particlePositions[j * 3];
					const dy = particlePositions[i * 3 + 1] - particlePositions[j * 3 + 1];
					const dz = particlePositions[i * 3 + 2] - particlePositions[j * 3 + 2];

					const dist = Math.sqrt(dx * dx + dy * dy + dz * dz);

					if (dist < maxDistance) {
						const alpha = 1 - dist / maxDistance;
						linePositions[vertexPos++] = particlePositions[i * 3];
						linePositions[vertexPos++] = particlePositions[i * 3 + 1];
						linePositions[vertexPos++] = particlePositions[i * 3 + 2];

						linePositions[vertexPos++] = particlePositions[j * 3];
						linePositions[vertexPos++] = particlePositions[j * 3 + 1];
						linePositions[vertexPos++] = particlePositions[j * 3 + 2];

						lineColors[colorPos++] = alpha;
						lineColors[colorPos++] = alpha;
						lineColors[colorPos++] = alpha;
						lineColors[colorPos++] = alpha;
						lineColors[colorPos++] = alpha;
						lineColors[colorPos++] = alpha;
						connected++;
					}
				}
			}

			lines.geometry.setDrawRange(0, connected * 2);
			lines.geometry.attributes.position.needsUpdate = true;
			lines.geometry.attributes.color.needsUpdate = true;

			particles.geometry.attributes.position.needsUpdate = true;

			render();
		}
		function render() {
			renderer.render(scene, camera);
		}
		init();

		// Handle resize
		window.addEventListener('resize', () => {
			camera.aspect = canvas.clientWidth / canvas.clientHeight;
			camera.updateProjectionMatrix();
			renderer.setSize(canvas.clientWidth, canvas.clientHeight);
		});
	});
</script>

<canvas bind:this={canvas}></canvas>

<style>
	canvas {
		display: block;
		position: absolute;
		width: 100%;
		height: 100%;
	}
</style>
