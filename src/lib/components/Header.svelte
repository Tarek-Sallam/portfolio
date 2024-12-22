<script>
	export let title = 'My Portfolio';
</script>

<header class="header">
	<div class="container">
		<h1>{title}</h1>
		<nav>
			<ul>
				<li><a href="#about">About</a></li>
				<li><a href="#projects">Projects</a></li>
				<li><a href="#contact">Contact</a></li>
			</ul>
		</nav>
	</div>
</header>

<style>
	.header {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		background-color: rgba(0, 0, 0, 0.8);
		color: white;
		z-index: 10;
		padding: 10px 20px;
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.container {
		display: flex;
		justify-content: space-between;
		width: 100%;
		max-width: 1200px;
		margin: 0 auto;
	}

	nav ul {
		display: flex;
		list-style: none;
		gap: 20px;
	}

	nav ul li a {
		color: white;
		text-decoration: none;
		transition: color 0.2s;
	}

	nav ul li a:hover {
		color: #00d8ff;
	}
</style>
