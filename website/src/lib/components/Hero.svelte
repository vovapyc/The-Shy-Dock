<script>
	import { onMount } from 'svelte';

	let visible = $state(false);
	onMount(() => {
		visible = true;
	});
</script>

<section class="pt-32 pb-16 px-6 md:pt-48 md:pb-24">
	<div class="max-w-2xl mx-auto text-center">
		<div
			class="transition-all duration-700 ease-out {visible
				? 'opacity-100 translate-y-0'
				: 'opacity-0 translate-y-6'}"
		>
			<h1 class="font-serif text-5xl md:text-7xl leading-[1.05] tracking-tight mb-6">
				Make your dock shy 🙈
			</h1>

			<p class="text-lg text-text-secondary dark:text-text-secondary-dark leading-relaxed max-w-lg mx-auto mb-12">
				A tiny macOS menu bar app that auto-hides your Dock when you're on the laptop alone and brings it back when an external monitor is connected.
			</p>

			<a
				href="https://github.com/vovapyc/The-Shy-Dock/releases/latest"
				target="_blank"
				rel="noopener noreferrer"
				class="inline-flex items-center gap-3 bg-gold text-white font-medium px-10 py-4 rounded-full text-lg transition-all hover:bg-gold-hover hover:scale-[1.02] active:scale-[0.98] shadow-lg shadow-gold/20"
			>
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
				Download for macOS
			</a>
			<p class="mt-4 text-sm text-text-tertiary dark:text-text-tertiary-dark">
				Free &amp; open source · macOS 14.5+
			</p>
		</div>
	</div>
</section>
