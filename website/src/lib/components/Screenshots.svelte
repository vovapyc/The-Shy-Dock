<script lang="ts">
	import { base } from '$app/paths';
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

<section bind:this={sectionEl} class="py-16 md:py-28 px-6">
	<div
		class="max-w-3xl mx-auto transition-all duration-700 ease-out {visible
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-6'}"
	>
		<div class="flex items-center gap-8 md:gap-14 max-w-4xl mx-auto">
			<!-- Text on the left -->
			<p class="hidden md:block font-serif text-lg text-text-tertiary leading-relaxed max-w-[10rem] -rotate-2">
				simple settings<br />nothing more 👌
			</p>

			<!-- Screenshots -->
			<div class="relative flex-1 max-w-sm md:max-w-md">
				<img
					src="{base}/screenshot-app.png"
					alt="The Shy Dock settings window"
					class="relative z-10 rounded-2xl w-full shadow-lg -rotate-1"
				/>
				<img
					src="{base}/screenshot-menubar.png"
					alt="The Shy Dock menu bar"
					class="absolute -bottom-8 right-0 md:-right-16 z-20 w-60 md:w-80 rounded-xl shadow-xl rotate-2"
				/>
			</div>
		</div>
	</div>
</section>
