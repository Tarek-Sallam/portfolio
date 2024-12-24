<script>
	export let className = '';

	import * as THREE from 'three';
	import { onMount } from 'svelte';
	import fragmentShader from './shaders/fragment.glsl';
	import vertexShader from './shaders/vertex.glsl';
	import { cameraFar, deltaTime, max, vertexColor } from 'three/tsl';
	let canvas;

	onMount(() => {
		let scene, camera, renderer;
		let particlePositions, linePositions, lineColors, lines, particles;
		let particleData = [];
		let boundData = [];
		const numParticles = 100;
		const xLength = 4000;
		const yLength = 0;
		const zLength = 4000;
		const maxDistance = 700;
		const awaySpeed = 0.5;
		const speed = 5;
		const boundX = 50;
		const boundZ = 50;
		const intersectRadius = 300;
		const maxHeight = 150;
		const raycaster = new THREE.Raycaster();
		const pointer = new THREE.Vector2();

		function onPointerMove(event) {
			pointer.x = (event.clientX / window.innerWidth) * 2 - 1;
			pointer.y = -(event.clientY / window.innerHeight) * 2 + 1;
		}
		function calculateXZIntersect(ray) {
			const origin = ray.origin;
			const direction = ray.direction;

			if (direction.y === 0) {
				return origin;
			}

			const t = -origin.y / direction.y;

			if (t < 0) return null;

			const intersection = new THREE.Vector3();
			intersection.copy(direction).multiplyScalar(t).add(origin);
			return intersection;
		}
		function init() {
			// INIT CAMERA
			//camera = new THREE.PerspectiveCamera(45, canvas.clientWidth / canvas.clientHeight, 1, 4000);
			camera = new THREE.OrthographicCamera(
				canvas.clientWidth / -2,
				canvas.clientWidth / 2,
				canvas.clientHeight / 2,
				canvas.clientHeight / -2,
				0,
				4000
			);
			camera.position.x = 2000;
			camera.position.z = 0;
			camera.position.y = 700;
			camera.lookAt(0, 0, 0);
			// INIT SCENE
			scene = new THREE.Scene();

			// INIT RENDERER
			renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
			renderer.setSize(canvas.clientWidth, canvas.clientHeight);
			renderer.setPixelRatio(window.devicePixelRatio);
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
				boundData[i * 3] = x;
				boundData[i * 3 + 1] = y;
				boundData[i * 3 + 2] = z;

				particleData.push({
					velocity: new THREE.Vector3(-1 + Math.random() * 2, 0, -1 + Math.random() * 2)
				});
			}

			// CREATE THE BUFFER GEOMETRY FOR THE PARTICLES
			let particlesBuffer = new THREE.BufferGeometry();
			particlesBuffer.setAttribute(
				'position',
				new THREE.BufferAttribute(particlePositions, 3).setUsage(THREE.DynamicDrawUsage)
			);

			// CREATE THE MATERIAL FOR THE PARTICLES
			let particlesMaterial = new THREE.ShaderMaterial({
				uniforms: {
					uColor: { value: new THREE.Color(0xffffff) },
					uSize: { value: 8.0 }
				},
				vertexShader: vertexShader,
				fragmentShader: fragmentShader,
				transparent: true,
				blending: THREE.AdditiveBlending
			});

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
		function updatePoint(deltaTime, i, intersect) {
			let dist = 0;
			if (intersect) {
				const away = new THREE.Vector3(
					particlePositions[i * 3] - intersect.x,
					particlePositions[i * 3 + 1] - intersect.y,
					particlePositions[i * 3 + 2] - intersect.z
				);
				dist = Math.sqrt(away.x * away.x + away.z * away.z);
			} else {
				dist = intersectRadius + 1;
			}
			if (dist <= intersectRadius) {
				const falloff = Math.exp(
					(-dist * dist) / (2 * (intersectRadius * 0.5) * (intersectRadius * 0.5))
				);
				const targetHeight = maxHeight * falloff;
				particlePositions[i * 3 + 1] +=
					(targetHeight - particlePositions[i * 3 + 1]) * awaySpeed * deltaTime;
			} else {
				const targetHeight = boundData[i * 3 + 1];
				particlePositions[i * 3 + 1] +=
					(targetHeight - particlePositions[i * 3 + 1]) * awaySpeed * deltaTime;
			}
			particlePositions[i * 3] += particleData[i].velocity.x * speed * deltaTime;
			particlePositions[i * 3 + 2] += particleData[i].velocity.z * speed * deltaTime;

			if (
				particlePositions[i * 3] >= boundData[i * 3] + boundX / 2 ||
				particlePositions[i * 3] <= boundData[i * 3] - boundX / 2
			) {
				particleData[i].velocity.x *= -1;
			}
			if (
				particlePositions[i * 3 + 2] >= boundData[i * 3 + 2] + boundZ / 2 ||
				particlePositions[i * 3 + 2] <= boundData[i * 3 + 2] - boundZ / 2
			) {
				particleData[i].velocity.z *= -1;
			}
		}
		function animate() {
			const deltaTime = 1 / 60;
			raycaster.setFromCamera(pointer, camera);
			const intersect = calculateXZIntersect(raycaster.ray);
			let vertexPos = 0;
			let colorPos = 0;
			let connected = 0;
			for (let i = 0; i < numParticles; i++) {
				updatePoint(deltaTime, i, intersect);
				// draw all the lines
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
			canvas.width = window.innerWidth;
			canvas.height = window.innerHeight;
			camera.aspect = window.innerWidth / window.innerHeight;
			camera.updateProjectionMatrix();
			renderer.setSize(window.innerWidth, window.innerHeight);
		});

		window.addEventListener('pointermove', onPointerMove);
	});
</script>

<div class={className}>
	<canvas class="h-screen w-screen" bind:this={canvas}></canvas>
</div>
