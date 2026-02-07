<script>
	import '../app.css';
	let { children } = $props();
</script>

<svelte:head>
	<title>The Shy Dock — Smart Dock Management for macOS</title>
	<meta
		name="description"
		content="Automatically manages your macOS Dock based on external monitor connections. Plug in a display, your dock appears. Unplug, it hides. Free and open source."
	/>
	<meta property="og:title" content="The Shy Dock — Smart Dock Management for macOS" />
	<meta
		property="og:description"
		content="Automatically manages your macOS Dock based on external monitor connections. Free and open source."
	/>
	<meta property="og:type" content="website" />
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content="The Shy Dock" />
	<meta
		name="twitter:description"
		content="Your dock, only when you need it. Smart Dock management for macOS."
	/>
</svelte:head>

{@render children()}
