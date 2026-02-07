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
		<p class="text-center font-serif text-2xl md:text-3xl tracking-tight mb-14">
			Simple settings. Nothing more.
		</p>

		<div class="relative mx-auto max-w-md md:max-w-lg">
			<!-- Settings window — slight tilt -->
			<img
				src="{base}/screenshot-app.png"
				alt="The Shy Dock settings window"
				class="relative z-10 rounded-2xl w-full shadow-lg -rotate-1"
			/>

			<!-- Menu bar — opposite tilt, overlapping bottom-right -->
			<img
				src="{base}/screenshot-menubar.png"
				alt="The Shy Dock menu bar"
				class="absolute -bottom-8 right-0 md:-right-16 z-20 w-60 md:w-80 rounded-xl shadow-xl rotate-2"
			/>
		</div>
	</div>
</section>
