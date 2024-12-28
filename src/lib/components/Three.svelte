<script>
	/* IMPORT ALL LIBRARIES */
	import { onMount, onDestroy } from 'svelte';
	import * as THREE from 'three';
	import { gsap } from 'gsap';
	import { ScrollTrigger } from 'gsap/ScrollTrigger';

	/* STORE IMPORTS */
	import { darkModeStore, scrollStore, sectionInfoStore } from '$lib/store';

	/* SHADER IMPORTS */
	import fragmentShader from '$lib/components/shaders/fragment.glsl';
	import vertexShader from '$lib/components/shaders/vertex.glsl';
	/* PROPS */
	export let className = '';
	export let animDuration;

	// GLOBAL CONSTANTS
	const numParticles = 150; // number of particles in three scene
	let xLength = 2; // spanning of the particles in the x-direction (forward-back)
	let yLength = 0; // spanning of the particles in the y-direction (up-down)
	let zLength = 2; // spanning of the particles in the z-direction (left-right)
	let maxDistance = 0.3; // the maximum distance for a line to be drawn between two particles
	let awaySpeed = 0.0003; // the speed that the particles move away the mouse
	let speed = 0.003; // the speed of the particles moving generally
	let boundX = 0.1; // the bound size for the particle movement in the x-direction (forward-back)
	let boundZ = 0.1; // the bound size for the particle movement in the z-direction (left-right)
	let intersectRadius = 0.15; // the radius of which the mouse causes the particles to move up
	let maxHeight = 0.05; // the maximum height for a particle to travel up-down when mouse hovering
	let particleSize = 0.003;
	const near = 4;
	const far = 4;

	// the positions of the cameras and the index/position
	let cameraPositions = [
		[2, 0.8, 0],
		[2, 0.5, 0],
		[2 * Math.cos(Math.PI / 8), 0.5, 2 * Math.sin(Math.PI / 8)],
		[2 * Math.cos(Math.PI / 4), 0.7, 2 * Math.sin(Math.PI / 4)]
	];

	// GLOBAL VARIABLES
	let canvas; // to bind to canvas element

	let scene, camera, renderer; // for webgl
	let raycaster, pointer; // for determine where the mouse is pointing

	// positions, textures, and mesh variables for the lines and particles
	let particlePositions, linePositions, lineColors;
	let particlesBuffer, particlesMaterial, linesBuffer, linesMaterial;
	let lines, particles;
	let currentColor = 0xffffff;

	let particleData = []; // the corresponding data for the particles
	let boundData = []; // the data for the particle bounds

	let darkModeUnsubscribe; // for store cleanup

	let timeline;

	function onDarkModeSubscribe(darkMode) {
		if (particlesMaterial && scene) {
			renderer.setClearColor(new THREE.Color(currentColor), 1);
			if (darkMode) {
				currentColor = 0xffffff;
				particlesMaterial.blending = THREE.NormalBlending;
				linesMaterial.blending = THREE.NormalBlending;
			} else {
				currentColor = 0x000000;
				linesMaterial.blending = THREE.NormalBlending;
				particlesMaterial.blending = THREE.NormalBlending;
			}
			particlesMaterial.uniforms.uColor.value = new THREE.Color(currentColor);
		}
	}

	$: if (camera && $sectionInfoStore && $scrollStore && $scrollStore.isScroll) {
		timeline.kill();
		const idx = $sectionInfoStore.findIndex((section) => section.id === $scrollStore.id);
		scrollTo(idx);
	}

	$: if (camera && $sectionInfoStore && $scrollStore && !$scrollStore.isScroll) {
		updateGsapTimeline($sectionInfoStore);
	}

	// GENERAL PURPOSE FUNCTIONS
	function calculateXZIntersect(ray) {
		const origin = ray.origin; // get the origin of the ray
		const direction = ray.direction; // get the direction of the ray

		// if direction in y-direction is 0, then we are parallel to the y-axis so return the origin
		if (direction.y === 0) {
			return origin;
		}

		// how far along the ray until we hit the x-z plane
		const t = -origin.y / direction.y;

		// if t is in the other direction, return null since we point the ray only forward
		if (t < 0) return null;

		// return the intersection of the ray's direction * t + the origin
		const intersection = new THREE.Vector3();
		intersection.copy(direction).multiplyScalar(t).add(origin);
		return intersection;
	}
	// updates the position of a point, given the time, index, and intersection of mouse with x-z plane
	function updatePoint(deltaTime, i, intersect) {
		let dist = 0; // distance between intersection and point
		// if the intersection is not null
		if (intersect) {
			// get the 'away' vector which is the vector that points from intersect to current point
			const away = new THREE.Vector3(
				particlePositions[i * 3] - intersect.x,
				particlePositions[i * 3 + 1] - intersect.y,
				particlePositions[i * 3 + 2] - intersect.z
			);

			// calculate the distance between intersection and point (euclidean)
			dist = Math.sqrt(away.x * away.x + away.z * away.z);
		} else {
			// if the intersection is null, treat the distance as larger than the maximum radius
			dist = intersectRadius + 1;
		}

		// if the distance is within the maximum radius
		if (dist <= intersectRadius) {
			// calculate the falloff of the point
			const falloff = Math.exp(
				(-dist * dist) / (2 * (intersectRadius * 0.5) * (intersectRadius * 0.5))
			);

			// calculate the target height of the point given the falloff and maxheight
			const targetHeight = maxHeight * falloff;

			// increase the height of the point by a marginal amount towards the targetHeight
			particlePositions[i * 3 + 1] +=
				(targetHeight - particlePositions[i * 3 + 1]) * awaySpeed * deltaTime;
		} else {
			// otherwise set the target height to the original height of the point
			const targetHeight = boundData[i * 3 + 1];

			// decrease the height (or dont change bc its already there) of the point towards the target height
			particlePositions[i * 3 + 1] +=
				(targetHeight - particlePositions[i * 3 + 1]) * awaySpeed * deltaTime;
		}

		// move the point in the x and z directions by their respective velocities
		particlePositions[i * 3] += particleData[i].velocity.x * speed * deltaTime;
		particlePositions[i * 3 + 2] += particleData[i].velocity.z * speed * deltaTime;

		// if the particles have gone outside of the x bounds, or z bounds, then reverse the velocity to bring it back
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
	// draws a line between points if they are close enough
	function drawLine(i, j, vertexPos, colorPos, connected) {
		const dataB = particleData[j]; // get the data of the b particle
		const dx = particlePositions[i * 3] - particlePositions[j * 3]; // distance x
		const dy = particlePositions[i * 3 + 1] - particlePositions[j * 3 + 1]; // distance y
		const dz = particlePositions[i * 3 + 2] - particlePositions[j * 3 + 2]; // distance z

		// euclidan distance 3d
		const dist = Math.sqrt(dx * dx + dy * dy + dz * dz);

		// if the distance is small enough
		if (dist < maxDistance) {
			// calculate the alpha level of the line
			const alpha =
				currentColor === 0xffffff
					? (1 - dist / maxDistance) * 0.6
					: Math.max(0, dist / maxDistance - 0.1 * (1 - dist / maxDistance));

			// add the x, y, z of the first point, then add the x, y, z of the second point
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

			// increase the numconnected
			connected++;
		}

		return [vertexPos, colorPos, connected];
	}
	function updateGsapTimeline(sectionInfo) {
		if (timeline) {
			timeline.kill();
		}
		const totalHeight = sectionInfo.reduce((sum, section) => sum + section.height, 0);

		timeline = gsap.timeline({
			scrollTrigger: {
				trigger: 'body',
				start: 'top top',
				end: 'bottom bottom',
				scrub: true
			}
		});
		sectionInfo.forEach((section, index) => {
			if (index === 0) {
				timeline
					.to(camera.position, {
						x: cameraPositions[0][0],
						y: cameraPositions[0][1],
						z: cameraPositions[0][2],
						onUpdate: () => {
							camera.lookAt(0, 0, 0);
						},
						ease: 'power1.inOut',
						duration: 0
					})
					.add(section.id);
			}
			if (index > 0) {
				const relativeDuration = sectionInfo[index - 1].height / totalHeight;
				timeline
					.to(camera.position, {
						x: cameraPositions[index][0],
						y: cameraPositions[index][1],
						z: cameraPositions[index][2],
						onUpdate: () => {
							camera.lookAt(0, 0, 0);
						},
						ease: 'power1.inOut',
						duration: relativeDuration
					})
					.add(section.id);
			}
		});
	}
	function scrollTo(position) {
		gsap.to(camera.position, {
			x: cameraPositions[position][0],
			y: cameraPositions[position][1],
			z: cameraPositions[position][2],
			duration: animDuration,
			ease: 'power1.inOut',
			onUpdate: () => {
				camera.lookAt(0, 0, 0);
			}
		});
	}

	// ANIMATION RENDER LOOP
	function animate() {
		// get the delta time (second per frame)
		const deltaTime = 1 / 60;

		// set the raycaster to be from the camera (pointer coords)
		raycaster.setFromCamera(pointer, camera);

		// calculate the intersection of the x-z plane with the ray
		const intersect = calculateXZIntersect(raycaster.ray);

		// variables for loop (num connected, index of vertex, index of color)
		let vertexPos = 0;
		let colorPos = 0;
		let connected = 0;

		// loop through each particle
		for (let i = 0; i < numParticles; i++) {
			// update the particle point
			updatePoint(deltaTime, i, intersect);

			// loop through the rest of the particles
			for (let j = i + 1; j < numParticles; j++) {
				// draw a line between the particles (if close), and update values
				[vertexPos, colorPos, connected] = drawLine(i, j, vertexPos, colorPos, connected);
			}
		}

		// update the line geometry and particle geometry
		lines.geometry.setDrawRange(0, connected * 2);
		lines.geometry.attributes.position.needsUpdate = true;
		lines.geometry.attributes.color.needsUpdate = true;
		particles.geometry.attributes.position.needsUpdate = true;

		// render
		render();
	}
	function render() {
		// render the scene
		renderer.render(scene, camera);
	}

	// CONSTRUCTION, INIT AND DESTRUCTION
	function construct() {
		gsap.registerPlugin(ScrollTrigger);
		// SET SUBSCRIPTION CALLBACKS

		darkModeUnsubscribe = darkModeStore.subscribe((darkMode) => {
			onDarkModeSubscribe(darkMode);
		});

		resizeCanvas(); // make sure canvas is appropriate size

		const scale = window.outerHeight + window.outerWidth;
		xLength *= scale;
		zLength *= scale;
		maxDistance *= scale;
		awaySpeed *= scale;
		speed *= scale;
		boundX *= scale;
		boundZ *= scale;
		intersectRadius *= scale;
		maxHeight *= scale;
		particleSize *= scale;

		// CREATE MY THREE RAYCASTER AND POINTER
		raycaster = new THREE.Raycaster();
		pointer = new THREE.Vector2();

		// CREATE MY THREE SCENE, RENDERER, CAMERA
		scene = new THREE.Scene();
		renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
		camera = new THREE.OrthographicCamera(
			canvas.width / -2,
			canvas.width / 2,
			canvas.height / 2,
			canvas.height / -2,
			-scale * near,
			scale * far
		);

		// CREATE MY PARTICLE POSITIONS, PARTICLE BUFFER, PARTICLE MATERIAL, AND PARTICLE MESH
		particlePositions = new Float32Array(numParticles * 3);
		particlesBuffer = new THREE.BufferGeometry();
		particlesMaterial = new THREE.ShaderMaterial({
			uniforms: {
				uColor: { value: new THREE.Color(0xffffff) },
				uSize: { value: particleSize }
			},
			vertexShader: vertexShader,
			fragmentShader: fragmentShader,
			transparent: true,
			blending: THREE.NoBlending
		});
		particles = new THREE.Points(particlesBuffer, particlesMaterial);

		// CREATE MY LINES POSITIONS, LINES COLORS, LINES BUFFER, LINES MATERIAL, AND LINES MESH
		linePositions = new Float32Array(numParticles * numParticles * 3);
		lineColors = new Float32Array(numParticles * numParticles * 3);
		linesBuffer = new THREE.BufferGeometry();
		linesMaterial = new THREE.LineBasicMaterial({
			vertexColors: true,
			blending: THREE.NormalBlending,
			transparent: true
		});
		lines = new THREE.LineSegments(linesBuffer, linesMaterial);

		cameraPositions = cameraPositions.map((value) => value.map((coord) => coord * scale));
		// SET THE EVENT LISTENERS
		window.addEventListener('resize', handleResize);
		window.addEventListener('pointermove', handlePointer);
	}

	function init() {
		// SET MY CAMERA POSITION TO POSITION 1, AND LOOK AT 0,0,0
		camera.position.x = cameraPositions[0][0];
		camera.position.y = cameraPositions[0][1];
		camera.position.z = cameraPositions[0][2];
		camera.lookAt(0, 0, 0);

		// SETUP THE RENDERER
		renderer.setSize(canvas.width, canvas.height);
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setAnimationLoop(animate);
		renderer.setClearColor(new THREE.Color(0x000000), 1);

		// LOOP THROUGH MY PARTICLES AND SET THEIR POSITIONS AND VELOCITIES
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

		// SET THE PARTICLES BUFFER TO DRAW BASED ON PARTICLE POSITIONS
		particlesBuffer.setAttribute(
			'position',
			new THREE.BufferAttribute(particlePositions, 3).setUsage(THREE.DynamicDrawUsage)
		);

		// SET THE LINES BUFFER TO DRAW BASED ON LINE POSITIONS
		linesBuffer.setAttribute(
			'position',
			new THREE.BufferAttribute(linePositions, 3).setUsage(THREE.DynamicDrawUsage)
		);

		// SET THE LINES BUFFER TO DRAW COLOR BASED ON THE LINE COLORS ARRAY
		linesBuffer.setAttribute(
			'color',
			new THREE.BufferAttribute(lineColors, 3).setUsage(THREE.DynamicDrawUsage)
		);

		// ADD MY PARTICLES AND LINES TO THE SCENE
		scene.add(particles);
		scene.add(lines);
	}

	function destroy() {
		// KILL RENDERER AND SCENE FOR THREE
		if (renderer) {
			renderer.setAnimationLoop(null);
			renderer.dispose();
		}
		if (scene) {
			scene.dispose();
		}

		// KILL TWEENS FOR GSAP
		if (timeline) {
			timeline.kill();
		}
		gsap.killTweensOf(camera);

		// REMOVE EVENT LISTENERS
		window.removeEventListener('resize', handleResize);
		window.removeEventListener('pointermove', handlePointer);

		// CLEANUP STORES
		if (darkModeUnsubscribe) {
			darkModeUnsubscribe();
		}
	}

	// HANDLERS
	function handlePointer(event) {
		// find the x and y location of the pointer wrt the screen dims, i.e values between 0 and 1
		pointer.x = (event.clientX / window.innerWidth) * 2 - 1;
		pointer.y = -(event.clientY / window.innerHeight) * 2 + 1;
	}
	function handleResize() {
		// recalculate the canvas, and update the camera, renderer
		resizeCanvas();
		camera.aspect = canvas.width / canvas.height;
		camera.left = canvas.width / -2;
		camera.right = canvas.width / 2;
		camera.top = canvas.height / 2;
		camera.bottom = canvas.height / -2;
		camera.updateProjectionMatrix();
		renderer.setSize(canvas.width, canvas.height);
		renderer.setPixelRatio(window.devicePixelRatio);
	}

	function resizeCanvas() {
		canvas.width = window.outerWidth;
		canvas.height = window.outerHeight;
	}
	// ON CSR
	onMount(() => {
		construct();
		init();

		onDestroy(() => {
			destroy();
		});
	});
</script>

<div class={className}>
	<canvas class="h-screen w-screen overflow-hidden" bind:this={canvas}></canvas>
</div>
