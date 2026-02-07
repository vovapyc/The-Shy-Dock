<script>
	import { base } from '$app/paths';
</script>

<nav class="fixed top-0 left-0 right-0 z-50 backdrop-blur-lg bg-cream/80 dark:bg-night/80 border-b border-border dark:border-night-border">
	<div class="max-w-5xl mx-auto px-6 h-14 flex items-center justify-between">
		<a href="{base}/" class="flex items-center gap-2 font-medium text-sm tracking-tight">
			<img src="{base}/app-icon.png" alt="The Shy Dock" class="w-6 h-6" />
			<span>The Shy Dock</span>
		</a>
		<a
			href="https://github.com/vovapyc/The-Shy-Dock/releases/latest"
			target="_blank"
			rel="noopener noreferrer"
			class="inline-flex items-center gap-2 bg-text-primary dark:bg-text-primary-dark text-cream dark:text-night text-sm font-medium px-4 py-2 rounded-full transition-opacity hover:opacity-80"
		>
			Download
			<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
		</a>
	</div>
</nav>
