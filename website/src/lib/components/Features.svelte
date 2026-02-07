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

<section bind:this={sectionEl} class="py-16 md:py-24 px-6">
	<div
		class="max-w-xl mx-auto transition-all duration-700 ease-out {visible
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-6'}"
	>
		<div class="border-t border-border dark:border-night-border pt-12 md:pt-16 space-y-10 text-center">
			<p class="font-serif text-2xl md:text-3xl leading-relaxed tracking-tight">
				Connect a display — it peeks out. 👀<br />
				Disconnect — it hides again.
			</p>

			<div class="flex flex-col gap-3 text-text-secondary dark:text-text-secondary-dark text-base">
				<p>Filter by resolution — only the displays you care about.</p>
				<p>Starts at login, lives in your menu bar.</p>
			</div>

			<img
				src="{base}/app-icon.png"
				alt="The Shy Dock"
				class="w-16 h-16 mx-auto mt-6 opacity-80"
			/>
		</div>
	</div>
</section>
