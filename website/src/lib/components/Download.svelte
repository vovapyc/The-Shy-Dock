<script lang="ts">
	import { onMount } from 'svelte';

	let sectionEl: HTMLElement;
	let visible = $state(false);

	onMount(() => {
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries[0].isIntersecting) {
					visible = true;
					observer.disconnect();
				}
			},
			{ threshold: 0.1 }
		);
		observer.observe(sectionEl);
		return () => observer.disconnect();
	});
</script>

<section bind:this={sectionEl} class="py-24 md:py-40 px-6">
	<div
		class="max-w-2xl mx-auto text-center transition-all duration-700 ease-out {visible
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-6'}"
	>
		<h2 class="font-serif text-4xl md:text-6xl tracking-tight mb-6">
			Ready to simplify your&nbsp;dock?
		</h2>
		<p class="text-lg text-text-secondary dark:text-text-secondary-dark mb-10 max-w-md mx-auto">
			Download The Shy Dock and let your dock take care of itself.
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
			Requires macOS 14.5 or later
		</p>
	</div>
</section>
